// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'למידה';

  @override
  String get navTrain => 'תרגול';

  @override
  String get navEvaluate => 'בחן את עצמך';

  @override
  String get navResults => 'תוצאות';

  @override
  String get navProfile => 'פרופיל';

  @override
  String get learnConjugation => 'נטיית פעלים';

  @override
  String get learnConjugationDescription => 'תרגול נטיית פעלים';

  @override
  String get learnVocabulary => 'אוצר מילים';

  @override
  String get learnVocabularyDescription => 'לפי נושא ורמה';

  @override
  String get learnNumbersDates => 'מספרים ותאריכים';

  @override
  String get learnNumbersDatesDescription => 'כתיבת מספרים ותאריכים';

  @override
  String get learnGrammar => 'דקדוק';

  @override
  String get learnGrammarDescription => 'הערות קורס';

  @override
  String get learnSpelling => 'איות';

  @override
  String get learnSpellingDescription => 'בקרוב';

  @override
  String get trainOralExpression => 'EO - הבעה בעל פה';

  @override
  String get trainOralExpressionDescription => 'לענות בקול רם';

  @override
  String get trainOralComprehension => 'CO - הבנת הנשמע';

  @override
  String get trainOralComprehensionDescription => 'להאזין לתחנות רדיו';

  @override
  String get trainWrittenComprehension => 'CE - הבנת הנקרא';

  @override
  String get trainWrittenComprehensionDescription => 'לקרוא חדשות באיטלקית';

  @override
  String get trainWrittenExpression => 'EE - הבעה בכתב';

  @override
  String get trainWrittenExpressionDescription => 'לתרגם משפטים';

  @override
  String get evaluateTitle => 'בחן את עצמך - מצבים אמיתיים';

  @override
  String get evaluateIntro =>
      'שלב מספר מיומנויות בו-זמנית כדי לדמות מצבים מהחיים האמיתיים.';

  @override
  String get evaluateProgression =>
      'למידה בונה את היסודות. תרגול מתמקד במיומנויות ספציפיות. מבחן מודד את השליטה הכוללת שלך.';

  @override
  String get scenarioDailyConversation => 'שיחה יומיומית';

  @override
  String get scenarioArticleSummary => 'סיכום מאמר';

  @override
  String get scenarioMatchDebrief => 'ניתוח משחק';

  @override
  String get scenarioQuickDiscussion => 'דיון מהיר';

  @override
  String get scenarioDailyConversationDetails =>
      'להקשיב, להבין ולענות בטבעיות.';

  @override
  String get scenarioArticleSummaryDetails =>
      'לקרוא טקסט ואז ליצור סיכום ברור ומובנה.';

  @override
  String get scenarioMatchDebriefDetails =>
      'לדבר על משחק תוך שימוש באוצר מילים והקשרים תרבותיים.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'להגיב במהירות בשיח דינמי תחת מגבלת זמן.';

  @override
  String get resultsComingSoon => 'תרשימי ביצועים בקרוב';

  @override
  String get grammarTitle => 'דקדוק';

  @override
  String get grammarComingSoon =>
      'הערות דקדוק - התוכן בקרוב.\n\nהוסף הערות למודול זה כדפים או כ-Markdown.';

  @override
  String get spellingTitle => 'איות';

  @override
  String get spellingComingSoon => 'מודול איות - בקרוב.';

  @override
  String get ceTitle => 'CE - הבנת הנקרא';

  @override
  String get ceIntro => 'קרא מאמרים באיטלקית כדי לשפר את הבנת הנקרא שלך';

  @override
  String get ceAdviceTitle => 'עצה';

  @override
  String get ceAdvice =>
      'התחל עם מאמרים קצרים. קרא תחילה להבנת הרעיון הכללי, ואז קרא שוב לפרטים.';

  @override
  String get ceOpenSource => 'פתח את אתר המקור';

  @override
  String get eeTitle => 'EE - הבעה בכתב';

  @override
  String get eePrompt => 'תרגם את המשפט הבא לאיטלקית';

  @override
  String get eeTranslationLabel => 'התרגום שלך לאיטלקית';

  @override
  String get eeTranslationHint => 'כתוב את התרגום שלך כאן...';

  @override
  String get eeCheck => 'בדוק';

  @override
  String get eeCorrection => 'תיקון';

  @override
  String get eeYourAnswer => 'התשובה שלך';

  @override
  String get coTitle => 'CO - הבנת הנשמע';

  @override
  String get coIntro => 'האזן לתחנות רדיו איטלקיות כדי לשפר את הבנת הנשמע שלך';

  @override
  String get coLive => 'בשידור חי:';

  @override
  String coStopped(Object station) {
    return '$station נעצרה';
  }

  @override
  String coConnecting(Object station) {
    return 'מתחבר ל-$station...';
  }

  @override
  String get coPlay => 'נגן';

  @override
  String get coStop => 'עצור';

  @override
  String get coPause => 'השהה';

  @override
  String get coResume => 'המשך';

  @override
  String get coRadioGeneral => 'רדיו איטלקי כללי';

  @override
  String get coMusicEntertainment => 'מוזיקה ובידור';

  @override
  String get coCultureNews => 'תרבות וחדשות';

  @override
  String get coPopNews => 'מוזיקת פופ וחדשות';

  @override
  String get coRadioNewsMusic => 'חדשות ומוזיקה';

  @override
  String get coNational => 'ארצי';

  @override
  String get ceAnsaDescription => 'סוכנות ידיעות איטלקית - מאמרים קצרים';

  @override
  String get ceRepubblicaDescription => 'עיתון יומי איטלקי מרכזי';

  @override
  String get ceCorriereDescription => 'עיתון מוביל ורב-השפעה';

  @override
  String get ceIlPostDescription => 'חדשות וניתוחים';

  @override
  String get ceRaiDescription => 'חדשות RAI';

  @override
  String get ceEasyItalianDescription => 'חדשות באיטלקית קלה';

  @override
  String get eoTitle => 'EO - הבעה בעל פה';

  @override
  String get eoChooseLevel => 'בחר את הרמה';

  @override
  String eoLevel(String level) {
    return 'רמה $level';
  }

  @override
  String get eoNoQuestion => 'אין שאלה זמינה';

  @override
  String get eoQuestion => 'שאלה';

  @override
  String get eoHint => 'רמז';

  @override
  String get eoClickHint => 'לחץ לקבלת רמז';

  @override
  String get eoAnswerHint => 'רמז לתשובה';

  @override
  String get eoClickAnswerHint => 'לחץ לקבלת רמז לתשובה';

  @override
  String get eoTimer => 'טיימר';

  @override
  String get eoTotal => 'סך הכל';

  @override
  String get eoSpeech => 'דיבור';

  @override
  String get eoHesitation => 'היסוס';

  @override
  String get eoStart => 'התחל';

  @override
  String get eoStop => 'עצור';

  @override
  String get eoReset => 'איפוס';

  @override
  String get eoModeFree => 'מצב חופשי';

  @override
  String get eoModeFreeDescription => 'התקדם מתי שתרצה, ללא עזרה.';

  @override
  String get eoModeEasy => 'קל';

  @override
  String get eoModeEasyDescription => 'ענה, הערך את עצמך וצפה ברמז לתשובה.';

  @override
  String get eoModeHard => 'קשה';

  @override
  String get eoModeHardDescription => 'טיימר, מעקב אחר היסוסים והערכה עצמית.';

  @override
  String eoLevelChip(Object level) {
    return 'רמה $level';
  }

  @override
  String get eoSelfEvaluation => 'הערכה עצמית';

  @override
  String get eoExcellent => 'מצוין';

  @override
  String get eoGood => 'טוב';

  @override
  String get eoAverage => 'בינוני';

  @override
  String get eoDifficult => 'קשה';

  @override
  String get eoNextQuestion => 'השאלה הבאה';

  @override
  String get numDateTitle => 'מספרים ותאריכים';

  @override
  String get numDateNumbersTab => 'מספרים';

  @override
  String get numDateDatesTab => 'תאריכים';

  @override
  String get numDateTimeTab => 'שעה';

  @override
  String get numDatePreviewNumberTitle => 'בחר מספר לתצוגה מקדימה';

  @override
  String get numDatePreviewNumberSubtitle => 'ערך זה משמש רק להמרה מהירה.';

  @override
  String get numDatePreviewNumberLabel => 'מספר תצוגה מקדימה';

  @override
  String get numDatePositiveInteger => 'הזן מספר שלם חיובי כדי להתחיל.';

  @override
  String get numDateTraining => 'תרגול';

  @override
  String get numDateTrainingNumberSubtitle =>
      'בחר מספר אחר כדי לתרגל את כתיבתו במילים באיטלקית.';

  @override
  String get numDateTrainingNumberLabel => 'מספר תרגול';

  @override
  String get numDateAnswerInWords => 'התשובה שלך במילים';

  @override
  String get numDateCheck => 'בדוק';

  @override
  String get numDateClear => 'נקה';

  @override
  String get numDatePreviewDateTitle => 'בחר תאריך לתצוגה מקדימה';

  @override
  String get numDatePreviewDateSubtitle => 'תאריך זה משמש רק כהתייחסות מהירה.';

  @override
  String get numDateToday => 'היום';

  @override
  String get numDateTrainingDateSubtitle =>
      'בחר תאריך אחר כדי לתרגל את כתיבתו במילים באיטלקית.';

  @override
  String numDateExpectedDay(String day) {
    return 'יום צפוי: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'בחר שעה לתצוגה מקדימה';

  @override
  String get numDatePreviewTimeSubtitle => 'שעה זו משמשת רק לקריאה מהירה.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'בחר שעה אחרת לתרגול, במיוחד רבעי שעה.';

  @override
  String get numDateDefinedTime => 'שעה מוגדרת:';

  @override
  String get answerCorrect => 'תשובה נכונה.';

  @override
  String get answerIncorrect => 'תשובה לא נכונה.';

  @override
  String answerYourAnswer(String answer) {
    return 'התשובה שלך: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'תשובה נכונה: $answer';
  }

  @override
  String get conjugationTitle => 'נטיית פעלים';

  @override
  String get conjugationRegular => 'רגילים';

  @override
  String get conjugationSemiRegular => 'חצי רגילים';

  @override
  String get conjugationIrregular => 'חריגים';

  @override
  String get conjugationPronominal => 'פעלים חוזרים (פרונומינליים)';

  @override
  String conjugationGroup(Object group) {
    return 'קבוצה $group';
  }

  @override
  String conjugationAuxiliary(Object auxiliary) {
    return 'פועל עזר $auxiliary';
  }

  @override
  String get conjugationShowAnswers => 'הצג';

  @override
  String get conjugationHideAnswers => 'הסתר';

  @override
  String get conjugationNonPronominal => 'לא חוזרים';

  @override
  String get conjugationDetailsVisibility => 'הצג מאפייני פועל';

  @override
  String get conjugationClearFilters => 'נקה את כל המסננים';

  @override
  String get conjugationChooseVerb => 'בחר פועל';

  @override
  String get conjugationRandomVerb => 'פועל אקראי';

  @override
  String get conjugationHideBaseVerb => 'הסתר פועל בסיס';

  @override
  String get conjugationChooseMood => 'בחר אופן (Mood)';

  @override
  String get conjugationChooseTense => 'בחר זמן';

  @override
  String conjugationVerb(String verb) {
    return 'פועל: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'תרגום: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'אופן: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'זמן: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'שגיאת טעינה: $error';
  }

  @override
  String get profileLanguage => 'שפת הממשק';

  @override
  String get profileUserName => 'שם משתמש';

  @override
  String get profileAbout => 'על האפליקציה';

  @override
  String get profileAboutDescription => 'Parlami עוזר לך ללמוד איטלקית.';

  @override
  String get profileTheme => 'ערכת נושא';

  @override
  String get profileThemeDescription => 'מעבר בין מצב בהיר לכהה';

  @override
  String get themeSystem => 'ערכת נושא של המערכת';

  @override
  String get themeLight => 'ערכת נושא בהירה';

  @override
  String get themeDark => 'ערכת נושא כהה';

  @override
  String get vocabTitle => 'אוצר מילים';

  @override
  String get vocabReview => 'חזרה';

  @override
  String get vocabCatalog => 'קטלוג';

  @override
  String get vocabAdd => 'הוספה';

  @override
  String get vocabImport => 'ייבוא מילים';

  @override
  String get vocabExport => 'ייצוא המילים שלי';

  @override
  String get vocabResetCatalog => 'איפוס הקטלוג המקורי';

  @override
  String get vocabSelect => 'בחר';

  @override
  String get vocabSave => 'שמור מילה';

  @override
  String get vocabChooseCategories => 'בחר קטגוריות מילים';

  @override
  String get vocabPasteJson => 'הדבק רשימת JSON של מילים. פורמט נתמך:';

  @override
  String get vocabCancel => 'ביטול';

  @override
  String vocabImportError(String error) {
    return 'ייבוא נכשל: $error';
  }

  @override
  String get vocabResetQuestion => 'לאפס מילים מקוריות?';

  @override
  String get vocabResetDescription =>
      'פעולה זו מאפסת מילים שיובאו ומחילה מחדש את הקטלוג המקורי. מילים שהמשתמש הוסיף נשמרות.';

  @override
  String get vocabDeleteQuestion => 'למחוק מילה זו?';

  @override
  String vocabDeleteDescription(String word) {
    return 'למחוק את \"$word\" מהקטלוג?';
  }

  @override
  String get vocabDelete => 'מחק';

  @override
  String get vocabNoCategory => 'לא נבחרה קטגוריה';

  @override
  String get vocabLoading => 'טוען אוצר מילים...';

  @override
  String get vocabFields => 'שדות לקסיקליים';

  @override
  String get vocabNoMatch => 'אף מילה לא תואמת למסננים הנוכחיים.';

  @override
  String get vocabNoTrainingMatch => 'אף מילה לא תואמת למסנני התרגול.';

  @override
  String get vocabTrainingWord => 'מילת תרגול';

  @override
  String vocabScore(String score) {
    return 'ציון $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'שפת בסיס: $language';
  }

  @override
  String get vocabHiddenAnswer => 'תשובה מוסתרת.';

  @override
  String get vocabKnown => 'ידועה';

  @override
  String get vocabUnknown => 'לא ידועה';

  @override
  String get vocabNextWord => 'מילה הבאה';

  @override
  String vocabCategories(String categories) {
    return 'קטגוריות: $categories';
  }

  @override
  String get vocabPreparing => 'מכין מילות תרגול...';

  @override
  String get vocabPriority => 'תעדוף מילים שטרם נלמדו';

  @override
  String get vocabPriorityDescription => 'השבת כדי לערבב באופן אקראי.';

  @override
  String vocabSelectedCount(String count) {
    return 'מילים שנבחרו: $count';
  }

  @override
  String get vocabClearAll => 'נקה הכל';

  @override
  String get vocabConfirm => 'אישור';

  @override
  String get conjugationCheck => 'בדוק';

  @override
  String get conjugationNextVerb => 'הפועל הבא';

  @override
  String get eeNextSentence => 'המשפט הבא';

  @override
  String get eeNoSentence => 'אין משפט זמין';

  @override
  String ceLevel(String level) {
    return 'רמה: $level';
  }

  @override
  String get sampleItems => 'פריטים לדוגמה';

  @override
  String get sampleItemDetails => 'פרטי פריט';

  @override
  String get sampleMoreInformation => 'מידע נוסף כאן';

  @override
  String sampleItem(String id) {
    return 'פריט לדוגמה $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + תרבות';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + מהירות';

  @override
  String get conjugationAnswerLabel => 'התשובה שלך';

  @override
  String get vocabWords => 'מילים';

  @override
  String get vocabAverageMastery => 'שליטה ממוצעת';

  @override
  String get vocabMode => 'מצב';

  @override
  String get vocabMastery => 'שליטה';

  @override
  String get vocabRandom => 'אקראי';

  @override
  String get vocabSearchWord => 'חפש מילה';

  @override
  String get vocabBaseLanguageDisplay => 'הצג שפת בסיס';

  @override
  String get vocabDifficulty => 'קושי';

  @override
  String get vocabPartOfSpeech => 'חלק דיבר';

  @override
  String get vocabChooseFilterCategories => 'בחר קטגוריות סינון';

  @override
  String get vocabSearchTrainingWord => 'חפש מילה';

  @override
  String get vocabTrainingBaseLanguage => 'שפת בסיס לתרגול';

  @override
  String get vocabFilters => 'מסננים';

  @override
  String get vocabChooseTrainingCategories => 'בחר קטגוריות תרגול';

  @override
  String get vocabItalianWord => 'מילה באיטלקית';

  @override
  String get vocabFrenchTranslation => 'תרגום (שפת בסיס)';

  @override
  String get vocabOptionalArticle => 'תווית בחירה (il, la, l\', וכו\')';

  @override
  String get vocabCategoriesTitle => 'קטגוריות';

  @override
  String get vocabSearchCategory => 'חפש קטגוריה';

  @override
  String vocabAddCategory(String category) {
    return 'הוסף \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'מחק מהקטלוג';

  @override
  String get vocabHideAnswer => 'הסתר תשובה';

  @override
  String get vocabShowAnswer => 'הצג תשובה';

  @override
  String get vocabStatusSaved => 'מילה נשמרה וזמינה במסננים.';

  @override
  String vocabStatusImport(String count) {
    return 'הייבוא הושלם: $count מילים נוספו.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'הייצוא הושלם: $location';
  }

  @override
  String get vocabStatusNoExport => 'אין מילות משתמש לייצוא.';

  @override
  String get vocabStatusReset => 'הקטלוג המקורי אופס.';

  @override
  String get vocabStatusDeleted => 'המילה הוסרה מהקטלוג.';

  @override
  String get vocabStatusKnown => 'ידוע היטב.';

  @override
  String get vocabStatusReview => 'לחזור בקרוב.';

  @override
  String get vocabItalian => 'איטלקית';

  @override
  String get vocabFrench => 'צרפתית';

  @override
  String get vocabSourceOriginal => 'מקורי';

  @override
  String get vocabSourceUser => 'משתמש';

  @override
  String get vocabNoun => 'שם עצם';

  @override
  String get vocabVerb => 'פועל';

  @override
  String get vocabAdjective => 'שם תואר';

  @override
  String get vocabAdverb => 'תואר הפועל';

  @override
  String get vocabPronoun => 'כינוי גוף';

  @override
  String get vocabDeterminer => 'מיידע';

  @override
  String get vocabPreposition => 'מילת יחס';

  @override
  String get vocabConjunction => 'מילת חיבור';

  @override
  String get vocabInterjection => 'מילת קריאה';

  @override
  String get vocabExpression => 'ביטוי';

  @override
  String get vocabOther => 'אחר';

  @override
  String get profileDonate => 'תרומה';

  @override
  String get profileDonateDescription => 'תודה על תמיכתך';

  @override
  String get profilePrivacy => 'מדיניות פרטיות';

  @override
  String get profilePrivacyDescription => 'פתח את מדיניות הפרטיות';

  @override
  String get unavailable => 'התכונה עדיין אינה זמינה.';
}
