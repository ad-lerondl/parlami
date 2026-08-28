# Parlami

Application Flutter d'apprentissage de l'italien (mobile/web/desktop) organisee par modules.

## Quick Start

- Prerequis: Flutter recent compatible avec SDK Dart `^3.5.4`
- Installer les dependances: `flutter pub get`
- Lancer l'app: `flutter run`
- Analyse statique: `flutter analyze`
- Tests: `flutter test`

## Structure Produit

- Apprendre: Conjugaison, Vocabulaire, Nombres et Dates, Grammaire, Orthographe
- S'entrainer: EO (expression orale), CO (comprehension orale), CE, EE
- Se tester: scenarios realistes combinant plusieurs competences en meme temps
- Resultats
- Profil

Tri pedagogique:
- Apprendre: poser les bases
- S'entrainer: travailler des points particuliers
- Se tester: valider la maitrise en condition reelle

## Points Forts Actuels

- Module Conjugaison deja riche (filtres, quiz multi-pronoms, persistance)
- Chargement de donnees depuis JSON assets avec cache
- Module CO avec radio live integree
- Nouveau module Se tester pour la mise en conditions reelles
- Support lecture audio en arriere-plan avec notification media

## Radio CO: Etat Actuel

- Service principal: `lib/src/services/radio_player_service.dart`
- UI principale: `lib/src/train/co/co_view.dart`
- Initialisation background media: `lib/main.dart`
- Arret a la fermeture app (detach): `lib/src/app.dart`

Comportement UX voulu:
- Controle unique On/Off pour le live
- Lecture maintenue en arriere-plan
- Notification media disponible

## Donnees

- Conjugaison: `assets/conjugaison/*.json`
- Vocabulaire: `assets/vocabulaire/vocab_apprendreitalien-vocabulaire.json`
- Entrainement EO/EE: `assets/train/*.json`

## Documentation pour IA/Dev

Pour un contexte complet architecture + dette technique + priorites d'amelioration, voir:
- `DEVELOPER_GUIDE.md`

Ce fichier est concu pour etre partage tel quel a un autre LLM pour obtenir des recommandations de refacto, tests et roadmap.

## Lien Don

`https://donate.stripe.com/5kQ6oH5y5bHf58r2VFdMI02`
