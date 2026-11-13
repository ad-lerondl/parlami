# Comptes utilisateurs avec Supabase

Ce document decrit le fonctionnement des comptes utilisateurs dans Parlami.

## Vue d'ensemble

- Authentification par e-mail + mot de passe, geree par Supabase Auth.
- Ecran de connexion toujours affiche au premier lancement, avec deux alternatives :
  - **Continuer sans compte** (mode invite) : acces complet a l'application, rien n'est synchronise.
  - **Creer un compte / Se connecter** : les reglages et le profil sont synchronises.
- La session Supabase persiste entre les lancements : un utilisateur connecte
  revient directement dans l'application (pas de re-login a chaque ouverture).
- **Donnees synchronisees par compte** (table `profiles`) : nom affiche, langue et
  theme. Appliquees au demarrage pour un utilisateur connecte, poussees a chaque
  changement. En mode invite, tout reste local.
- Cles Supabase integrees dans `lib/src/auth/supabase_config.dart`. La cle
  `anon`/publishable est concue pour etre embarquee dans une application cliente ;
  la securite repose sur les policies RLS. Ne jamais commiter la cle `service_role`.
  Les `--dart-define` `SUPABASE_URL` / `SUPABASE_ANON_KEY` permettent de pointer
  vers un autre projet sans modifier le code.

## Fichiers du module

| Fichier | Role |
| --- | --- |
| `lib/src/auth/supabase_config.dart` | URL + cle publishable (surchargables via `--dart-define`) |
| `lib/src/auth/auth_service.dart` | Singleton d'authentification : connexion, inscription, deconnexion, mode invite, synchronisation des reglages |
| `lib/src/auth/auth_gate.dart` | Ecran de connexion tant qu'il n'y a ni session ni mode invite |
| `lib/src/auth/login_view.dart` | Connexion / inscription / mot de passe oublie / choix de langue / mode invite |
| `lib/src/settings/language_names.dart` | Noms des langues partages (ecran de connexion + profil) |
| `scripts/supabase_schema.sql` | Table `profiles` + policies RLS + trigger + colonnes de reglages |

## Etape 1 - Creer le projet Supabase

1. Aller sur [supabase.com](https://supabase.com) et creer un compte (gratuit).
2. `New project` : nom `parlami`, region proche des utilisateurs (ex. `West EU (Paris)`),
   et un mot de passe base de donnees solide (a conserver).
3. Attendre la fin du provisionnement (1-2 minutes).

## Etape 2 - Creer la table des profils

1. Dans le tableau de bord, ouvrir `SQL Editor` puis `New query`.
2. Copier-coller tout le contenu de [`scripts/supabase_schema.sql`](../scripts/supabase_schema.sql)
   et cliquer sur `Run`.
3. Verifier dans `Table Editor` que la table `public.profiles` apparait avec ses
   colonnes `display_name`, `locale` et `theme_mode`.

Le script est idempotent : le reexecuter (par exemple apres une mise a jour du
depot) ajoute les colonnes manquantes sans rien casser.

## Etape 3 - Verifier la configuration Auth

1. `Authentication` > `Providers` > `Email` : active par defaut, ne rien changer.
2. `Authentication` > `Sign In / Up` :
   - Pour tester rapidement, desactiver `Confirm email` (pas d'e-mail de confirmation).
   - En production, garder la confirmation activee : l'application affiche alors le
     message « Verifie ta boite mail » apres l'inscription.
3. Plus tard (production) : ajouter l'URL du site dans
   `Authentication` > `URL Configuration` > `Site URL` et `Redirect URLs`
   (ex. `https://learn-parlami.netlify.app/**`).

## Etape 4 - Lancer l'application

Aucune configuration n'est necessaire, les cles sont integrees :

```bash
flutter run
```

Pour pointer vers un autre projet Supabase (test, staging) :

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://autre-projet.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=...
```

Pour la version web de production, le build Netlify actuel fonctionne tel quel.

## Etape 5 - Tester

1. Lancer l'app : l'ecran de connexion apparait, avec le selecteur de langue en haut.
2. `Continuer sans compte` : l'application s'ouvre directement ; le Profil affiche
   « Non connecte » avec un bouton « Se connecter ».
3. Depuis le mode invite, `Se connecter` (Profil) : la connexion ramene dans l'app
   en mode connecte.
4. `Pas encore de compte ? Cree-le` : saisir e-mail, mot de passe, prenom, valider.
   Selon la config : connexion directe ou message de confirmation par e-mail.
5. Connecte : changer la langue ou le theme, se deconnecter, se reconnecter —
   les reglages sont restaures depuis Supabase.
6. Tuer puis relancer l'app : la session persiste, pas de re-connexion demandee.

## Etapes suivantes (hors V1 auth)

- **Synchronisation de la progression** : la table `performance_attempts` est
  actuellement locale (Sembast). Une migration vers une table Supabase
  `performance_attempts` (colonne `user_id`, policies RLS) permettra de
  retrouver ses resultats sur tous les appareils.
- Connexion Google / Apple (OAuth) : necessite la config des deep links
  Android/iOS et des redirect URLs web.
- Modification du nom affiche depuis le profil (update de `profiles`).
