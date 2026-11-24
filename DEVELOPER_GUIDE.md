# Parlami - Developer Guide (LLM Handoff)

Ce document est fait pour etre copie-colle dans un autre LLM afin d'obtenir des suggestions d'amelioration pertinentes et contextualisees.

## 1. Objectif Produit

Parlami est une application Flutter d'apprentissage de l'italien avec 5 onglets principaux:
- Apprendre
- S'entrainer
- Se tester
- Resultats
- Profil

Le projet est mobile-first, avec support Android/iOS/Web/Desktop via Flutter.

## 2. Stack Technique

- Flutter (SDK Dart `^3.5.4`)
- `just_audio` pour la lecture audio
- `just_audio_background` + `audio_service` pour lecture en arriere-plan + notification media
- `audio_session` pour config session audio
- `shared_preferences` pour persistance locale
- `rxdart` (BehaviorSubject) pour etat reactif simple
- `supabase_flutter` pour les comptes utilisateurs (optionnel a la compilation)

## 3. Arborescence Utile

### Entree et shell
- `lib/main.dart`: bootstrap + `JustAudioBackground.init(...)`
- `lib/src/app.dart`: `MaterialApp` + `_HomeShell` + `NavigationBar`

### Modules "Apprendre"
- `lib/src/learn/conjugation/`: quiz conjugaison (module le plus avance)
- `lib/src/learn/vocab/`
- `lib/src/learn/numdate/`
- `lib/src/learn/grammar/`: quiz QCM sur asset JSON (articles, prepositions, plurals, presente, passato prossimo, pronoms, adjectifs)
- `lib/src/learn/spelling/`: dictee de vocabulaire (`spelling_checker.dart` : comparaison exacte puis insensible aux accents)

### Modules "S'entrainer"
- `lib/src/train/eo/`: expression orale
- `lib/src/train/co/`: comprehension orale (radio live integree)
- `lib/src/train/ce/`: comprehension ecrite
- `lib/src/train/ee/`: expression ecrite

### Module "Se tester"
- `lib/src/evaluate/evaluate_engine.dart`: moteur pur et testable qui compose des sessions melangees (QCM grammaire, traduction, phrases EE, auto-evaluation EO) selon le scenario
- `lib/src/evaluate/evaluate_view.dart`: scenarios jouables de bout en bout avec resume et enregistrement des tentatives
- Principe: combiner plusieurs competences simultanement (ex: CO + EO, CE + EE)

### Comptes utilisateurs (Supabase)
- `lib/src/auth/supabase_config.dart`: URL + cle publishable integrees (surchargables via dart-define)
- `lib/src/auth/auth_service.dart`: singleton d'authentification (connexion, inscription, deconnexion, mode invite, synchronisation des reglages)
- `lib/src/auth/auth_gate.dart`: ecran de connexion tant qu'il n'y a ni session ni mode invite
- `lib/src/auth/login_view.dart`: connexion / inscription / mot de passe oublie / choix de langue / continuer sans compte
- `lib/src/settings/language_names.dart`: noms des langues partages
- `scripts/supabase_schema.sql`: table `profiles` (nom, langue, theme) + RLS + trigger
- Guide complet: `docs/supabase_setup.md`. La session persiste entre les lancements; en mode invite tout reste local.

### Donnees et logique
- `lib/src/data/models/`: modeles metier
- `lib/src/repositories/`: acces/indexation des donnees
- `lib/src/data/models/performance_attempt.dart`: contrat commun d'une tentative d'exercice
- `lib/src/repositories/performance_repository.dart`: persistance locale des performances par competence
- `lib/src/services/retention_reminder_service.dart`: rappels quotidiens avec implementations natives/Web conditionnelles
- `lib/src/services/study_session_tracker.dart`: mesure du temps actif par module, suspendue en arriere-plan
- `lib/src/services/asset_loader.dart`: chargement JSON + cache
- `lib/src/services/quiz_prefs.dart`: persistance pref quiz
- `lib/src/services/radio_player_service.dart`: service radio live

