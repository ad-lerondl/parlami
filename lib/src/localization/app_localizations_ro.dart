// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Învață';

  @override
  String get navTrain => 'Exersează';

  @override
  String get navEvaluate => 'Testează-te';

  @override
  String get navResults => 'Rezultate';

  @override
  String get navProfile => 'Profil';

  @override
  String get learnConjugation => 'Conjugare';

  @override
  String get learnConjugationDescription => 'Exersează conjugarea verbelor';

  @override
  String get learnVocabulary => 'Vocabular';

  @override
  String get learnVocabularyDescription => 'Pe teme și niveluri';

  @override
  String get learnNumbersDates => 'Numere și date';

  @override
  String get learnNumbersDatesDescription => 'Scrierea numerelor și a datelor';

  @override
  String get learnGrammar => 'Gramatică';

  @override
  String get learnGrammarDescription => 'Note de curs';

  @override
  String get learnSpelling => 'Ortografie';

  @override
  String get learnSpellingDescription => 'În curând';

  @override
  String get trainOralExpression => 'EO - Expresie orală';

  @override
  String get trainOralExpressionDescription => 'Răspunde cu voce tare';

  @override
  String get trainOralComprehension => 'CO - Înțelegere orală';

  @override
  String get trainOralComprehensionDescription => 'Ascultă stații radio';

  @override
  String get trainWrittenComprehension => 'CE - Înțelegere scrisă';

  @override
  String get trainWrittenComprehensionDescription =>
      'Citește știri în italiană';

  @override
  String get trainWrittenExpression => 'EE - Expresie scrisă';

  @override
  String get trainWrittenExpressionDescription => 'Tradu propoziții';

  @override
  String get evaluateTitle => 'Testează-te - Situații reale';

  @override
  String get evaluateIntro =>
      'Combină mai multe abilități simultan pentru a simula situații reale.';

  @override
  String get evaluateProgression =>
      'Învățarea construiește bazele. Exersarea vizează abilități specifice. Testarea măsoară stăpânirea generală.';

  @override
  String get scenarioDailyConversation => 'Conversație zilnică';

  @override
  String get scenarioArticleSummary => 'Rezumat articol';

  @override
  String get scenarioMatchDebrief => 'Analiză meci';

  @override
  String get scenarioQuickDiscussion => 'Discuție rapidă';

  @override
  String get scenarioDailyConversationDetails =>
      'Ascultă, înțelege și răspunde natural.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Citește un text și creează un rezumat clar și structurat.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Vorbește despre un meci folosind vocabular și referințe culturale.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'Reacționează rapid într-un schimb dinamic cu limită de timp.';

  @override
  String get resultsComingSoon => 'Grafice de performanță în curând';

  @override
  String get grammarTitle => 'Gramatică';

  @override
  String get grammarComingSoon =>
      'Note de gramatică - conținut în curând.\n\nAdaugă note în acest modul ca pagini sau Markdown randat.';

  @override
  String get spellingTitle => 'Ortografie';

  @override
  String get spellingComingSoon => 'Modul de ortografie - în curând.';

  @override
  String get ceTitle => 'CE - Înțelegere scrisă';

  @override
  String get ceIntro =>
      'Citește articole în italiană pentru a-ți îmbunătăți înțelegerea scrisă';

  @override
  String get ceAdviceTitle => 'Sfat';

  @override
  String get ceAdvice =>
      'Începe cu articole scurte. Citește prima dată pentru sensul general, apoi recitește pentru detalii.';

  @override
  String get ceOpenSource => 'Deschide site-ul sursă';

  @override
  String get eeTitle => 'EE - Expresie scrisă';

  @override
  String get eePrompt => 'Tradu următoarea propoziție în italiană';

  @override
  String get eeTranslationLabel => 'Traducerea ta în italiană';

  @override
  String get eeTranslationHint => 'Scrie traducerea aici...';

  @override
  String get eeCheck => 'Verifică';

  @override
  String get eeCorrection => 'Corecție';

  @override
  String get eeYourAnswer => 'Răspunsul tău';

  @override
  String get coTitle => 'CO - Înțelegere orală';

  @override
  String get coIntro =>
      'Ascultă posturi de radio italiene pentru a-ți îmbunătăți înțelegerea orală';

  @override
  String get coLive => 'În direct:';

  @override
  String coStopped(Object station) {
    return '$station oprit';
  }

  @override
  String coConnecting(Object station) {
    return 'Conectare la $station...';
  }

  @override
  String get coPlay => 'Redare';

  @override
  String get coStop => 'Stop';

  @override
  String get coPause => 'Pauză';

  @override
  String get coResume => 'Reia';

  @override
  String get coRadioGeneral => 'Radio generalist italian';

  @override
  String get coMusicEntertainment => 'Muzică și divertisment';

  @override
  String get coCultureNews => 'Cultură și știri';

  @override
  String get coPopNews => 'Muzică pop și știri';

  @override
  String get coRadioNewsMusic => 'Știri și muzică';

  @override
  String get coNational => 'Național';

  @override
  String get ceAnsaDescription => 'Agenție de presă italiană - articole scurte';

  @override
  String get ceRepubblicaDescription => 'Cotidian italian de referință';

  @override
  String get ceCorriereDescription => 'Ziar de referință';

  @override
  String get ceIlPostDescription => 'Știri și analize';

  @override
  String get ceRaiDescription => 'Știri RAI';

  @override
  String get ceEasyItalianDescription => 'Știri în italiană ușoară';

  @override
  String get eoTitle => 'EO - Expresie orală';

  @override
  String get eoChooseLevel => 'Alege nivelul';

  @override
  String eoLevel(String level) {
    return 'Nivel $level';
  }

  @override
  String get eoNoQuestion => 'Nicio întrebare disponibilă';

  @override
  String get eoQuestion => 'Întrebare';

  @override
  String get eoHint => 'Indiciu';

  @override
  String get eoClickHint => 'Fă clic pentru un indiciu';

  @override
  String get eoAnswerHint => 'Indiciu pentru răspuns';

  @override
  String get eoClickAnswerHint => 'Fă clic pentru un indiciu de răspuns';

  @override
  String get eoTimer => 'Cronometru';

  @override
  String get eoTotal => 'Total';

  @override
  String get eoSpeech => 'Vorbire';

  @override
  String get eoHesitation => 'Ezitare';

  @override
  String get eoStart => 'Start';

  @override
  String get eoStop => 'Stop';

  @override
  String get eoReset => 'Resetare';

  @override
  String get eoModeFree => 'Mod liber';

  @override
  String get eoModeFreeDescription =>
      'Mergi mai departe oricând dorești, fără ajutor.';

  @override
  String get eoModeEasy => 'Ușor';

  @override
  String get eoModeEasyDescription =>
      'Răspunde, autoevaluează-te și vezi un indiciu.';

  @override
  String get eoModeHard => 'Dificil';

  @override
  String get eoModeHardDescription =>
      'Cronometru, urmărirea ezitărilor și autoevaluare.';

  @override
  String eoLevelChip(Object level) {
    return 'Nivel $level';
  }

  @override
  String get eoSelfEvaluation => 'Autoevaluare';

  @override
  String get eoExcellent => 'Excelent';

  @override
  String get eoGood => 'Bine';

  @override
  String get eoAverage => 'Mediu';

  @override
  String get eoDifficult => 'Dificil';

  @override
  String get eoNextQuestion => 'Următoarea întrebare';

  @override
  String get numDateTitle => 'Numere și date';

  @override
  String get numDateNumbersTab => 'Numere';

  @override
  String get numDateDatesTab => 'Date';

  @override
  String get numDateTimeTab => 'Oră';

  @override
  String get numDatePreviewNumberTitle =>
      'Alege un număr pentru previzualizare';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Această valoare este utilizată doar pentru conversie rapidă.';

  @override
  String get numDatePreviewNumberLabel => 'Număr previzualizat';

  @override
  String get numDatePositiveInteger =>
      'Introdu un număr întreg pozitiv pentru a începe.';

  @override
  String get numDateTraining => 'Exersare';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Alege alt număr pentru a exersa scrierea acestuia în italiană.';

  @override
  String get numDateTrainingNumberLabel => 'Număr de exersare';

  @override
  String get numDateAnswerInWords => 'Răspunsul tău în cuvinte';

  @override
  String get numDateCheck => 'Verifică';

  @override
  String get numDateClear => 'Șterge';

  @override
  String get numDatePreviewDateTitle => 'Alege o dată pentru previzualizare';

  @override
  String get numDatePreviewDateSubtitle =>
      'Această dată este folosită doar ca referință rapidă.';

  @override
  String get numDateToday => 'Astăzi';

  @override
  String get numDateTrainingDateSubtitle =>
      'Alege altă dată pentru a exersa scrierea acesteia în italiană.';

  @override
  String numDateExpectedDay(String day) {
    return 'Ziua așteptată: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Alege o oră pentru previzualizare';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Această oră este folosită doar pentru citire rapidă.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Alege o altă oră pentru exersare, în special sferturi de oră.';

  @override
  String get numDateDefinedTime => 'Timp definit:';

  @override
  String get answerCorrect => 'Răspuns corect.';

  @override
  String get answerIncorrect => 'Răspuns incorect.';

  @override
  String answerYourAnswer(String answer) {
    return 'Răspunsul tău: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Răspuns corect: $answer';
  }

  @override
  String get conjugationTitle => 'Conjugare';

  @override
  String get conjugationRegular => 'Regulate';

  @override
  String get conjugationSemiRegular => 'Semi-regulate';

  @override
  String get conjugationIrregular => 'Neregulate';

  @override
  String get conjugationPronominal => 'Pronominale';

  @override
  String conjugationGroup(Object group) {
    return 'Grupul $group';
  }

  @override
  String conjugationAuxiliary(Object auxiliary) {
    return 'Auxiliar $auxiliary';
  }

  @override
  String get conjugationShowAnswers => 'Afișează';

  @override
  String get conjugationHideAnswers => 'Ascunde';

  @override
  String get conjugationNonPronominal => 'Nepronominale';

  @override
  String get conjugationDetailsVisibility =>
      'Afișează caracteristicile verbului';

  @override
  String get conjugationClearFilters => 'Șterge toate filtrele';

  @override
  String get conjugationChooseVerb => 'Alege un verb';

  @override
  String get conjugationRandomVerb => 'Verb aleatoriu';

  @override
  String get conjugationHideBaseVerb => 'Ascunde verbul de bază';

  @override
  String get conjugationChooseMood => 'Alege un mod';

  @override
  String get conjugationChooseTense => 'Alege un timp';

  @override
  String conjugationVerb(String verb) {
    return 'Verb: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Traducere: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Mod: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Timp: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Eroare de încărcare: $error';
  }

  @override
  String get profileLanguage => 'Limba interfeței';

  @override
  String get profileUserName => 'Nume de utilizator';

  @override
  String get profileAbout => 'Despre aplicație';

  @override
  String get profileAboutDescription => 'Parlami te ajută să înveți italiana.';

  @override
  String get profileTheme => 'Temă';

  @override
  String get profileThemeDescription =>
      'Comută între modul luminos și cel întunecat';

  @override
  String get themeSystem => 'Tema sistemului';

  @override
  String get themeLight => 'Temă luminoasă';

  @override
  String get themeDark => 'Temă întunecată';

  @override
  String get vocabTitle => 'Vocabular';

  @override
  String get vocabReview => 'Revizuire';

  @override
  String get vocabCatalog => 'Catalog';

  @override
  String get vocabAdd => 'Adaugă';

  @override
  String get vocabImport => 'Importă cuvinte';

  @override
  String get vocabExport => 'Exportă cuvintele mele';

  @override
  String get vocabResetCatalog => 'Resetează catalogul original';

  @override
  String get vocabSelect => 'Selectează';

  @override
  String get vocabSave => 'Salvează cuvântul';

  @override
  String get vocabChooseCategories => 'Alege categoriile';

  @override
  String get vocabPasteJson =>
      'Lipește o listă JSON de cuvinte. Format acceptat:';

  @override
  String get vocabCancel => 'Anulează';

  @override
  String vocabImportError(String error) {
    return 'Import eșuat: $error';
  }

  @override
  String get vocabResetQuestion => 'Resetezi cuvintele originale?';

  @override
  String get vocabResetDescription =>
      'Aceasta va reseta cuvintele importate și va reaplica catalogul original. Cuvintele adăugate de utilizator sunt păstrate.';

  @override
  String get vocabDeleteQuestion => 'Ștergi acest cuvânt?';

  @override
  String vocabDeleteDescription(String word) {
    return 'Ștergi \"$word\" din catalog?';
  }

  @override
  String get vocabDelete => 'Șterge';

  @override
  String get vocabNoCategory => 'Nicio categorie selectată';

  @override
  String get vocabLoading => 'Se încarcă vocabularul...';

  @override
  String get vocabFields => 'Câmpuri lexicale';

  @override
  String get vocabNoMatch => 'Niciun cuvânt nu corespunde filtrelor actuale.';

  @override
  String get vocabNoTrainingMatch =>
      'Niciun cuvânt nu se potrivește filtrelor de antrenament.';

  @override
  String get vocabTrainingWord => 'Cuvânt de antrenament';

  @override
  String vocabScore(String score) {
    return 'Scor $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Limba de bază: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Răspuns ascuns.';

  @override
  String get vocabKnown => 'Cunoscut';

  @override
  String get vocabUnknown => 'Necunoscut';

  @override
  String get vocabNextWord => 'Următorul cuvânt';

  @override
  String vocabCategories(String categories) {
    return 'Categorii: $categories';
  }

  @override
  String get vocabPreparing => 'Se pregătesc cuvintele de antrenament...';

  @override
  String get vocabPriority =>
      'Prioritizează cuvintele care nu au fost asimilate';

  @override
  String get vocabPriorityDescription =>
      'Dezactivează pentru a amesteca aleatoriu.';

  @override
  String vocabSelectedCount(String count) {
    return 'Cuvinte selectate: $count';
  }

  @override
  String get vocabClearAll => 'Șterge tot';

  @override
  String get vocabConfirm => 'Confirmă';

  @override
  String get conjugationCheck => 'Verifică';

  @override
  String get conjugationNextVerb => 'Următorul verb';

  @override
  String get eeNextSentence => 'Următoarea propoziție';

  @override
  String get eeNoSentence => 'Nicio propoziție disponibilă';

  @override
  String ceLevel(String level) {
    return 'Nivel: $level';
  }

  @override
  String get sampleItems => 'Elemente eșantion';

  @override
  String get sampleItemDetails => 'Detalii element';

  @override
  String get sampleMoreInformation => 'Mai multe informații aici';

  @override
  String sampleItem(String id) {
    return 'Element eșantion $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Cultură';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Viteză';

  @override
  String get conjugationAnswerLabel => 'Răspunsul tău';

  @override
  String get vocabWords => 'Cuvinte';

  @override
  String get vocabAverageMastery => 'Stăpânire medie';

  @override
  String get vocabMode => 'Mod';

  @override
  String get vocabMastery => 'Stăpânire';

  @override
  String get vocabRandom => 'Aleatoriu';

  @override
  String get vocabSearchWord => 'Caută un cuvânt';

  @override
  String get vocabBaseLanguageDisplay => 'Afișează limba de bază';

  @override
  String get vocabDifficulty => 'Dificultate';

  @override
  String get vocabPartOfSpeech => 'Parte de vorbire';

  @override
  String get vocabChooseFilterCategories => 'Alege categoriile filtrului';

  @override
  String get vocabSearchTrainingWord => 'Caută un cuvânt';

  @override
  String get vocabTrainingBaseLanguage => 'Limba de bază pentru antrenament';

  @override
  String get vocabFilters => 'Filtre';

  @override
  String get vocabChooseTrainingCategories =>
      'Alege categoriile de antrenament';

  @override
  String get vocabItalianWord => 'Cuvânt în italiană';

  @override
  String get vocabFrenchTranslation => 'Traducere (limba de bază)';

  @override
  String get vocabOptionalArticle => 'Articol opțional (il, la, l\', etc.)';

  @override
  String get vocabCategoriesTitle => 'Categorii';

  @override
  String get vocabSearchCategory => 'Caută o categorie';

  @override
  String vocabAddCategory(String category) {
    return 'Adaugă \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'Șterge din catalog';

  @override
  String get vocabHideAnswer => 'Ascunde răspunsul';

  @override
  String get vocabShowAnswer => 'Afișează răspunsul';

  @override
  String get vocabStatusSaved => 'Cuvânt salvat și disponibil în filtre.';

  @override
  String vocabStatusImport(String count) {
    return 'Import complet: $count cuvinte adăugate.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Export complet: $location';
  }

  @override
  String get vocabStatusNoExport =>
      'Nu există cuvinte de utilizator pentru export.';

  @override
  String get vocabStatusReset => 'Catalog original resetat.';

  @override
  String get vocabStatusDeleted => 'Cuvânt eliminat din catalog.';

  @override
  String get vocabStatusKnown => 'Bine de știut.';

  @override
  String get vocabStatusReview => 'Revizuire în curând.';

  @override
  String get vocabItalian => 'Italiană';

  @override
  String get vocabFrench => 'Franceză';

  @override
  String get vocabSourceOriginal => 'Original';

  @override
  String get vocabSourceUser => 'Utilizator';

  @override
  String get vocabNoun => 'Substantiv';

  @override
  String get vocabVerb => 'Verb';

  @override
  String get vocabAdjective => 'Adjectiv';

  @override
  String get vocabAdverb => 'Adverb';

  @override
  String get vocabPronoun => 'Pronume';

  @override
  String get vocabDeterminer => 'Determinant';

  @override
  String get vocabPreposition => 'Prepoziție';

  @override
  String get vocabConjunction => 'Conjuncție';

  @override
  String get vocabInterjection => 'Interjecție';

  @override
  String get vocabExpression => 'Expresie';

  @override
  String get vocabOther => 'Altele';

  @override
  String get profileDonate => 'Fă o donație';

  @override
  String get profileDonateDescription => 'Mulțumim pentru sprijin';

  @override
  String get profilePrivacy => 'Politică de confidențialitate';

  @override
  String get profilePrivacyDescription =>
      'Deschide politica de confidențialitate';

  @override
  String get unavailable => 'Funcția nu este încă disponibilă.';
}
