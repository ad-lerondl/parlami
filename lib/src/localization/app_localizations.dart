import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('ja'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('tr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Parlami'**
  String get appTitle;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navTrain.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navTrain;

  /// No description provided for @navEvaluate.
  ///
  /// In en, this message translates to:
  /// **'Test yourself'**
  String get navEvaluate;

  /// No description provided for @navResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get navResults;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @learnConjugation.
  ///
  /// In en, this message translates to:
  /// **'Conjugation'**
  String get learnConjugation;

  /// No description provided for @learnConjugationDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice conjugating verbs'**
  String get learnConjugationDescription;

  /// No description provided for @learnVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get learnVocabulary;

  /// No description provided for @learnVocabularyDescription.
  ///
  /// In en, this message translates to:
  /// **'By topic and level'**
  String get learnVocabularyDescription;

  /// No description provided for @learnNumbersDates.
  ///
  /// In en, this message translates to:
  /// **'Numbers & Dates'**
  String get learnNumbersDates;

  /// No description provided for @learnNumbersDatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Write numbers and dates'**
  String get learnNumbersDatesDescription;

  /// No description provided for @learnGrammar.
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get learnGrammar;

  /// No description provided for @learnGrammarDescription.
  ///
  /// In en, this message translates to:
  /// **'Course notes'**
  String get learnGrammarDescription;

  /// No description provided for @learnSpelling.
  ///
  /// In en, this message translates to:
  /// **'Spelling'**
  String get learnSpelling;

  /// No description provided for @learnSpellingDescription.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get learnSpellingDescription;

  /// No description provided for @trainOralExpression.
  ///
  /// In en, this message translates to:
  /// **'EO - Oral expression'**
  String get trainOralExpression;

  /// No description provided for @trainOralExpressionDescription.
  ///
  /// In en, this message translates to:
  /// **'Answer aloud'**
  String get trainOralExpressionDescription;

  /// No description provided for @trainOralComprehension.
  ///
  /// In en, this message translates to:
  /// **'CO - Oral comprehension'**
  String get trainOralComprehension;

  /// No description provided for @trainOralComprehensionDescription.
  ///
  /// In en, this message translates to:
  /// **'Listen to radio stations'**
  String get trainOralComprehensionDescription;

  /// No description provided for @trainWrittenComprehension.
  ///
  /// In en, this message translates to:
  /// **'CE - Written comprehension'**
  String get trainWrittenComprehension;

  /// No description provided for @trainWrittenComprehensionDescription.
  ///
  /// In en, this message translates to:
  /// **'Read Italian news'**
  String get trainWrittenComprehensionDescription;

  /// No description provided for @trainWrittenExpression.
  ///
  /// In en, this message translates to:
  /// **'EE - Written expression'**
  String get trainWrittenExpression;

  /// No description provided for @trainWrittenExpressionDescription.
  ///
  /// In en, this message translates to:
  /// **'Translate sentences'**
  String get trainWrittenExpressionDescription;

  /// No description provided for @evaluateTitle.
  ///
  /// In en, this message translates to:
  /// **'Test yourself - Real-life situations'**
  String get evaluateTitle;

  /// No description provided for @evaluateIntro.
  ///
  /// In en, this message translates to:
  /// **'Combine several skills at the same time to simulate real-life situations.'**
  String get evaluateIntro;

  /// No description provided for @evaluateProgression.
  ///
  /// In en, this message translates to:
  /// **'Learn builds the foundations. Practice targets specific skills. Test yourself measures your overall mastery.'**
  String get evaluateProgression;

  /// No description provided for @scenarioDailyConversation.
  ///
  /// In en, this message translates to:
  /// **'Everyday conversation'**
  String get scenarioDailyConversation;

  /// No description provided for @scenarioArticleSummary.
  ///
  /// In en, this message translates to:
  /// **'Article summary'**
  String get scenarioArticleSummary;

  /// No description provided for @scenarioMatchDebrief.
  ///
  /// In en, this message translates to:
  /// **'Match debrief'**
  String get scenarioMatchDebrief;

  /// No description provided for @scenarioQuickDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Quick discussion'**
  String get scenarioQuickDiscussion;

  /// No description provided for @scenarioDailyConversationDetails.
  ///
  /// In en, this message translates to:
  /// **'Listen, understand, then answer naturally.'**
  String get scenarioDailyConversationDetails;

  /// No description provided for @scenarioArticleSummaryDetails.
  ///
  /// In en, this message translates to:
  /// **'Read a text, then produce a clear, structured summary.'**
  String get scenarioArticleSummaryDetails;

  /// No description provided for @scenarioMatchDebriefDetails.
  ///
  /// In en, this message translates to:
  /// **'Talk about a match using vocabulary and cultural references.'**
  String get scenarioMatchDebriefDetails;

  /// No description provided for @scenarioQuickDiscussionDetails.
  ///
  /// In en, this message translates to:
  /// **'React quickly in a dynamic exchange with time constraints.'**
  String get scenarioQuickDiscussionDetails;

  /// No description provided for @resultsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Performance charts coming soon'**
  String get resultsComingSoon;

  /// No description provided for @grammarTitle.
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get grammarTitle;

  /// No description provided for @grammarComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Grammar notes - content coming soon.\n\nAdd notes to this module as pages or rendered Markdown.'**
  String get grammarComingSoon;

  /// No description provided for @spellingTitle.
  ///
  /// In en, this message translates to:
  /// **'Spelling'**
  String get spellingTitle;

  /// No description provided for @spellingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Spelling module - coming soon.'**
  String get spellingComingSoon;

  /// No description provided for @ceTitle.
  ///
  /// In en, this message translates to:
  /// **'CE - Written comprehension'**
  String get ceTitle;

  /// No description provided for @ceIntro.
  ///
  /// In en, this message translates to:
  /// **'Read Italian articles to improve your written comprehension'**
  String get ceIntro;

  /// No description provided for @ceAdviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Advice'**
  String get ceAdviceTitle;

  /// No description provided for @ceAdvice.
  ///
  /// In en, this message translates to:
  /// **'Start with short articles. Read first for the general meaning, then read again for details.'**
  String get ceAdvice;

  /// No description provided for @ceOpenSource.
  ///
  /// In en, this message translates to:
  /// **'Open source website'**
  String get ceOpenSource;

  /// No description provided for @eeTitle.
  ///
  /// In en, this message translates to:
  /// **'EE - Written expression'**
  String get eeTitle;

  /// No description provided for @eePrompt.
  ///
  /// In en, this message translates to:
  /// **'Translate the following sentence into Italian'**
  String get eePrompt;

  /// No description provided for @eeTranslationLabel.
  ///
  /// In en, this message translates to:
  /// **'Your translation into Italian'**
  String get eeTranslationLabel;

  /// No description provided for @eeTranslationHint.
  ///
  /// In en, this message translates to:
  /// **'Write your translation here...'**
  String get eeTranslationHint;

  /// No description provided for @eeCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get eeCheck;

  /// No description provided for @eeCorrection.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get eeCorrection;

  /// No description provided for @eeYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get eeYourAnswer;

  /// No description provided for @coTitle.
  ///
  /// In en, this message translates to:
  /// **'CO - Oral comprehension'**
  String get coTitle;

  /// No description provided for @coIntro.
  ///
  /// In en, this message translates to:
  /// **'Listen to Italian radio stations to improve your oral comprehension'**
  String get coIntro;

  /// No description provided for @coLive.
  ///
  /// In en, this message translates to:
  /// **'Live:'**
  String get coLive;

  /// No description provided for @coStopped.
  ///
  /// In en, this message translates to:
  /// **'{station} stopped'**
  String coStopped(Object station);

  /// No description provided for @coConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {station}...'**
  String coConnecting(Object station);

  /// No description provided for @coPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get coPlay;

  /// No description provided for @coStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get coStop;

  /// No description provided for @eoTitle.
  ///
  /// In en, this message translates to:
  /// **'EO - Oral expression'**
  String get eoTitle;

  /// No description provided for @eoChooseLevel.
  ///
  /// In en, this message translates to:
  /// **'Choose the level'**
  String get eoChooseLevel;

  /// No description provided for @eoLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String eoLevel(String level);

  /// No description provided for @eoNoQuestion.
  ///
  /// In en, this message translates to:
  /// **'No question available'**
  String get eoNoQuestion;

  /// No description provided for @eoQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get eoQuestion;

  /// No description provided for @eoHint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get eoHint;

  /// No description provided for @eoClickHint.
  ///
  /// In en, this message translates to:
  /// **'Click for a hint'**
  String get eoClickHint;

  /// No description provided for @eoAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Answer clue'**
  String get eoAnswerHint;

  /// No description provided for @eoClickAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Click for an answer clue'**
  String get eoClickAnswerHint;

  /// No description provided for @eoTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get eoTimer;

  /// No description provided for @eoTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get eoTotal;

  /// No description provided for @eoSpeech.
  ///
  /// In en, this message translates to:
  /// **'Speech'**
  String get eoSpeech;

  /// No description provided for @eoHesitation.
  ///
  /// In en, this message translates to:
  /// **'Hesitation'**
  String get eoHesitation;

  /// No description provided for @eoStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get eoStart;

  /// No description provided for @eoStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get eoStop;

  /// No description provided for @eoReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get eoReset;

  /// No description provided for @eoModeFree.
  ///
  /// In en, this message translates to:
  /// **'Free mode'**
  String get eoModeFree;

  /// No description provided for @eoModeFreeDescription.
  ///
  /// In en, this message translates to:
  /// **'Move forward whenever you want, without help.'**
  String get eoModeFreeDescription;

  /// No description provided for @eoModeEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get eoModeEasy;

  /// No description provided for @eoModeEasyDescription.
  ///
  /// In en, this message translates to:
  /// **'Answer, self-evaluate, and view an answer clue.'**
  String get eoModeEasyDescription;

  /// No description provided for @eoModeHard.
  ///
  /// In en, this message translates to:
  /// **'Difficult'**
  String get eoModeHard;

  /// No description provided for @eoModeHardDescription.
  ///
  /// In en, this message translates to:
  /// **'Timer, hesitation tracking, and self-evaluation.'**
  String get eoModeHardDescription;

  /// No description provided for @eoLevelChip.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String eoLevelChip(Object level);

  /// No description provided for @eoSelfEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Self-evaluation'**
  String get eoSelfEvaluation;

  /// No description provided for @eoExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get eoExcellent;

  /// No description provided for @eoGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get eoGood;

  /// No description provided for @eoAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get eoAverage;

  /// No description provided for @eoDifficult.
  ///
  /// In en, this message translates to:
  /// **'Difficult'**
  String get eoDifficult;

  /// No description provided for @eoNextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get eoNextQuestion;

  /// No description provided for @numDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Numbers & Dates'**
  String get numDateTitle;

  /// No description provided for @numDateNumbersTab.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numDateNumbersTab;

  /// No description provided for @numDateDatesTab.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get numDateDatesTab;

  /// No description provided for @numDateTimeTab.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get numDateTimeTab;

  /// No description provided for @numDatePreviewNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a preview number'**
  String get numDatePreviewNumberTitle;

  /// No description provided for @numDatePreviewNumberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This value is only used for quick conversion.'**
  String get numDatePreviewNumberSubtitle;

  /// No description provided for @numDatePreviewNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview number'**
  String get numDatePreviewNumberLabel;

  /// No description provided for @numDatePositiveInteger.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive integer to start.'**
  String get numDatePositiveInteger;

  /// No description provided for @numDateTraining.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get numDateTraining;

  /// No description provided for @numDateTrainingNumberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose another number to practice writing it in Italian words.'**
  String get numDateTrainingNumberSubtitle;

  /// No description provided for @numDateTrainingNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Practice number'**
  String get numDateTrainingNumberLabel;

  /// No description provided for @numDateAnswerInWords.
  ///
  /// In en, this message translates to:
  /// **'Your answer in words'**
  String get numDateAnswerInWords;

  /// No description provided for @numDateCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get numDateCheck;

  /// No description provided for @numDateClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get numDateClear;

  /// No description provided for @numDatePreviewDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a preview date'**
  String get numDatePreviewDateTitle;

  /// No description provided for @numDatePreviewDateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This date is only used as a quick reference.'**
  String get numDatePreviewDateSubtitle;

  /// No description provided for @numDateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get numDateToday;

  /// No description provided for @numDateTrainingDateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose another date to practice writing it in Italian words.'**
  String get numDateTrainingDateSubtitle;

  /// No description provided for @numDateExpectedDay.
  ///
  /// In en, this message translates to:
  /// **'Expected day: {day}'**
  String numDateExpectedDay(String day);

  /// No description provided for @numDatePreviewTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a preview time'**
  String get numDatePreviewTimeTitle;

  /// No description provided for @numDatePreviewTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This time is only used as a quick reading.'**
  String get numDatePreviewTimeSubtitle;

  /// No description provided for @numDateTrainingTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose another time to practice, especially quarter hours.'**
  String get numDateTrainingTimeSubtitle;

  /// No description provided for @numDateDefinedTime.
  ///
  /// In en, this message translates to:
  /// **'Defined time:'**
  String get numDateDefinedTime;

  /// No description provided for @answerCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct answer.'**
  String get answerCorrect;

  /// No description provided for @answerIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer.'**
  String get answerIncorrect;

  /// No description provided for @answerYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer: {answer}'**
  String answerYourAnswer(String answer);

  /// No description provided for @answerExpected.
  ///
  /// In en, this message translates to:
  /// **'Correct answer: {answer}'**
  String answerExpected(String answer);

  /// No description provided for @conjugationTitle.
  ///
  /// In en, this message translates to:
  /// **'Conjugation'**
  String get conjugationTitle;

  /// No description provided for @conjugationRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get conjugationRegular;

  /// No description provided for @conjugationSemiRegular.
  ///
  /// In en, this message translates to:
  /// **'Semi-regular'**
  String get conjugationSemiRegular;

  /// No description provided for @conjugationIrregular.
  ///
  /// In en, this message translates to:
  /// **'Irregular'**
  String get conjugationIrregular;

  /// No description provided for @conjugationClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear all filters'**
  String get conjugationClearFilters;

  /// No description provided for @conjugationChooseVerb.
  ///
  /// In en, this message translates to:
  /// **'Choose a verb'**
  String get conjugationChooseVerb;

  /// No description provided for @conjugationRandomVerb.
  ///
  /// In en, this message translates to:
  /// **'Random verb'**
  String get conjugationRandomVerb;

  /// No description provided for @conjugationHideBaseVerb.
  ///
  /// In en, this message translates to:
  /// **'Hide base verb'**
  String get conjugationHideBaseVerb;

  /// No description provided for @conjugationChooseMood.
  ///
  /// In en, this message translates to:
  /// **'Choose a mood'**
  String get conjugationChooseMood;

  /// No description provided for @conjugationChooseTense.
  ///
  /// In en, this message translates to:
  /// **'Choose a tense'**
  String get conjugationChooseTense;

  /// No description provided for @conjugationVerb.
  ///
  /// In en, this message translates to:
  /// **'Verb: {verb}'**
  String conjugationVerb(String verb);

  /// No description provided for @conjugationTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation: {translation}'**
  String conjugationTranslation(String translation);

  /// No description provided for @conjugationMood.
  ///
  /// In en, this message translates to:
  /// **'Mood: {mood}'**
  String conjugationMood(String mood);

  /// No description provided for @conjugationTense.
  ///
  /// In en, this message translates to:
  /// **'Tense: {tense}'**
  String conjugationTense(String tense);

  /// No description provided for @conjugationLoadingError.
  ///
  /// In en, this message translates to:
  /// **'Loading error: {error}'**
  String conjugationLoadingError(String error);

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get profileLanguage;

  /// No description provided for @profileUserName.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get profileUserName;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get profileAbout;

  /// No description provided for @profileAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Parlami helps you learn Italian.'**
  String get profileAboutDescription;

  /// No description provided for @profileTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileTheme;

  /// No description provided for @profileThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark mode'**
  String get profileThemeDescription;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System theme'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get themeDark;

  /// No description provided for @vocabTitle.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get vocabTitle;

  /// No description provided for @vocabReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get vocabReview;

  /// No description provided for @vocabCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get vocabCatalog;

  /// No description provided for @vocabAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get vocabAdd;

  /// No description provided for @vocabImport.
  ///
  /// In en, this message translates to:
  /// **'Import words'**
  String get vocabImport;

  /// No description provided for @vocabExport.
  ///
  /// In en, this message translates to:
  /// **'Export my words'**
  String get vocabExport;

  /// No description provided for @vocabResetCatalog.
  ///
  /// In en, this message translates to:
  /// **'Reset original catalog'**
  String get vocabResetCatalog;

  /// No description provided for @vocabSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get vocabSelect;

  /// No description provided for @vocabSave.
  ///
  /// In en, this message translates to:
  /// **'Save word'**
  String get vocabSave;

  /// No description provided for @vocabChooseCategories.
  ///
  /// In en, this message translates to:
  /// **'Choose word categories'**
  String get vocabChooseCategories;

  /// No description provided for @vocabPasteJson.
  ///
  /// In en, this message translates to:
  /// **'Paste a JSON list of words. Accepted format:'**
  String get vocabPasteJson;

  /// No description provided for @vocabCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get vocabCancel;

  /// No description provided for @vocabImportError.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String vocabImportError(String error);

  /// No description provided for @vocabResetQuestion.
  ///
  /// In en, this message translates to:
  /// **'Reset original words?'**
  String get vocabResetQuestion;

  /// No description provided for @vocabResetDescription.
  ///
  /// In en, this message translates to:
  /// **'This resets imported words and reapplies the original catalog. User-added words are kept.'**
  String get vocabResetDescription;

  /// No description provided for @vocabDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this word?'**
  String get vocabDeleteQuestion;

  /// No description provided for @vocabDeleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{word}\" from the catalog?'**
  String vocabDeleteDescription(String word);

  /// No description provided for @vocabDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get vocabDelete;

  /// No description provided for @vocabNoCategory.
  ///
  /// In en, this message translates to:
  /// **'No category selected'**
  String get vocabNoCategory;

  /// No description provided for @vocabLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading vocabulary...'**
  String get vocabLoading;

  /// No description provided for @vocabFields.
  ///
  /// In en, this message translates to:
  /// **'Lexical fields'**
  String get vocabFields;

  /// No description provided for @vocabNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No word matches the current filters.'**
  String get vocabNoMatch;

  /// No description provided for @vocabNoTrainingMatch.
  ///
  /// In en, this message translates to:
  /// **'No word matches the training filters.'**
  String get vocabNoTrainingMatch;

  /// No description provided for @vocabTrainingWord.
  ///
  /// In en, this message translates to:
  /// **'Training word'**
  String get vocabTrainingWord;

  /// No description provided for @vocabScore.
  ///
  /// In en, this message translates to:
  /// **'Score {score}%'**
  String vocabScore(String score);

  /// No description provided for @vocabBaseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Base language: {language}'**
  String vocabBaseLanguage(String language);

  /// No description provided for @vocabHiddenAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer hidden.'**
  String get vocabHiddenAnswer;

  /// No description provided for @vocabKnown.
  ///
  /// In en, this message translates to:
  /// **'Known'**
  String get vocabKnown;

  /// No description provided for @vocabUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not known'**
  String get vocabUnknown;

  /// No description provided for @vocabNextWord.
  ///
  /// In en, this message translates to:
  /// **'Next word'**
  String get vocabNextWord;

  /// No description provided for @vocabCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories: {categories}'**
  String vocabCategories(String categories);

  /// No description provided for @vocabPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing training words...'**
  String get vocabPreparing;

  /// No description provided for @vocabPriority.
  ///
  /// In en, this message translates to:
  /// **'Prioritize words not yet mastered'**
  String get vocabPriority;

  /// No description provided for @vocabPriorityDescription.
  ///
  /// In en, this message translates to:
  /// **'Disable to shuffle randomly.'**
  String get vocabPriorityDescription;

  /// No description provided for @vocabSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'Words selected: {count}'**
  String vocabSelectedCount(String count);

  /// No description provided for @vocabClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get vocabClearAll;

  /// No description provided for @vocabConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get vocabConfirm;

  /// No description provided for @conjugationCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get conjugationCheck;

  /// No description provided for @conjugationNextVerb.
  ///
  /// In en, this message translates to:
  /// **'Next verb'**
  String get conjugationNextVerb;

  /// No description provided for @eeNextSentence.
  ///
  /// In en, this message translates to:
  /// **'Next sentence'**
  String get eeNextSentence;

  /// No description provided for @eeNoSentence.
  ///
  /// In en, this message translates to:
  /// **'No sentence available'**
  String get eeNoSentence;

  /// No description provided for @ceLevel.
  ///
  /// In en, this message translates to:
  /// **'Level: {level}'**
  String ceLevel(String level);

  /// No description provided for @sampleItems.
  ///
  /// In en, this message translates to:
  /// **'Sample items'**
  String get sampleItems;

  /// No description provided for @sampleItemDetails.
  ///
  /// In en, this message translates to:
  /// **'Item details'**
  String get sampleItemDetails;

  /// No description provided for @sampleMoreInformation.
  ///
  /// In en, this message translates to:
  /// **'More information here'**
  String get sampleMoreInformation;

  /// No description provided for @sampleItem.
  ///
  /// In en, this message translates to:
  /// **'Sample item {id}'**
  String sampleItem(String id);

  /// No description provided for @evaluateScenarioOral.
  ///
  /// In en, this message translates to:
  /// **'CO + EO'**
  String get evaluateScenarioOral;

  /// No description provided for @evaluateScenarioWritten.
  ///
  /// In en, this message translates to:
  /// **'CE + EE'**
  String get evaluateScenarioWritten;

  /// No description provided for @evaluateScenarioCulture.
  ///
  /// In en, this message translates to:
  /// **'EO + Culture'**
  String get evaluateScenarioCulture;

  /// No description provided for @evaluateScenarioSpeed.
  ///
  /// In en, this message translates to:
  /// **'CO + EO + Speed'**
  String get evaluateScenarioSpeed;

  /// No description provided for @conjugationAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get conjugationAnswerLabel;

  /// No description provided for @vocabWords.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get vocabWords;

  /// No description provided for @vocabAverageMastery.
  ///
  /// In en, this message translates to:
  /// **'Average mastery'**
  String get vocabAverageMastery;

  /// No description provided for @vocabMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get vocabMode;

  /// No description provided for @vocabMastery.
  ///
  /// In en, this message translates to:
  /// **'Mastery'**
  String get vocabMastery;

  /// No description provided for @vocabRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get vocabRandom;

  /// No description provided for @vocabSearchWord.
  ///
  /// In en, this message translates to:
  /// **'Search for a word'**
  String get vocabSearchWord;

  /// No description provided for @vocabBaseLanguageDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display base language'**
  String get vocabBaseLanguageDisplay;

  /// No description provided for @vocabDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get vocabDifficulty;

  /// No description provided for @vocabPartOfSpeech.
  ///
  /// In en, this message translates to:
  /// **'Part of speech'**
  String get vocabPartOfSpeech;

  /// No description provided for @vocabChooseFilterCategories.
  ///
  /// In en, this message translates to:
  /// **'Choose filter categories'**
  String get vocabChooseFilterCategories;

  /// No description provided for @vocabSearchTrainingWord.
  ///
  /// In en, this message translates to:
  /// **'Search for a word'**
  String get vocabSearchTrainingWord;

  /// No description provided for @vocabTrainingBaseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Training base language'**
  String get vocabTrainingBaseLanguage;

  /// No description provided for @vocabFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get vocabFilters;

  /// No description provided for @vocabChooseTrainingCategories.
  ///
  /// In en, this message translates to:
  /// **'Choose training categories'**
  String get vocabChooseTrainingCategories;

  /// No description provided for @vocabItalianWord.
  ///
  /// In en, this message translates to:
  /// **'Italian word'**
  String get vocabItalianWord;

  /// No description provided for @vocabFrenchTranslation.
  ///
  /// In en, this message translates to:
  /// **'French translation'**
  String get vocabFrenchTranslation;

  /// No description provided for @vocabOptionalArticle.
  ///
  /// In en, this message translates to:
  /// **'Optional article (il, la, l\', etc.)'**
  String get vocabOptionalArticle;

  /// No description provided for @vocabCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get vocabCategoriesTitle;

  /// No description provided for @vocabSearchCategory.
  ///
  /// In en, this message translates to:
  /// **'Search for a category'**
  String get vocabSearchCategory;

  /// No description provided for @vocabAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Add \"{category}\"'**
  String vocabAddCategory(String category);

  /// No description provided for @vocabDeleteFromCatalog.
  ///
  /// In en, this message translates to:
  /// **'Delete from catalog'**
  String get vocabDeleteFromCatalog;

  /// No description provided for @vocabHideAnswer.
  ///
  /// In en, this message translates to:
  /// **'Hide answer'**
  String get vocabHideAnswer;

  /// No description provided for @vocabShowAnswer.
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get vocabShowAnswer;

  /// No description provided for @vocabStatusSaved.
  ///
  /// In en, this message translates to:
  /// **'Word saved and available in filters.'**
  String get vocabStatusSaved;

  /// No description provided for @vocabStatusImport.
  ///
  /// In en, this message translates to:
  /// **'Import complete: {count} word(s) added.'**
  String vocabStatusImport(String count);

  /// No description provided for @vocabStatusExport.
  ///
  /// In en, this message translates to:
  /// **'Export complete: {location}'**
  String vocabStatusExport(String location);

  /// No description provided for @vocabStatusNoExport.
  ///
  /// In en, this message translates to:
  /// **'No user words to export.'**
  String get vocabStatusNoExport;

  /// No description provided for @vocabStatusReset.
  ///
  /// In en, this message translates to:
  /// **'Original catalog reset.'**
  String get vocabStatusReset;

  /// No description provided for @vocabStatusDeleted.
  ///
  /// In en, this message translates to:
  /// **'Word removed from catalog.'**
  String get vocabStatusDeleted;

  /// No description provided for @vocabStatusKnown.
  ///
  /// In en, this message translates to:
  /// **'Well noted.'**
  String get vocabStatusKnown;

  /// No description provided for @vocabStatusReview.
  ///
  /// In en, this message translates to:
  /// **'Review soon.'**
  String get vocabStatusReview;

  /// No description provided for @vocabItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get vocabItalian;

  /// No description provided for @vocabFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get vocabFrench;

  /// No description provided for @vocabSourceOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get vocabSourceOriginal;

  /// No description provided for @vocabSourceUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get vocabSourceUser;

  /// No description provided for @vocabNoun.
  ///
  /// In en, this message translates to:
  /// **'Noun'**
  String get vocabNoun;

  /// No description provided for @vocabVerb.
  ///
  /// In en, this message translates to:
  /// **'Verb'**
  String get vocabVerb;

  /// No description provided for @vocabAdjective.
  ///
  /// In en, this message translates to:
  /// **'Adjective'**
  String get vocabAdjective;

  /// No description provided for @vocabAdverb.
  ///
  /// In en, this message translates to:
  /// **'Adverb'**
  String get vocabAdverb;

  /// No description provided for @vocabPronoun.
  ///
  /// In en, this message translates to:
  /// **'Pronoun'**
  String get vocabPronoun;

  /// No description provided for @vocabDeterminer.
  ///
  /// In en, this message translates to:
  /// **'Determiner'**
  String get vocabDeterminer;

  /// No description provided for @vocabPreposition.
  ///
  /// In en, this message translates to:
  /// **'Preposition'**
  String get vocabPreposition;

  /// No description provided for @vocabConjunction.
  ///
  /// In en, this message translates to:
  /// **'Conjunction'**
  String get vocabConjunction;

  /// No description provided for @vocabInterjection.
  ///
  /// In en, this message translates to:
  /// **'Interjection'**
  String get vocabInterjection;

  /// No description provided for @vocabExpression.
  ///
  /// In en, this message translates to:
  /// **'Expression'**
  String get vocabExpression;

  /// No description provided for @vocabOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vocabOther;

  /// No description provided for @profileDonate.
  ///
  /// In en, this message translates to:
  /// **'Make a donation'**
  String get profileDonate;

  /// No description provided for @profileDonateDescription.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support'**
  String get profileDonateDescription;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get profilePrivacy;

  /// No description provided for @profilePrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'Open the privacy policy'**
  String get profilePrivacyDescription;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Feature not available yet.'**
  String get unavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'he',
        'ja',
        'pl',
        'pt',
        'ro',
        'ru',
        'sv',
        'tr'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'ja':
      return AppLocalizationsJa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