### Localisation
- `lib/src/localization/app_*.arb`: source unique des chaînes d'interface, un fichier par langue.
- `lib/src/localization/app_localizations.dart`: fichier généré par Flutter, ne pas modifier manuellement.
- `lib/src/settings/settings_service.dart`: persistance locale de la langue choisie.
- `lib/src/settings/settings_controller.dart`: état observable de la langue et du thème.

Langues d'interface supportées: `fr`, `en`, `es`, `de`, `pt`, `ar`, `ru`, `ja`, `he`, `pl`, `ro`, `sv`, `tr`.

Les pages HTML publiques sont rangées dans `web-pages/privacy/<lang>/` et
`web-pages/download/<lang>/`. Netlify les publie respectivement sous
`/privacy/<lang>/` et `/download/<lang>/`; les URLs sans langue redirigent
vers la version française.

### Règles de modification pour les humains et les IA
1. Toute nouvelle chaîne visible doit être ajoutée à `app_en.arb` et `app_fr.arb`, puis à tous les autres fichiers `app_*.arb` avant d'être utilisée dans un widget.
2. Ne jamais modifier `app_localizations*.dart` à la main: lancer `flutter gen-l10n` après une modification ARB.
3. Ne pas mettre de texte d'interface dans les modèles, repositories ou assets métier. Les données pédagogiques restent séparées des chaînes UI.
4. Pour un texte dynamique, utiliser un message ARB avec paramètres plutôt qu'une concaténation dans le widget.
5. Après chaque lot de localisation, lancer `flutter analyze` puis les tests ciblés. Une modification de langue doit être vérifiée en changeant la locale depuis le profil et après redémarrage.
6. Toute nouvelle langue doit être ajoutée simultanément aux ARB, à `AppLocalizations.supportedLocales` si nécessaire, et au sélecteur du profil.

### Assets
- `assets/conjugaison/*.json`
- `assets/vocabulaire/vocab_apprendreitalien-vocabulaire.json`
- `assets/train/eo_questions.json`
- `assets/train/ee_sentences.json`
- Grammaire (`assets/grammar/grammar_questions.json`): `id, topic, level, prompt, sentence (avec ___), options, answerIndex, explanation`
- Stations radio (`assets/radio/stations.json`) chargees par `lib/src/repositories/radio_stations_repository.dart`

## 4. Etat Fonctionnel Actuel

### 4.1 Conjugaison
- Filtrage par regularite et groupe verbal
- Autocomplete infinitif/traduction
- Quiz multi-pronoms
- Gestion de formes multiples (string/array/object dans les JSON)
- Persistance de preferences via `SharedPreferences`
- Chaque verification est maintenant enregistree dans `performance_attempts` avec la reussite globale,
  le mode, le temps, le verbe et le detail de reussite par personne.

### 4.2 Performances transverses
Les resultats des exercices ne sont pas stockes dans `QuizPrefs` ni dans les modeles pedagogiques.
`PerformanceAttempt` fournit un contrat volontairement generique :
- `skill`: competence (`conjugation`, `numdate`, `eo`, `ee`, etc.)
- `exerciseType`: sous-type (`verb_forms`, `number`, `oral`, etc.)
- `itemId`: identifiant stable de l'element travaille
- `correct`: resultat objectif nullable
- `rating`: auto-evaluation qualitative nullable, utile pour EO
- `durationMs`: duree optionnelle
- `metadata`: contexte structure comme le mode, le temps, les personnes ou le niveau

Le depot utilise le meme stockage local Sembast que le vocabulaire, dans le store
`performance_attempts`. Les nouveaux modules doivent enregistrer une tentative au moment
ou la reponse est validee, et non a la destruction de la vue. Cela preserve les sessions
interrompues et permet a l'ecran Resultats de rester independant des widgets d'exercice.

