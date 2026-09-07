// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Apprendre';

  @override
  String get navTrain => 'S\'entraîner';

  @override
  String get navEvaluate => 'Se tester';

  @override
  String get navResults => 'Résultats';

  @override
  String get navProfile => 'Profil';

  @override
  String get learnConjugation => 'Conjugaison';

  @override
  String get learnConjugationDescription => 'S\'entraîner à conjuguer';

  @override
  String get learnVocabulary => 'Vocabulaire';

  @override
  String get learnVocabularyDescription => 'Par thèmes et niveaux';

  @override
  String get learnNumbersDates => 'Nombres & Dates';

  @override
  String get learnNumbersDatesDescription => 'Écrire les nombres et dates';

  @override
  String get learnGrammar => 'Grammaire';

  @override
  String get learnGrammarDescription => 'Fiches de cours';

  @override
  String get learnSpelling => 'Orthographe';

  @override
  String get learnSpellingDescription => 'Bientôt disponible';

  @override
  String get trainOralExpression => 'EO - Expression orale';

  @override
  String get trainOralExpressionDescription => 'Répondre à voix haute';

  @override
  String get trainOralComprehension => 'CO - Compréhension orale';

  @override
  String get trainOralComprehensionDescription => 'Écouter des stations radio';

  @override
  String get trainWrittenComprehension => 'CE - Compréhension écrite';

  @override
  String get trainWrittenComprehensionDescription => 'Lire des news italiennes';

  @override
  String get trainWrittenExpression => 'EE - Expression écrite';

  @override
  String get trainWrittenExpressionDescription => 'Traduire des phrases';

  @override
  String get evaluateTitle => 'Se tester - Conditions réelles';

  @override
  String get evaluateIntro =>
      'Ici, tu combines plusieurs compétences en même temps pour simuler des situations réelles.';

  @override
  String get evaluateProgression =>
      'Apprendre pose les bases. S\'entraîner travaille des points isolés. Se tester mesure ta maîtrise globale.';

  @override
  String get scenarioDailyConversation => 'Conversation du quotidien';

  @override
  String get scenarioArticleSummary => 'Résumé d\'article';

  @override
  String get scenarioMatchDebrief => 'Débrief de match';

  @override
  String get scenarioQuickDiscussion => 'Discussion rapide';

  @override
  String get scenarioDailyConversationDetails =>
      'Écouter, comprendre puis répondre naturellement.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Lire un texte puis produire un résumé clair et structuré.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Parler d\'un match en mobilisant vocabulaire et références culturelles.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'Réagir vite dans un échange dynamique avec contraintes de temps.';

  @override
  String get resultsComingSoon => 'Graphes de performance (à venir)';

  @override
  String get grammarTitle => 'Grammaire';

  @override
  String get grammarComingSoon =>
      'Fiches de grammaire - contenu à venir.\n\nAjoutez des fiches dans ce module sous forme de pages ou de markdown rendu.';

  @override
  String get spellingTitle => 'Orthographe';

  @override
  String get spellingComingSoon => 'Module d\'orthographe - à venir.';

  @override
  String get ceTitle => 'CE - Compréhension écrite';

  @override
  String get ceIntro =>
      'Lisez des articles en italien pour améliorer votre compréhension écrite';

  @override
  String get ceAdviceTitle => 'Conseil';

  @override
  String get ceAdvice =>
      'Commencez par des articles courts. Lisez d\'abord pour comprendre le sens général, puis relisez pour les détails.';

  @override
  String get ceOpenSource => 'Ouvrir le site de la source';

  @override
  String get eeTitle => 'EE - Expression écrite';

  @override
  String get eePrompt => 'Traduisez la phrase suivante en italien';

  @override
  String get eeTranslationLabel => 'Votre traduction en italien';

  @override
  String get eeTranslationHint => 'Écrivez votre traduction ici...';

  @override
  String get eeCheck => 'Vérifier';

  @override
  String get eeCorrection => 'Correction';

  @override
  String get eeYourAnswer => 'Votre réponse';

  @override
  String get coTitle => 'CO - Compréhension orale';

  @override
  String get coIntro =>
      'Écoutez des radios italiennes pour améliorer votre compréhension orale';

  @override
  String get coLive => 'En direct :';

  @override
  String coStopped(Object station) {
    return '$station arrêtée';
  }

  @override
  String coConnecting(Object station) {
    return 'Connexion à $station...';
  }

  @override
  String get coPlay => 'Écouter';

  @override
  String get coStop => 'Arrêter';

  @override
  String get coPause => 'Pause';

  @override
  String get coResume => 'Reprendre';

  @override
  String get coRadioGeneral => 'Radio généraliste italienne';

  @override
  String get coMusicEntertainment => 'Musique et divertissement';

  @override
  String get coCultureNews => 'Culture et actualités';

  @override
  String get coPopNews => 'Musique pop et actualités';

  @override
  String get coRadioNewsMusic => 'Actualités et musique';

  @override
  String get coNational => 'National';

  @override
  String get ceAnsaDescription =>
      'Agence de presse italienne - articles courts';

  @override
  String get ceRepubblicaDescription => 'Grand quotidien italien';

  @override
  String get ceCorriereDescription => 'Journal de référence';

  @override
  String get ceIlPostDescription => 'Actualités et analyses';

  @override
  String get ceRaiDescription => 'Actualités de la RAI';

  @override
  String get ceEasyItalianDescription => 'Nouvelles en italien facile';

  @override
  String get eoTitle => 'EO - Expression orale';

  @override
  String get eoChooseLevel => 'Choisir le niveau';

  @override
  String eoLevel(String level) {
    return 'Niveau $level';
  }

  @override
  String get eoNoQuestion => 'Aucune question disponible';

  @override
  String get eoQuestion => 'Question';

  @override
  String get eoHint => 'Indice';

  @override
  String get eoClickHint => 'Cliquer pour un indice';

  @override
  String get eoAnswerHint => 'Piste de réponse';

  @override
  String get eoClickAnswerHint => 'Cliquer pour une piste de réponse';

  @override
  String get eoTimer => 'Chronomètre';

  @override
  String get eoTotal => 'Total';

  @override
  String get eoSpeech => 'Parole';

  @override
  String get eoHesitation => 'Hésitation';

  @override
  String get eoStart => 'Démarrer';

  @override
  String get eoStop => 'Arrêter';

  @override
  String get eoReset => 'Réinitialiser';

  @override
  String get eoModeFree => 'Mode libre';

  @override
  String get eoModeFreeDescription => 'Tu avances quand tu veux, sans aide.';

  @override
  String get eoModeEasy => 'Facile';

  @override
  String get eoModeEasyDescription =>
      'Réponds puis auto-évalue-toi et regarde une piste de réponse.';

  @override
  String get eoModeHard => 'Difficile';

  @override
  String get eoModeHardDescription =>
      'Chrono, suivi des hésitations et auto-évaluation.';

  @override
  String eoLevelChip(Object level) {
    return 'Niveau $level';
  }

  @override
  String get eoSelfEvaluation => 'Auto-évaluation';

  @override
  String get eoExcellent => 'Excellent';

  @override
  String get eoGood => 'Bien';

  @override
  String get eoAverage => 'Moyen';

  @override
  String get eoDifficult => 'Difficile';

  @override
  String get eoNextQuestion => 'Question suivante';

  @override
  String get numDateTitle => 'Nombres & Dates';

  @override
  String get numDateNumbersTab => 'Nombres';

  @override
  String get numDateDatesTab => 'Dates';

  @override
  String get numDateTimeTab => 'Heure';

  @override
  String get numDatePreviewNumberTitle => 'Choisir le nombre d’aperçu';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Cette valeur sert uniquement à la conversion rapide.';

  @override
  String get numDatePreviewNumberLabel => 'Nombre d’aperçu';

  @override
  String get numDatePositiveInteger =>
      'Saisis un entier positif pour démarrer.';

  @override
  String get numDateTraining => 'Entraînement';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Choisis un autre nombre pour t’entraîner à l’écrire en lettres italiennes.';

  @override
  String get numDateTrainingNumberLabel => 'Nombre d’entraînement';

  @override
  String get numDateAnswerInWords => 'Ta réponse en lettres';

  @override
  String get numDateCheck => 'Vérifier';

  @override
  String get numDateClear => 'Effacer';

  @override
  String get numDatePreviewDateTitle => 'Choisir la date d’aperçu';

  @override
  String get numDatePreviewDateSubtitle =>
      'Cette date sert uniquement de référence rapide.';

  @override
  String get numDateToday => 'Aujourd’hui';

  @override
  String get numDateTrainingDateSubtitle =>
      'Choisis une autre date pour t’entraîner à l’écrire en lettres italiennes.';

  @override
  String numDateExpectedDay(String day) {
    return 'Jour attendu : $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Choisir l’heure d’aperçu';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Cette heure sert uniquement de lecture rapide.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Choisis une autre heure pour t’entraîner, surtout sur les quarts d’heure.';

  @override
  String get numDateDefinedTime => 'Heure définie :';

  @override
  String get answerCorrect => 'Bonne réponse.';

  @override
  String get answerIncorrect => 'Réponse incorrecte.';

  @override
  String answerYourAnswer(String answer) {
    return 'Ta réponse : $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Bonne réponse : $answer';
  }

  @override
  String get conjugationTitle => 'Conjugaison';

  @override
  String get conjugationRegular => 'Réguliers';

  @override
  String get conjugationSemiRegular => 'Semi-réguliers';

  @override
  String get conjugationIrregular => 'Irréguliers';

  @override
  String get conjugationPronominal => 'Pronominaux';

  @override
  String conjugationGroup(Object group) {
    return 'Groupe $group';
  }

  @override
  String conjugationAuxiliary(Object auxiliary) {
    return 'Auxiliaire $auxiliary';
  }

  @override
  String get conjugationShowAnswers => 'Afficher';

  @override
  String get conjugationHideAnswers => 'Masquer';

  @override
  String get conjugationNonPronominal => 'Non pronominaux';

  @override
  String get conjugationDetailsVisibility =>
      'Afficher les caractéristiques du verbe';

  @override
  String get conjugationClearFilters => 'Supprimer tous les filtres';

  @override
  String get conjugationChooseVerb => 'Choisir un verbe';

  @override
  String get conjugationRandomVerb => 'Verbe aléatoire';

  @override
  String get conjugationHideBaseVerb => 'Masquer base verbale';

  @override
  String get conjugationChooseMood => 'Choisir un mode';

  @override
  String get conjugationChooseTense => 'Choisir un temps';

  @override
  String conjugationVerb(String verb) {
    return 'Verbe : $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Traduction : $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Mode : $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Temps : $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Erreur de chargement : $error';
  }

  @override
  String get profileLanguage => 'Langue de l\'interface';

  @override
  String get profileUserName => 'Nom de l\'utilisateur';

  @override
  String get profileAbout => 'À propos de l\'application';

  @override
  String get profileAboutDescription => 'Parlami aide à apprendre l\'italien.';

  @override
  String get profileTheme => 'Thème';

  @override
  String get profileThemeDescription => 'Changer entre le mode clair et sombre';

  @override
  String get themeSystem => 'Thème système';

  @override
  String get themeLight => 'Thème clair';

  @override
  String get themeDark => 'Thème sombre';

  @override
  String get vocabTitle => 'Vocabulaire';

  @override
  String get vocabReview => 'Réviser';

  @override
  String get vocabCatalog => 'Catalogue';

  @override
  String get vocabAdd => 'Ajouter';

  @override
  String get vocabImport => 'Importer des mots';

  @override
  String get vocabExport => 'Exporter mes mots';

  @override
  String get vocabResetCatalog => 'Réinitialiser le catalogue d’origine';

  @override
  String get vocabSelect => 'Sélectionner';

  @override
  String get vocabSave => 'Enregistrer le mot';

  @override
  String get vocabChooseCategories => 'Choisir les catégories du mot';

  @override
  String get vocabPasteJson =>
      'Colle ici une liste JSON de mots. Format accepté :';

  @override
  String get vocabCancel => 'Annuler';

  @override
  String vocabImportError(String error) {
    return 'Import impossible : $error';
  }

  @override
  String get vocabResetQuestion => 'Réinitialiser les mots d’origine ?';

  @override
  String get vocabResetDescription =>
      'Cela remet à zéro les mots importés et réapplique le catalogue d’origine. Les mots ajoutés par l’utilisateur sont conservés.';

  @override
  String get vocabDeleteQuestion => 'Supprimer ce mot ?';

  @override
  String vocabDeleteDescription(String word) {
    return 'Supprimer « $word » du catalogue ?';
  }

  @override
  String get vocabDelete => 'Supprimer';

  @override
  String get vocabNoCategory => 'Aucune catégorie sélectionnée';

  @override
  String get vocabLoading => 'Chargement du vocabulaire...';

  @override
  String get vocabFields => 'Champs lexicaux';

  @override
  String get vocabNoMatch => 'Aucun mot ne correspond aux filtres actuels.';

  @override
  String get vocabNoTrainingMatch =>
      'Aucun mot ne correspond aux filtres d’entraînement.';

  @override
  String get vocabTrainingWord => 'Mot d’entraînement';

  @override
  String vocabScore(String score) {
    return 'Score $score %';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Langue de base : $language';
  }

  @override
  String get vocabHiddenAnswer => 'Réponse cachée.';

  @override
  String get vocabKnown => 'Su';

  @override
  String get vocabUnknown => 'Non su';

  @override
  String get vocabNextWord => 'Mot suivant';

  @override
  String vocabCategories(String categories) {
    return 'Catégories : $categories';
  }

  @override
  String get vocabPreparing => 'Préparation des mots d’entraînement...';

  @override
  String get vocabPriority => 'Mots non sus prioritaires';

  @override
  String get vocabPriorityDescription =>
      'Désactive pour mélanger aléatoirement.';

  @override
  String vocabSelectedCount(String count) {
    return 'Mots retenus : $count';
  }

  @override
  String get vocabClearAll => 'Tout effacer';

  @override
  String get vocabConfirm => 'Valider';

  @override
  String get conjugationCheck => 'Vérifier';

  @override
  String get conjugationNextVerb => 'Verbe suivant';

  @override
  String get eeNextSentence => 'Phrase suivante';

  @override
  String get eeNoSentence => 'Aucune phrase disponible';

  @override
  String ceLevel(String level) {
    return 'Niveau : $level';
  }

  @override
  String get sampleItems => 'Éléments d’exemple';

  @override
  String get sampleItemDetails => 'Détails de l’élément';

  @override
  String get sampleMoreInformation => 'Plus d’informations ici';

  @override
  String sampleItem(String id) {
    return 'Élément d’exemple $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Culture';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Rapidité';

  @override
  String get conjugationAnswerLabel => 'Votre réponse';

  @override
  String get vocabWords => 'Mots';

  @override
  String get vocabAverageMastery => 'Maîtrise moyenne';

  @override
  String get vocabMode => 'Mode';

  @override
  String get vocabMastery => 'Maîtrise';

  @override
  String get vocabRandom => 'Aléatoire';

  @override
  String get vocabSearchWord => 'Rechercher un mot';

  @override
  String get vocabBaseLanguageDisplay => 'Langue de base pour l’affichage';

  @override
  String get vocabDifficulty => 'Difficulté';

  @override
  String get vocabPartOfSpeech => 'Genre grammatical';

  @override
  String get vocabChooseFilterCategories => 'Choisir les catégories du filtre';

  @override
  String get vocabSearchTrainingWord => 'Chercher un mot';

  @override
  String get vocabTrainingBaseLanguage => 'Langue de base pour l’entraînement';

  @override
  String get vocabFilters => 'Filtres';

  @override
  String get vocabChooseTrainingCategories =>
      'Choisir les catégories d’entraînement';

  @override
  String get vocabItalianWord => 'Mot italien';

  @override
  String get vocabFrenchTranslation => 'Traduction française';

  @override
  String get vocabOptionalArticle => 'Article éventuel (il, la, l\', etc.)';

  @override
  String get vocabCategoriesTitle => 'Catégories';

  @override
  String get vocabSearchCategory => 'Rechercher une catégorie';

  @override
  String vocabAddCategory(String category) {
    return 'Ajouter \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'Supprimer du catalogue';

  @override
  String get vocabHideAnswer => 'Masquer la réponse';

  @override
  String get vocabShowAnswer => 'Afficher la réponse';

  @override
  String get vocabStatusSaved =>
      'Mot enregistré et disponible dans les filtres.';

  @override
  String vocabStatusImport(String count) {
    return 'Import terminé : $count mot(s) ajoutés.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Export terminé : $location';
  }

  @override
  String get vocabStatusNoExport => 'Aucun mot utilisateur à exporter.';

  @override
  String get vocabStatusReset => 'Catalogue d’origine réinitialisé.';

  @override
  String get vocabStatusDeleted => 'Mot supprimé du catalogue.';

  @override
  String get vocabStatusKnown => 'Bien noté.';

  @override
  String get vocabStatusReview => 'À revoir rapidement.';

  @override
  String get vocabItalian => 'Italien';

  @override
  String get vocabFrench => 'Français';

  @override
  String get vocabSourceOriginal => 'Original';

  @override
  String get vocabSourceUser => 'Utilisateur';

  @override
  String get vocabNoun => 'Nom';

  @override
  String get vocabVerb => 'Verbe';

  @override
  String get vocabAdjective => 'Adjectif';

  @override
  String get vocabAdverb => 'Adverbe';

  @override
  String get vocabPronoun => 'Pronom';

  @override
  String get vocabDeterminer => 'Déterminant';

  @override
  String get vocabPreposition => 'Préposition';

  @override
  String get vocabConjunction => 'Conjonction';

  @override
  String get vocabInterjection => 'Interjection';

  @override
  String get vocabExpression => 'Expression';

  @override
  String get vocabOther => 'Autre';

  @override
  String get profileDonate => 'Faire un don';

  @override
  String get profileDonateDescription => 'Merci pour votre soutien';

  @override
  String get profilePrivacy => 'Politique de confidentialité';

  @override
  String get profilePrivacyDescription =>
      'Ouvrir la politique de confidentialité';

  @override
  String get unavailable => 'Fonctionnalité encore indisponible.';
}
