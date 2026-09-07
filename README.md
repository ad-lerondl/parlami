# Parlami

Application Flutter d'apprentissage de l'italien (mobile/web/desktop) organisee par modules.

## License

Parlami's original source code is licensed under the [PolyForm Perimeter License 1.0.1](https://polyformproject.org/licenses/perimeter/1.0.1).

The license permits use, modification, and distribution of the software, but does not permit using Parlami or derivative works to provide a product that competes with Parlami, including competing products offered free of charge.

For commercial licensing or permissions beyond those granted by the license, contact:

**Adam Lérondel**
[ad-lerondl.apps@gmx.fr](mailto:ad-lerondl.apps@gmx.fr)

See the [`LICENSE`](LICENSE) file for the complete license terms.

### Third-party components

Parlami may contain third-party software, libraries, fonts, data, images, or other assets that are subject to their own licenses. Such components remain subject to their respective licenses.

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

La localisation est maintenue dans `lib/src/localization/app_*.arb`. Les changements doivent respecter les regles de migration controlee de la section "Localisation" de `DEVELOPER_GUIDE.md`.

## Lien Don

`https://donate.stripe.com/5kQ6oH5y5bHf58r2VFdMI02`