Les points d'enregistrement actuels sont :
- conjugaison : verification multi-personnes, avec agregation par mode/temps/personne ;
- nombres/dates : corrections separees pour nombres, dates et heures ;
- EE : correction de traduction ;
- EO : auto-evaluation sur 0-3, niveau, mode et durees de parole/hesitation.

Les tentatives de nombres portent aussi une bande de difficulte selon la grandeur (`0-99`,
`100-999`, `1 000-9 999`, `10 000-999 999`, `1 000 000+`). Les temps de reponse des exercices
conjugaison, nombres/dates et EE alimentent une estimation du temps d'etude par competence.
Le temps affiche dans Resultats provient des sessions actives du tracker, et non d'un simple
ecart entre deux clics. Les sessions sont suspendues quand l'application passe en arriere-plan.

L'ecran Resultats conserve une vue synthetique et depliable : les indicateurs generaux restent
visibles, tandis que les details par temps et personne sont accessibles dans la carte Conjugaison.
Les nombres/dates, EO et EE peuvent ajouter leurs propres tentatives sans modifier ce contrat.

### 4.2 CO (radio live)
- Stations italiennes hardcodees dans `lib/src/train/co/co_view.dart`
- Bouton On/Off unique (pas de distinction pause/stop dans l'UX)
- Barre de lecture en bas avec etat "En direct"
- Notification media Android/iOS via `just_audio_background`
- Arret explicite lors de la fermeture/detach app (`AppLifecycleListener` dans `lib/src/app.dart`)

### 4.3 Resultats / Grammaire / Orthographe
- Resultats affiche maintenant les statistiques historiques de vocabulaire et de conjugaison.
- Resultats affiche une activite globale (vocabulaire et tentatives), le temps mesure par competence,
  un objectif compare a la veille, des bandes de difficulte numerique et une matrice conjugaison
  temps/personne. Les details sont regroupes dans des cartes et sections depliees.
- Le snapshot de Resultats est mis en cache pendant la navigation ; un geste de rafraichissement
  force la relecture des donnees.
- Les reglages de notifications appartiennent a Profil, pas a Resultats.
- Grammaire : quiz QCM de 10 questions tirees au hasard, tentatives enregistrees avec metadata
  topic/level. Contenu a enrichir dans `assets/grammar/grammar_questions.json`.
- Orthographe : dictee fr -> it depuis l'asset vocabulaire, en priorisant les mots sensibles
  (accents, doubles consonnes, ci/gi/gli). Trois etats de correction : exacte, presqu'exacte
  (accents/doubles), incorrecte. Tentatives enregistrees avec metadata accentOnlyMismatch.
- Les rappels Android/iOS utilisent `flutter_local_notifications` avec demande de permission.
  Le Web utilise l'API Notification du navigateur lorsqu'elle est disponible ; un onglet ferme
  ne permet pas de planifier un rappel fiable sans service worker/PWA.
- Profil propose "Effacer les donnees locales" (`lib/src/services/local_data_service.dart`) :
  vide les stores Sembast (tentatives, stats vocabulaire, mots utilisateur) et les reglages
  d'exercices, sans toucher a la session auth ni a la langue/theme.

### 4.4 Se tester (mise en conditions reelles)
- Scenarios jouables: chaque carte lance une session generee par `EvaluateEngine`:
  - Conversation quotidienne: 2 orales + 2 QCM + 1 traduction
  - Resume d'article: 3 phrases + 2 QCM
  - Debrief de match: 2 QCM + 2 orales + 1 traduction
  - Discussion rapide: 3 traductions + 2 QCM + 1 orale
- Les orales sont auto-evaluees 0-3 ; QCM et reponses tapees donnent une reussite objective ;
  la session se clot par une carte de score et une moyenne d'auto-evaluation.
- A faire: brancher la CO (radio) et la CE (sources d'articles) dans les scenarios.
- Role pedagogique:
  - Apprendre -> bases
  - S'entrainer -> points particuliers
  - Se tester -> maitrise globale en contexte reel

## 5. Flux Radio (Important)

1. UI CO appelle `RadioPlayerService.toggleStation(name, url)`.
2. Si meme station + lecture en cours: `stop()`.
3. Sinon: `_startStation(...)` charge la source et lance `play()`.
4. Le service publie les etats via streams:
   - `isPlayingStream`
   - `currentStationStream`
   - `errorStream`
5. La notification media est geree au niveau plateforme via `just_audio_background`.

## 6. Config Plateforme Audio

### Android
- `android/app/src/main/kotlin/com/example/parlami/MainActivity.kt` herite de `AudioServiceActivity`.
- `android/app/src/main/AndroidManifest.xml` contient:
  - `FOREGROUND_SERVICE`
  - `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
  - service `com.ryanheise.audioservice.AudioService`
  - receiver `MediaButtonReceiver`

### iOS
- `ios/Runner/Info.plist` contient `UIBackgroundModes` avec `audio`.

## 7. Donnees: Format Minimal

### Conjugaison (`assets/conjugaison/*.json`)
- `infinitive`: string
- `translation`: string?
- `conjugations`: map imbriquee `mood -> tense -> person -> form`

`form` peut etre:
- string
- list<string>
- map<string, dynamic>

### Vocab (`assets/vocabulaire/vocab_apprendreitalien-vocabulaire.json`)
- `it`, `fr`, `theme`, `level`

### EO (`assets/train/eo_questions.json`)
- `prompt`, `level`, `expectedAnswer?`

### EE (`assets/train/ee_sentences.json`)
- `fr`, `it`, `level`

## 8. Dette Technique Connue

- Service radio base sur singleton + `BehaviorSubject` (pas de couche state management formelle).
- Couverture de tests insuffisante sur train/co et cycle de vie audio.
- Ecran Resultats tres durcode en francais (chaînes non localisees) alors que le reste de l'app
  supporte 13 langues.
- Grammaire/orthographe fonctionnels mais au contenu a enrichir (plus de questions, niveaux B2+,
  fiches de cours lues avant les quiz).

## 9. Pistes d'Amelioration Prioritaires

### P0 - Stabilite / Qualite
- Ajouter tests widget + integration sur le flux CO (foreground/background/notification/stop au detach).
- Centraliser l'etat radio (eventuellement `ChangeNotifier`, Riverpod, Bloc).
- Durcir la gestion d'erreurs reseau (timeouts, retry progressif, fallback station).

### P1 - Produit
- Localiser les chaînes durcodees de l'ecran Resultats (`_TodayActionTab`, cartes, sections).
- Brancher CO (radio) et CE (articles) dans les scenarios "Se tester".
- Ajouter des fiches de cours de grammaire (lecture) avant les quiz et enrichir la banque de questions.

### P2 - Performance / Maintenabilite
- Factoriser les patterns de chargement d'assets et mapping modele.
- Standardiser la navigation et la gestion d'etat transversale.
- Ajouter CI minimale: `flutter analyze`, `flutter test`.

## 10. Commandes Dev

- Installer deps: `flutter pub get`
- Lancer app: `flutter run`
- Analyse statique: `flutter analyze`
- Tests: `flutter test`

## 11. Prompt Pret a Copier pour un autre LLM

Utilise ce contexte pour auditer le projet Flutter "Parlami".

Objectif:
- Proposer un plan d'amelioration concret en 3 phases (P0/P1/P2)
- Donner des changements architecture + tests + UX priorises
- Fournir des recommandations applicables sans reecriture complete

Contexte cle:
- App Flutter d'apprentissage italien, modules Learn/Train/Evaluate/Results/Profile
- Module Conjugaison deja avance
- Module CO utilise just_audio + background media notification
- Radio live avec logique On/Off unique
- Module Se tester centre scenarios multi-competences du quotidien
- Plusieurs ecrans encore placeholders
- Donnees majoritairement chargees depuis JSON assets

Contraintes:
- Garder compatibilite Flutter actuelle
- Eviter une migration lourde immediate
- Prioriser stabilite, testabilite, et lisibilite du code
