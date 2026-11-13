# Comptes utilisateurs avec Supabase

Ce document decrit la mise en place complete des comptes utilisateurs dans Parlami,
du projet Supabase au lancement de l'application.

## Vue d'ensemble

- Authentification par e-mail + mot de passe, geree par Supabase Auth.
- Table `profiles` (nom affiche) protegee par Row Level Security.
- Configuration injectee a la compilation via `--dart-define` : aucune cle n'est
  versionnee dans le depot.
- **Mode degrade** : sans les variables `SUPABASE_URL` / `SUPABASE_ANON_KEY`,
  l'application demarre comme avant, sans ecran de connexion. Cela permet de
  garder les tests et les builds actuels fonctionnels pendant la transition.

## Fichiers du module

| Fichier | Role |
| --- | --- |
| `lib/src/auth/supabase_config.dart` | Lecture des `--dart-define` + indicateur `isSupabaseConfigured` |
| `lib/src/auth/auth_service.dart` | Singleton d'acces a l'authentification (connexion, inscription, deconnexion, erreurs mappees) |
| `lib/src/auth/auth_gate.dart` | Affiche l'app si une session existe, sinon l'ecran de connexion |
| `lib/src/auth/login_view.dart` | Ecran connexion / inscription / mot de passe oublie |
| `scripts/supabase_schema.sql` | Table `profiles` + policies RLS + trigger de creation automatique |

## Etape 1 - Creer le projet Supabase

1. Aller sur [supabase.com](https://supabase.com) et creer un compte (gratuit).
2. `New project` : nom `parlami`, region proche des utilisateurs (ex. `West EU (Paris)`),
   et un mot de passe base de donnees solide (a conserver).
3. Attendre la fin du provisionnement (1-2 minutes).

## Etape 2 - Creer la table des profils

1. Dans le tableau de bord, ouvrir `SQL Editor` puis `New query`.
2. Copier-coller tout le contenu de [`scripts/supabase_schema.sql`](../scripts/supabase_schema.sql)
   et cliquer sur `Run`.
3. Verifier dans `Table Editor` que la table `public.profiles` apparait.

## Etape 3 - Verifier la configuration Auth

1. `Authentication` > `Providers` > `Email` : active par defaut, ne rien changer.
2. `Authentication` > `Sign In / Up` :
   - Pour tester rapidement, desactiver `Confirm email` (pas d'e-mail de confirmation).
   - En production, garder la confirmation activee : l'application affiche alors le
     message « Verifie ta boite mail » apres l'inscription.
3. Plus tard (production) : ajouter l'URL du site dans
   `Authentication` > `URL Configuration` > `Site URL` et `Redirect URLs`
   (ex. `https://learn-parlami.netlify.app/**`).

## Etape 4 - Recuperer les cles

Dans `Project Settings` > `API` (ou `Data API`) :
- `Project URL` : l'URL du projet (ex. `https://xxxx.supabase.co`).
- `anon public` : la cle publique anonyme.

La cle `anon` n'est pas un secret : elle est concue pour etre embarquee dans une
application cliente. La securite repose sur les policies RLS de l'etape 2.
Ne jamais commiter la cle `service_role`.

## Etape 5 - Lancer l'application

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
```

Pour la version web de production (Netlify) :

```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

Sur Netlify : ajouter `SUPABASE_URL` et `SUPABASE_ANON_KEY` dans
`Site settings` > `Environment variables`, puis adapter le `command` de
`netlify.toml` avec les deux `--dart-define`.

## Etape 6 - Tester

1. Lancer l'app : l'ecran de connexion apparait.
2. `Pas encore de compte ? Cree-le` : saisir e-mail, mot de passe, prenom, valider.
3. Selon la config : connexion directe ou message de confirmation par e-mail.
4. Onglet Profil : la section `Compte` affiche le nom et l'e-mail, avec `Se deconnecter`.
5. Se deconnecter puis se reconnecter pour valider le cycle complet.

## Etapes suivantes (hors V1 auth)

- **Synchronisation des performances** : la table `performance_attempts` est
  actuellement locale (Sembast). Une migration vers une table Supabase
  `performance_attempts` (colonne `user_id`, policies RLS) permettra de
  retrouver ses resultats sur tous les appareils.
- Connexion Google / Apple (OAuth) : necessite la config des deep links
  Android/iOS et des redirect URLs web.
- Modification du nom affiche depuis le profil (update de `profiles`).
