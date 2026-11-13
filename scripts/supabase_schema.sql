-- Schema Supabase pour les comptes utilisateurs Parlami.
-- A executer dans SQL Editor (https://supabase.com/dashboard) apres creation du projet.
-- Le script est idempotent : il peut etre reexecute sans erreur, il complete
-- uniquement ce qui manque.

-- 1. Table des profils, liee 1-1 aux comptes du module Auth de Supabase.
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  locale text,
  theme_mode text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Colonnes ajoutees apres la V1 : ajoutees uniquement si absentes.
alter table public.profiles add column if not exists display_name text;
alter table public.profiles add column if not exists locale text;
alter table public.profiles add column if not exists theme_mode text;

-- 2. Row Level Security : chaque utilisateur ne voit et ne modifie que son profil.
alter table public.profiles enable row level security;

drop policy if exists "Users can read their own profile" on public.profiles;
create policy "Users can read their own profile"
  on public.profiles for select
  using (auth.uid() = id);

drop policy if exists "Users can insert their own profile" on public.profiles;
create policy "Users can insert their own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- 3. Creation automatique du profil a l'inscription.
--    Le nom affiche saisi a l'inscription est recupere depuis les metadonnees.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, new.raw_user_meta_data ->> 'display_name')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();
