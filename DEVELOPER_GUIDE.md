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

## 3. Arborescence Utile

### Entree et shell
- `lib/main.dart`: bootstrap + `JustAudioBackground.init(...)`
- `lib/src/app.dart`: `MaterialApp` + `_HomeShell` + `NavigationBar`

### Modules "Apprendre"
- `lib/src/learn/conjugation/`: quiz conjugaison (module le plus avance)
- `lib/src/learn/vocab/`
- `lib/src/learn/numdate/`
- `lib/src/learn/grammar/` (placeholder)
- `lib/src/learn/spelling/` (placeholder)

### Modules "S'entrainer"
- `lib/src/train/eo/`: expression orale
- `lib/src/train/co/`: comprehension orale (radio live integree)
- `lib/src/train/ce/`: comprehension ecrite
- `lib/src/train/ee/`: expression ecrite

### Module "Se tester"
- `lib/src/evaluate/evaluate_view.dart`: scenarios de mise en condition reelle
- Principe: combiner plusieurs competences simultanement (ex: CO + EO, CE + EE)

### Donnees et logique
- `lib/src/data/models/`: modeles metier
- `lib/src/repositories/`: acces/indexation des donnees
- `lib/src/services/asset_loader.dart`: chargement JSON + cache
- `lib/src/services/quiz_prefs.dart`: persistance pref quiz
- `lib/src/services/radio_player_service.dart`: service radio live

### Assets
- `assets/conjugaison/*.json`
- `assets/vocabulaire/vocab_apprendreitalien-vocabulaire.json`
- `assets/train/eo_questions.json`
- `assets/train/ee_sentences.json`

## 4. Etat Fonctionnel Actuel

### 4.1 Conjugaison
- Filtrage par regularite et groupe verbal
- Autocomplete infinitif/traduction
- Quiz multi-pronoms
- Gestion de formes multiples (string/array/object dans les JSON)
- Persistance de preferences via `SharedPreferences`

### 4.2 CO (radio live)
- Stations italiennes hardcodees dans `lib/src/train/co/co_view.dart`
- Bouton On/Off unique (pas de distinction pause/stop dans l'UX)
- Barre de lecture en bas avec etat "En direct"
- Notification media Android/iOS via `just_audio_background`
- Arret explicite lors de la fermeture/detach app (`AppLifecycleListener` dans `lib/src/app.dart`)

### 4.3 Resultats / Grammaire / Orthographe
- Plusieurs ecrans encore en mode placeholder

### 4.4 Se tester (mise en conditions reelles)
- Scenarios transverses centres vie quotidienne
- Combinaisons de competences, par exemple:
  - Conversation: CO + EO
  - Resume d'article: CE + EE
  - Debrief de match: EO + culture
  - Discussion rapide: CO + EO + rapidite
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
- Station list hardcodee dans la vue CO (pas de repository/source distante).
- Couverture de tests insuffisante sur train/co et cycle de vie audio.
- Onglets Resultats/Grammaire/Orthographe incomplets.
- `supportedLocales` limite a `en` dans `lib/src/app.dart` alors que l'app est majoritairement en francais.

## 9. Pistes d'Amelioration Prioritaires

### P0 - Stabilite / Qualite
- Ajouter tests widget + integration sur le flux CO (foreground/background/notification/stop au detach).
- Centraliser l'etat radio (eventuellement `ChangeNotifier`, Riverpod, Bloc).
- Durcir la gestion d'erreurs reseau (timeouts, retry progressif, fallback station).

### P1 - Produit
- Externaliser stations radio dans un JSON/versionnement.
- Ajouter ecran "Resultats" reel (KPIs, progression par module).
- Completer grammaire/orthographe avec contenu exploitable.

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
