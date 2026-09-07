// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Learn';

  @override
  String get navTrain => 'Practice';

  @override
  String get navEvaluate => 'Test yourself';

  @override
  String get navResults => 'Results';

  @override
  String get navProfile => 'Profile';

  @override
  String get learnConjugation => 'Conjugation';

  @override
  String get learnConjugationDescription => 'Practice conjugating verbs';

  @override
  String get learnVocabulary => 'Vocabulary';

  @override
  String get learnVocabularyDescription => 'By topic and level';

  @override
  String get learnNumbersDates => 'Numbers & Dates';

  @override
  String get learnNumbersDatesDescription => 'Write numbers and dates';

  @override
  String get learnGrammar => 'Grammar';

  @override
  String get learnGrammarDescription => 'Course notes';

  @override
  String get learnSpelling => 'Spelling';

  @override
  String get learnSpellingDescription => 'Coming soon';

  @override
  String get trainOralExpression => 'EO - Oral expression';

  @override
  String get trainOralExpressionDescription => 'Answer aloud';

  @override
  String get trainOralComprehension => 'CO - Oral comprehension';

  @override
  String get trainOralComprehensionDescription => 'Listen to radio stations';

  @override
  String get trainWrittenComprehension => 'CE - Written comprehension';

  @override
  String get trainWrittenComprehensionDescription => 'Read Italian news';

  @override
  String get trainWrittenExpression => 'EE - Written expression';

  @override
  String get trainWrittenExpressionDescription => 'Translate sentences';

  @override
  String get evaluateTitle => 'Test yourself - Real-life situations';

  @override
  String get evaluateIntro =>
      'Combine several skills at the same time to simulate real-life situations.';

  @override
  String get evaluateProgression =>
      'Learn builds the foundations. Practice targets specific skills. Test yourself measures your overall mastery.';

  @override
  String get scenarioDailyConversation => 'Everyday conversation';

  @override
  String get scenarioArticleSummary => 'Article summary';

  @override
  String get scenarioMatchDebrief => 'Match debrief';

  @override
  String get scenarioQuickDiscussion => 'Quick discussion';

  @override
  String get scenarioDailyConversationDetails =>
      'Listen, understand, then answer naturally.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Read a text, then produce a clear, structured summary.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Talk about a match using vocabulary and cultural references.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'React quickly in a dynamic exchange with time constraints.';

  @override
  String get resultsComingSoon => 'Performance charts coming soon';

  @override
  String get grammarTitle => 'Grammar';

  @override
  String get grammarComingSoon =>
      'Grammar notes - content coming soon.\n\nAdd notes to this module as pages or rendered Markdown.';

  @override
  String get spellingTitle => 'Spelling';

  @override
  String get spellingComingSoon => 'Spelling module - coming soon.';

  @override
  String get ceTitle => 'CE - Written comprehension';

  @override
  String get ceIntro =>
      'Read Italian articles to improve your written comprehension';

  @override
  String get ceAdviceTitle => 'Advice';

  @override
  String get ceAdvice =>
      'Start with short articles. Read first for the general meaning, then read again for details.';

  @override
  String get ceOpenSource => 'Open source website';

  @override
  String get eeTitle => 'EE - Written expression';

  @override
  String get eePrompt => 'Translate the following sentence into Italian';

  @override
  String get eeTranslationLabel => 'Your translation into Italian';

  @override
  String get eeTranslationHint => 'Write your translation here...';

  @override
  String get eeCheck => 'Check';

  @override
  String get eeCorrection => 'Correction';

  @override
  String get eeYourAnswer => 'Your answer';

  @override
  String get coTitle => 'CO - Oral comprehension';

  @override
  String get coIntro =>
      'Listen to Italian radio stations to improve your oral comprehension';

  @override
  String get coLive => 'Live:';

  @override
  String coStopped(Object station) {
    return '$station stopped';
  }

  @override
  String coConnecting(Object station) {
    return 'Connecting to $station...';
  }

  @override
  String get coPlay => 'Play';

  @override
  String get coStop => 'Stop';

  @override
  String get coPause => 'Pause';

  @override
  String get coResume => 'Resume';

  @override
  String get coRadioGeneral => 'General-interest Italian radio';

  @override
  String get coMusicEntertainment => 'Music and entertainment';

  @override
  String get coCultureNews => 'Culture and news';

  @override
  String get coPopNews => 'Pop music and news';

  @override
  String get coRadioNewsMusic => 'News and music';

  @override
  String get coNational => 'National';

  @override
  String get ceAnsaDescription => 'Italian news agency - short articles';

  @override
  String get ceRepubblicaDescription => 'Major Italian daily newspaper';

  @override
  String get ceCorriereDescription => 'Leading Italian newspaper of record';

  @override
  String get ceIlPostDescription => 'News and analysis';

  @override
  String get ceRaiDescription => 'RAI news';

  @override
  String get ceEasyItalianDescription => 'News in easy Italian';

  @override
  String get eoTitle => 'EO - Oral expression';

  @override
  String get eoChooseLevel => 'Choose the level';

  @override
  String eoLevel(String level) {
    return 'Level $level';
  }

  @override
  String get eoNoQuestion => 'No question available';

  @override
  String get eoQuestion => 'Question';

  @override
  String get eoHint => 'Hint';

  @override
  String get eoClickHint => 'Click for a hint';

  @override
  String get eoAnswerHint => 'Answer clue';

  @override
  String get eoClickAnswerHint => 'Click for an answer clue';

  @override
  String get eoTimer => 'Timer';

  @override
  String get eoTotal => 'Total';

  @override
  String get eoSpeech => 'Speech';

  @override
  String get eoHesitation => 'Hesitation';

  @override
  String get eoStart => 'Start';

  @override
  String get eoStop => 'Stop';

  @override
  String get eoReset => 'Reset';

  @override
  String get eoModeFree => 'Free mode';

  @override
  String get eoModeFreeDescription =>
      'Move forward whenever you want, without help.';

  @override
  String get eoModeEasy => 'Easy';

  @override
  String get eoModeEasyDescription =>
      'Answer, self-evaluate, and view an answer clue.';

  @override
  String get eoModeHard => 'Difficult';

  @override
  String get eoModeHardDescription =>
      'Timer, hesitation tracking, and self-evaluation.';

  @override
  String eoLevelChip(Object level) {
    return 'Level $level';
  }

  @override
  String get eoSelfEvaluation => 'Self-evaluation';

  @override
  String get eoExcellent => 'Excellent';

  @override
  String get eoGood => 'Good';

  @override
  String get eoAverage => 'Average';

  @override
  String get eoDifficult => 'Difficult';

  @override
  String get eoNextQuestion => 'Next question';

  @override
  String get numDateTitle => 'Numbers & Dates';

  @override
  String get numDateNumbersTab => 'Numbers';

  @override
  String get numDateDatesTab => 'Dates';

  @override
  String get numDateTimeTab => 'Time';

  @override
  String get numDatePreviewNumberTitle => 'Choose a preview number';

  @override
  String get numDatePreviewNumberSubtitle =>
      'This value is only used for quick conversion.';

  @override
  String get numDatePreviewNumberLabel => 'Preview number';

  @override
  String get numDatePositiveInteger => 'Enter a positive integer to start.';

  @override
  String get numDateTraining => 'Practice';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Choose another number to practice writing it in Italian words.';

  @override
  String get numDateTrainingNumberLabel => 'Practice number';

  @override
  String get numDateAnswerInWords => 'Your answer in words';

  @override
  String get numDateCheck => 'Check';

  @override
  String get numDateClear => 'Clear';

  @override
  String get numDatePreviewDateTitle => 'Choose a preview date';

  @override
  String get numDatePreviewDateSubtitle =>
      'This date is only used as a quick reference.';

  @override
  String get numDateToday => 'Today';

  @override
  String get numDateTrainingDateSubtitle =>
      'Choose another date to practice writing it in Italian words.';

  @override
  String numDateExpectedDay(String day) {
    return 'Expected day: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Choose a preview time';

  @override
  String get numDatePreviewTimeSubtitle =>
      'This time is only used as a quick reading.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Choose another time to practice, especially quarter hours.';

  @override
  String get numDateDefinedTime => 'Defined time:';

  @override
  String get answerCorrect => 'Correct answer.';

  @override
  String get answerIncorrect => 'Incorrect answer.';

  @override
  String answerYourAnswer(String answer) {
    return 'Your answer: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Correct answer: $answer';
  }

  @override
  String get conjugationTitle => 'Conjugation';

  @override
  String get conjugationRegular => 'Regular';

  @override
  String get conjugationSemiRegular => 'Semi-regular';

  @override
  String get conjugationIrregular => 'Irregular';

  @override
  String get conjugationPronominal => 'Pronominal';

  @override
  String conjugationGroup(Object group) {
    return 'Group $group';
  }

  @override
  String conjugationAuxiliary(Object auxiliary) {
    return 'Auxiliary $auxiliary';
  }

  @override
  String get conjugationShowAnswers => 'Show';

  @override
  String get conjugationHideAnswers => 'Hide';

  @override
  String get conjugationNonPronominal => 'Non-pronominal';

  @override
  String get conjugationDetailsVisibility => 'Show verb characteristics';

  @override
  String get conjugationClearFilters => 'Clear all filters';

  @override
  String get conjugationChooseVerb => 'Choose a verb';

  @override
  String get conjugationRandomVerb => 'Random verb';

  @override
  String get conjugationHideBaseVerb => 'Hide base verb';

  @override
  String get conjugationChooseMood => 'Choose a mood';

  @override
  String get conjugationChooseTense => 'Choose a tense';

  @override
  String conjugationVerb(String verb) {
    return 'Verb: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Translation: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Mood: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Tense: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Loading error: $error';
  }

  @override
  String get profileLanguage => 'Interface language';

  @override
  String get profileUserName => 'User name';

  @override
  String get profileAbout => 'About the app';

  @override
  String get profileAboutDescription => 'Parlami helps you learn Italian.';

  @override
  String get profileTheme => 'Theme';

  @override
  String get profileThemeDescription => 'Switch between light and dark mode';

  @override
  String get themeSystem => 'System theme';

  @override
  String get themeLight => 'Light theme';

  @override
  String get themeDark => 'Dark theme';

  @override
  String get vocabTitle => 'Vocabulary';

  @override
  String get vocabReview => 'Review';

  @override
  String get vocabCatalog => 'Catalog';

  @override
  String get vocabAdd => 'Add';

  @override
  String get vocabImport => 'Import words';

  @override
  String get vocabExport => 'Export my words';

  @override
  String get vocabResetCatalog => 'Reset original catalog';

  @override
  String get vocabSelect => 'Select';

  @override
  String get vocabSave => 'Save word';

  @override
  String get vocabChooseCategories => 'Choose word categories';

  @override
  String get vocabPasteJson => 'Paste a JSON list of words. Accepted format:';

  @override
  String get vocabCancel => 'Cancel';

  @override
  String vocabImportError(String error) {
    return 'Import failed: $error';
  }

  @override
  String get vocabResetQuestion => 'Reset original words?';

  @override
  String get vocabResetDescription =>
      'This resets imported words and reapplies the original catalog. User-added words are kept.';

  @override
  String get vocabDeleteQuestion => 'Delete this word?';

  @override
  String vocabDeleteDescription(String word) {
    return 'Delete \"$word\" from the catalog?';
  }

  @override
  String get vocabDelete => 'Delete';

  @override
  String get vocabNoCategory => 'No category selected';

  @override
  String get vocabLoading => 'Loading vocabulary...';

  @override
  String get vocabFields => 'Lexical fields';

  @override
  String get vocabNoMatch => 'No word matches the current filters.';

  @override
  String get vocabNoTrainingMatch => 'No word matches the training filters.';

  @override
  String get vocabTrainingWord => 'Training word';

  @override
  String vocabScore(String score) {
    return 'Score $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Base language: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Answer hidden.';

  @override
  String get vocabKnown => 'Known';

  @override
  String get vocabUnknown => 'Not known';

  @override
  String get vocabNextWord => 'Next word';

  @override
  String vocabCategories(String categories) {
    return 'Categories: $categories';
  }

  @override
  String get vocabPreparing => 'Preparing training words...';

  @override
  String get vocabPriority => 'Prioritize words not yet mastered';

  @override
  String get vocabPriorityDescription => 'Disable to shuffle randomly.';

  @override
  String vocabSelectedCount(String count) {
    return 'Words selected: $count';
  }

  @override
  String get vocabClearAll => 'Clear all';

  @override
  String get vocabConfirm => 'Confirm';

  @override
  String get conjugationCheck => 'Check';

  @override
  String get conjugationNextVerb => 'Next verb';

  @override
  String get eeNextSentence => 'Next sentence';

  @override
  String get eeNoSentence => 'No sentence available';

  @override
  String ceLevel(String level) {
    return 'Level: $level';
  }

  @override
  String get sampleItems => 'Sample items';

  @override
  String get sampleItemDetails => 'Item details';

  @override
  String get sampleMoreInformation => 'More information here';

  @override
  String sampleItem(String id) {
    return 'Sample item $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Culture';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Speed';

  @override
  String get conjugationAnswerLabel => 'Your answer';

  @override
  String get vocabWords => 'Words';

  @override
  String get vocabAverageMastery => 'Average mastery';

  @override
  String get vocabMode => 'Mode';

  @override
  String get vocabMastery => 'Mastery';

  @override
  String get vocabRandom => 'Random';

  @override
  String get vocabSearchWord => 'Search for a word';

  @override
  String get vocabBaseLanguageDisplay => 'Display base language';

  @override
  String get vocabDifficulty => 'Difficulty';

  @override
  String get vocabPartOfSpeech => 'Part of speech';

  @override
  String get vocabChooseFilterCategories => 'Choose filter categories';

  @override
  String get vocabSearchTrainingWord => 'Search for a word';

  @override
  String get vocabTrainingBaseLanguage => 'Training base language';

  @override
  String get vocabFilters => 'Filters';

  @override
  String get vocabChooseTrainingCategories => 'Choose training categories';

  @override
  String get vocabItalianWord => 'Italian word';

  @override
  String get vocabFrenchTranslation => 'French translation';

  @override
  String get vocabOptionalArticle => 'Optional article (il, la, l\', etc.)';

  @override
  String get vocabCategoriesTitle => 'Categories';

  @override
  String get vocabSearchCategory => 'Search for a category';

  @override
  String vocabAddCategory(String category) {
    return 'Add \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'Delete from catalog';

  @override
  String get vocabHideAnswer => 'Hide answer';

  @override
  String get vocabShowAnswer => 'Show answer';

  @override
  String get vocabStatusSaved => 'Word saved and available in filters.';

  @override
  String vocabStatusImport(String count) {
    return 'Import complete: $count word(s) added.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Export complete: $location';
  }

  @override
  String get vocabStatusNoExport => 'No user words to export.';

  @override
  String get vocabStatusReset => 'Original catalog reset.';

  @override
  String get vocabStatusDeleted => 'Word removed from catalog.';

  @override
  String get vocabStatusKnown => 'Well noted.';

  @override
  String get vocabStatusReview => 'Review soon.';

  @override
  String get vocabItalian => 'Italian';

  @override
  String get vocabFrench => 'French';

  @override
  String get vocabSourceOriginal => 'Original';

  @override
  String get vocabSourceUser => 'User';

  @override
  String get vocabNoun => 'Noun';

  @override
  String get vocabVerb => 'Verb';

  @override
  String get vocabAdjective => 'Adjective';

  @override
  String get vocabAdverb => 'Adverb';

  @override
  String get vocabPronoun => 'Pronoun';

  @override
  String get vocabDeterminer => 'Determiner';

  @override
  String get vocabPreposition => 'Preposition';

  @override
  String get vocabConjunction => 'Conjunction';

  @override
  String get vocabInterjection => 'Interjection';

  @override
  String get vocabExpression => 'Expression';

  @override
  String get vocabOther => 'Other';

  @override
  String get profileDonate => 'Make a donation';

  @override
  String get profileDonateDescription => 'Thank you for your support';

  @override
  String get profilePrivacy => 'Privacy policy';

  @override
  String get profilePrivacyDescription => 'Open the privacy policy';

  @override
  String get unavailable => 'Feature not available yet.';
}
