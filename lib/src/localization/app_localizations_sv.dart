// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Lär dig';

  @override
  String get navTrain => 'Träna';

  @override
  String get navEvaluate => 'Testa dig själv';

  @override
  String get navResults => 'Resultat';

  @override
  String get navProfile => 'Profil';

  @override
  String get learnConjugation => 'Konjugation';

  @override
  String get learnConjugationDescription => 'Öva på att böja verb';

  @override
  String get learnVocabulary => 'Ordförråd';

  @override
  String get learnVocabularyDescription => 'Efter ämne och nivå';

  @override
  String get learnNumbersDates => 'Siffror och datum';

  @override
  String get learnNumbersDatesDescription => 'Skriv siffror och datum';

  @override
  String get learnGrammar => 'Grammatik';

  @override
  String get learnGrammarDescription => 'Kursanteckningar';

  @override
  String get learnSpelling => 'Stavning';

  @override
  String get learnSpellingDescription => 'Kommer snart';

  @override
  String get trainOralExpression => 'EO - Muntligt uttryck';

  @override
  String get trainOralExpressionDescription => 'Svara högt';

  @override
  String get trainOralComprehension => 'CO - Hörförståelse';

  @override
  String get trainOralComprehensionDescription => 'Lyssna på radiostationer';

  @override
  String get trainWrittenComprehension => 'CE - Läsförståelse';

  @override
  String get trainWrittenComprehensionDescription => 'Läs italienska nyheter';

  @override
  String get trainWrittenExpression => 'EE - Skriftligt uttryck';

  @override
  String get trainWrittenExpressionDescription => 'Översätt meningar';

  @override
  String get evaluateTitle => 'Testa dig själv - Verkliga situationer';

  @override
  String get evaluateIntro =>
      'Kombinera flera färdigheter samtidigt för att simulera verkliga situationer.';

  @override
  String get evaluateProgression =>
      'Inlärning bygger grunderna. Träning riktar sig mot specifika färdigheter. Test mäter din övergripande behärskning.';

  @override
  String get scenarioDailyConversation => 'Vardagskonversation';

  @override
  String get scenarioArticleSummary => 'Artikelsammanfattning';

  @override
  String get scenarioMatchDebrief => 'Matchgenomgång';

  @override
  String get scenarioQuickDiscussion => 'Snabb diskussion';

  @override
  String get scenarioDailyConversationDetails =>
      'Lyssna, förstå och svara sedan naturligt.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Läs en text och gör sedan en tydlig, strukturerad sammanfattning.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Prata om en match med hjälp av ordförråd och kulturella referenser.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'Reagera snabbt i ett dynamiskt utbyte med tidsbegränsning.';

  @override
  String get resultsComingSoon => 'Prestationsdiagram kommer snart';

  @override
  String get grammarTitle => 'Grammatik';

  @override
  String get grammarComingSoon =>
      'Grammatikanteckningar - innehåll kommer snart.\n\nLägg till anteckningar till denna modul som sidor eller renderad Markdown.';

  @override
  String get spellingTitle => 'Stavning';

  @override
  String get spellingComingSoon => 'Stavningsmodul - kommer snart.';

  @override
  String get ceTitle => 'CE - Läsförståelse';

  @override
  String get ceIntro =>
      'Läs italienska artiklar för att förbättra din läsförståelse';

  @override
  String get ceAdviceTitle => 'Råd';

  @override
  String get ceAdvice =>
      'Börja med korta artiklar. Läs först för att förstå huvudpoängen, läs sedan igen för detaljer.';

  @override
  String get ceOpenSource => 'Öppna källwebbplats';

  @override
  String get eeTitle => 'EE - Skriftligt uttryck';

  @override
  String get eePrompt => 'Översätt följande mening till italienska';

  @override
  String get eeTranslationLabel => 'Din översättning till italienska';

  @override
  String get eeTranslationHint => 'Skriv din översättning här...';

  @override
  String get eeCheck => 'Kontrollera';

  @override
  String get eeCorrection => 'Rättelse';

  @override
  String get eeYourAnswer => 'Ditt svar';

  @override
  String get coTitle => 'CO - Hörförståelse';

  @override
  String get coIntro =>
      'Lyssna på italienska radiostationer för att förbättra din hörförståelse';

  @override
  String get coLive => 'Live:';

  @override
  String coStopped(Object station) {
    return '$station stoppad';
  }

  @override
  String coConnecting(Object station) {
    return 'Ansluter till $station...';
  }

  @override
  String get coPlay => 'Spela';

  @override
  String get coStop => 'Stopp';

  @override
  String get eoTitle => 'EO - Muntligt uttryck';

  @override
  String get eoChooseLevel => 'Välj nivå';

  @override
  String eoLevel(String level) {
    return 'Nivå $level';
  }

  @override
  String get eoNoQuestion => 'Ingen fråga tillgänglig';

  @override
  String get eoQuestion => 'Fråga';

  @override
  String get eoHint => 'Tips';

  @override
  String get eoClickHint => 'Klicka för ett tips';

  @override
  String get eoAnswerHint => 'Svarledtråd';

  @override
  String get eoClickAnswerHint => 'Klicka för en svarledtråd';

  @override
  String get eoTimer => 'Timer';

  @override
  String get eoTotal => 'Totalt';

  @override
  String get eoSpeech => 'Tal';

  @override
  String get eoHesitation => 'Tvekan';

  @override
  String get eoStart => 'Start';

  @override
  String get eoStop => 'Stopp';

  @override
  String get eoReset => 'Återställ';

  @override
  String get eoModeFree => 'Fritt läge';

  @override
  String get eoModeFreeDescription => 'Gå framåt när du vill, utan hjälp.';

  @override
  String get eoModeEasy => 'Lätt';

  @override
  String get eoModeEasyDescription =>
      'Svara, utvärdera dig själv och se en ledtråd.';

  @override
  String get eoModeHard => 'Svårt';

  @override
  String get eoModeHardDescription =>
      'Timer, spårning av tvekan och självutvärdering.';

  @override
  String eoLevelChip(Object level) {
    return 'Nivå $level';
  }

  @override
  String get eoSelfEvaluation => 'Självutvärdering';

  @override
  String get eoExcellent => 'Utmärkt';

  @override
  String get eoGood => 'Bra';

  @override
  String get eoAverage => 'Medel';

  @override
  String get eoDifficult => 'Svårt';

  @override
  String get eoNextQuestion => 'Nästa fråga';

  @override
  String get numDateTitle => 'Siffror och datum';

  @override
  String get numDateNumbersTab => 'Siffror';

  @override
  String get numDateDatesTab => 'Datum';

  @override
  String get numDateTimeTab => 'Tid';

  @override
  String get numDatePreviewNumberTitle => 'Välj ett förhandsgranskningsnummer';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Detta värde används endast för snabb konvertering.';

  @override
  String get numDatePreviewNumberLabel => 'Förhandsgranskningsnummer';

  @override
  String get numDatePositiveInteger =>
      'Ange ett positivt heltal för att börja.';

  @override
  String get numDateTraining => 'Övning';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Välj ett annat nummer för att öva på att skriva det med italienska ord.';

  @override
  String get numDateTrainingNumberLabel => 'Övningsnummer';

  @override
  String get numDateAnswerInWords => 'Ditt svar i ord';

  @override
  String get numDateCheck => 'Kontrollera';

  @override
  String get numDateClear => 'Rensa';

  @override
  String get numDatePreviewDateTitle => 'Välj ett förhandsgranskningsdatum';

  @override
  String get numDatePreviewDateSubtitle =>
      'Detta datum används endast som en snabb referens.';

  @override
  String get numDateToday => 'Idag';

  @override
  String get numDateTrainingDateSubtitle =>
      'Välj ett annat datum för att öva på att skriva det med italienska ord.';

  @override
  String numDateExpectedDay(String day) {
    return 'Förväntad dag: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Välj en förhandsgranskningstid';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Denna tid används endast som en snabb referens.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Välj en annan tid att öva på, särskilt kvartar.';

  @override
  String get numDateDefinedTime => 'Angiven tid:';

  @override
  String get answerCorrect => 'Rätt svar.';

  @override
  String get answerIncorrect => 'Fel svar.';

  @override
  String answerYourAnswer(String answer) {
    return 'Ditt svar: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Rätt svar: $answer';
  }

  @override
  String get conjugationTitle => 'Konjugation';

  @override
  String get conjugationRegular => 'Regelbundna';

  @override
  String get conjugationSemiRegular => 'Halvregelbundna';

  @override
  String get conjugationIrregular => 'Oregelbundna';

  @override
  String get conjugationClearFilters => 'Rensa alla filter';

  @override
  String get conjugationChooseVerb => 'Välj ett verb';

  @override
  String get conjugationRandomVerb => 'Slumpmässigt verb';

  @override
  String get conjugationHideBaseVerb => 'Dölj grundverb';

  @override
  String get conjugationChooseMood => 'Välj modus';

  @override
  String get conjugationChooseTense => 'Välj tempus';

  @override
  String conjugationVerb(String verb) {
    return 'Verb: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Översättning: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Modus: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Tempus: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Laddningsfel: $error';
  }

  @override
  String get profileLanguage => 'Gränssnittsspråk';

  @override
  String get profileUserName => 'Användarnamn';

  @override
  String get profileAbout => 'Om appen';

  @override
  String get profileAboutDescription =>
      'Parlami hjälper dig att lära dig italienska.';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileThemeDescription => 'Växla mellan ljust och mörkt läge';

  @override
  String get themeSystem => 'Systemtema';

  @override
  String get themeLight => 'Ljust tema';

  @override
  String get themeDark => 'Mörkt tema';

  @override
  String get vocabTitle => 'Ordförråd';

  @override
  String get vocabReview => 'Repetera';

  @override
  String get vocabCatalog => 'Katalog';

  @override
  String get vocabAdd => 'Lägg till';

  @override
  String get vocabImport => 'Importera ord';

  @override
  String get vocabExport => 'Exportera mina ord';

  @override
  String get vocabResetCatalog => 'Återställ originalkatalog';

  @override
  String get vocabSelect => 'Välj';

  @override
  String get vocabSave => 'Spara ord';

  @override
  String get vocabChooseCategories => 'Välj ordkategorier';

  @override
  String get vocabPasteJson =>
      'Klistra in en JSON-lista med ord. Accepterat format:';

  @override
  String get vocabCancel => 'Avbryt';

  @override
  String vocabImportError(String error) {
    return 'Import misslyckades: $error';
  }

  @override
  String get vocabResetQuestion => 'Återställa originalord?';

  @override
  String get vocabResetDescription =>
      'Detta återställer importerade ord och tillämpar originalkatalogen igen. Användartillagda ord behålls.';

  @override
  String get vocabDeleteQuestion => 'Ta bort detta ord?';

  @override
  String vocabDeleteDescription(String word) {
    return 'Ta bort \"$word\" från katalogen?';
  }

  @override
  String get vocabDelete => 'Ta bort';

  @override
  String get vocabNoCategory => 'Ingen kategori vald';

  @override
  String get vocabLoading => 'Laddar ordförråd...';

  @override
  String get vocabFields => 'Lexikala fält';

  @override
  String get vocabNoMatch => 'Inget ord matchar de aktuella filtren.';

  @override
  String get vocabNoTrainingMatch => 'Inget ord matchar träningsfiltren.';

  @override
  String get vocabTrainingWord => 'Träningsord';

  @override
  String vocabScore(String score) {
    return 'Poäng $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Basksrpåk: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Svaret är dolt.';

  @override
  String get vocabKnown => 'Känt';

  @override
  String get vocabUnknown => 'Okänt';

  @override
  String get vocabNextWord => 'Nästa ord';

  @override
  String vocabCategories(String categories) {
    return 'Kategorier: $categories';
  }

  @override
  String get vocabPreparing => 'Förbereder träningsord...';

  @override
  String get vocabPriority => 'Prioritera ord som ännu inte bemästrats';

  @override
  String get vocabPriorityDescription =>
      'Inaktivera för att blanda slumpmässigt.';

  @override
  String vocabSelectedCount(String count) {
    return 'Valda ord: $count';
  }

  @override
  String get vocabClearAll => 'Rensa alla';

  @override
  String get vocabConfirm => 'Bekräfta';

  @override
  String get conjugationCheck => 'Kontrollera';

  @override
  String get conjugationNextVerb => 'Nästa verb';

  @override
  String get eeNextSentence => 'Nästa mening';

  @override
  String get eeNoSentence => 'Ingen mening tillgänglig';

  @override
  String ceLevel(String level) {
    return 'Nivå: $level';
  }

  @override
  String get sampleItems => 'Exempelobjekt';

  @override
  String get sampleItemDetails => 'Objektdetaljer';

  @override
  String get sampleMoreInformation => 'Mer information här';

  @override
  String sampleItem(String id) {
    return 'Exempelobjekt $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Kultur';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Hastighet';

  @override
  String get conjugationAnswerLabel => 'Ditt svar';

  @override
  String get vocabWords => 'Ord';

  @override
  String get vocabAverageMastery => 'Genomsnittlig behärskning';

  @override
  String get vocabMode => 'Läge';

  @override
  String get vocabMastery => 'Behärskning';

  @override
  String get vocabRandom => 'Slumpmässigt';

  @override
  String get vocabSearchWord => 'Sök efter ett ord';

  @override
  String get vocabBaseLanguageDisplay => 'Visa basksrpåk';

  @override
  String get vocabDifficulty => 'Svårighetsgrad';

  @override
  String get vocabPartOfSpeech => 'Ordklass';

  @override
  String get vocabChooseFilterCategories => 'Välj filterkategorier';

  @override
  String get vocabSearchTrainingWord => 'Sök efter ett ord';

  @override
  String get vocabTrainingBaseLanguage => 'Basksrpåk för träning';

  @override
  String get vocabFilters => 'Filter';

  @override
  String get vocabChooseTrainingCategories => 'Välj träningskategorier';

  @override
  String get vocabItalianWord => 'Italienskt ord';

  @override
  String get vocabFrenchTranslation => 'Översättning (basksrpåk)';

  @override
  String get vocabOptionalArticle => 'Valfri artikel (il, la, l\', etc.)';

  @override
  String get vocabCategoriesTitle => 'Kategorier';

  @override
  String get vocabSearchCategory => 'Sök efter en kategori';

  @override
  String vocabAddCategory(String category) {
    return 'Lägg till \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'Ta bort från katalogen';

  @override
  String get vocabHideAnswer => 'Dölj svar';

  @override
  String get vocabShowAnswer => 'Visa svar';

  @override
  String get vocabStatusSaved => 'Ord sparat och tillgängligt i filter.';

  @override
  String vocabStatusImport(String count) {
    return 'Import slutförd: $count ord lades till.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Export slutförd: $location';
  }

  @override
  String get vocabStatusNoExport => 'Inga användarord att exportera.';

  @override
  String get vocabStatusReset => 'Originalkatalog återställd.';

  @override
  String get vocabStatusDeleted => 'Ord borttaget från katalogen.';

  @override
  String get vocabStatusKnown => 'Noterat.';

  @override
  String get vocabStatusReview => 'Repetera snart.';

  @override
  String get vocabItalian => 'Italienska';

  @override
  String get vocabFrench => 'Franska';

  @override
  String get vocabSourceOriginal => 'Original';

  @override
  String get vocabSourceUser => 'Användare';

  @override
  String get vocabNoun => 'Substantiv';

  @override
  String get vocabVerb => 'Verb';

  @override
  String get vocabAdjective => 'Adjektiv';

  @override
  String get vocabAdverb => 'Adverb';

  @override
  String get vocabPronoun => 'Pronomen';

  @override
  String get vocabDeterminer => 'Bestämningsord';

  @override
  String get vocabPreposition => 'Preposition';

  @override
  String get vocabConjunction => 'Konjunktion';

  @override
  String get vocabInterjection => 'Interjektion';

  @override
  String get vocabExpression => 'Uttryck';

  @override
  String get vocabOther => 'Annat';

  @override
  String get profileDonate => 'Ge en gåva';

  @override
  String get profileDonateDescription => 'Tack för ditt stöd';

  @override
  String get profilePrivacy => 'Integritetspolicy';

  @override
  String get profilePrivacyDescription => 'Öppna integritetspolicyn';

  @override
  String get unavailable => 'Funktionen är ännu inte tillgänglig.';
}
