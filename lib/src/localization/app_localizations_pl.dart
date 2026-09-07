// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Ucz się';

  @override
  String get navTrain => 'Ćwicz';

  @override
  String get navEvaluate => 'Sprawdź się';

  @override
  String get navResults => 'Wyniki';

  @override
  String get navProfile => 'Profil';

  @override
  String get learnConjugation => 'Odmiana czasowników';

  @override
  String get learnConjugationDescription => 'Ćwicz odmianę czasowników';

  @override
  String get learnVocabulary => 'Słownictwo';

  @override
  String get learnVocabularyDescription => 'Według tematów i poziomów';

  @override
  String get learnNumbersDates => 'Liczby i daty';

  @override
  String get learnNumbersDatesDescription => 'Zapisywanie liczb i dat';

  @override
  String get learnGrammar => 'Gramatyka';

  @override
  String get learnGrammarDescription => 'Notatki z kursu';

  @override
  String get learnSpelling => 'Pisownia';

  @override
  String get learnSpellingDescription => 'Wkrótce';

  @override
  String get trainOralExpression => 'EO - Ekspresja ustna';

  @override
  String get trainOralExpressionDescription => 'Odpowiadaj na głos';

  @override
  String get trainOralComprehension => 'CO - Rozumienie ze słuchu';

  @override
  String get trainOralComprehensionDescription => 'Słuchaj stacji radiowych';

  @override
  String get trainWrittenComprehension => 'CE - Rozumienie tekstu czytanego';

  @override
  String get trainWrittenComprehensionDescription =>
      'Czytaj włoskie wiadomości';

  @override
  String get trainWrittenExpression => 'EE - Ekspresja pisemna';

  @override
  String get trainWrittenExpressionDescription => 'Tłumacz zdania';

  @override
  String get evaluateTitle => 'Sprawdź się - Prawdziwe sytuacje';

  @override
  String get evaluateIntro =>
      'Połącz kilka umiejętności jednocześnie, aby symulować prawdziwe sytuacje życiowe.';

  @override
  String get evaluateProgression =>
      'Uczenie buduje fundamenty. Praktyka celuje w konkretne umiejętności. Sprawdzian mierzy ogólne opanowanie materiału.';

  @override
  String get scenarioDailyConversation => 'Codzienna rozmowa';

  @override
  String get scenarioArticleSummary => 'Podsumowanie artykułu';

  @override
  String get scenarioMatchDebrief => 'Analiza meczu';

  @override
  String get scenarioQuickDiscussion => 'Szybka dyskusja';

  @override
  String get scenarioDailyConversationDetails =>
      'Słuchaj, zrozum, a następnie odpowiedz naturalnie.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Przeczytaj tekst i przygotuj jasne, uporządkowane podsumowanie.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Porozmawiaj o meczu, używając słownictwa i odniesień kulturowych.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'Reaguj szybko w dynamicznej wymianie zdań pod presją czasu.';

  @override
  String get resultsComingSoon => 'Wykresy wydajności wkrótce';

  @override
  String get grammarTitle => 'Gramatyka';

  @override
  String get grammarComingSoon =>
      'Notatki gramatyczne - treść wkrótce.\n\nDodaj notatki do tego modułu jako strony lub wyrenderowany Markdown.';

  @override
  String get spellingTitle => 'Pisownia';

  @override
  String get spellingComingSoon => 'Moduł pisowni - wkrótce.';

  @override
  String get ceTitle => 'CE - Rozumienie tekstu czytanego';

  @override
  String get ceIntro =>
      'Czytaj włoskie artykuły, aby poprawić czytanie ze zrozumieniem';

  @override
  String get ceAdviceTitle => 'Porada';

  @override
  String get ceAdvice =>
      'Zacznij od krótkich artykułów. Przeczytaj najpierw, aby zrozumieć ogólny sens, a potem jeszcze raz dla szczegółów.';

  @override
  String get ceOpenSource => 'Otwórz stronę źródłową';

  @override
  String get eeTitle => 'EE - Ekspresja pisemna';

  @override
  String get eePrompt => 'Przetłumacz poniższe zdanie na język włoski';

  @override
  String get eeTranslationLabel => 'Twoje tłumaczenie na włoski';

  @override
  String get eeTranslationHint => 'Wpisz swoje tłumaczenie tutaj...';

  @override
  String get eeCheck => 'Sprawdź';

  @override
  String get eeCorrection => 'Korekta';

  @override
  String get eeYourAnswer => 'Twoja odpowiedź';

  @override
  String get coTitle => 'CO - Rozumienie ze słuchu';

  @override
  String get coIntro =>
      'Słuchaj włoskich stacji radiowych, aby poprawić rozumienie ze słuchu';

  @override
  String get coLive => 'Na żywo:';

  @override
  String coStopped(Object station) {
    return '$station zatrzymana';
  }

  @override
  String coConnecting(Object station) {
    return 'Łączenie z $station...';
  }

  @override
  String get coPlay => 'Odtwarzaj';

  @override
  String get coStop => 'Zatrzymaj';

  @override
  String get coPause => 'Pauza';

  @override
  String get coResume => 'Wznów';

  @override
  String get coRadioGeneral => 'Włoskie radio ogólnotematyczne';

  @override
  String get coMusicEntertainment => 'Muzyka i rozrywka';

  @override
  String get coCultureNews => 'Kultura i wiadomości';

  @override
  String get coPopNews => 'Muzyka pop i wiadomości';

  @override
  String get coRadioNewsMusic => 'Wiadomości i muzyka';

  @override
  String get coNational => 'Ogólnokrajowe';

  @override
  String get ceAnsaDescription => 'Włoska agencja prasowa – krótkie artykuły';

  @override
  String get ceRepubblicaDescription => 'Duży włoski dziennik';

  @override
  String get ceCorriereDescription => 'Wiodący dziennik opiniotwórczy';

  @override
  String get ceIlPostDescription => 'Wiadomości i analizy';

  @override
  String get ceRaiDescription => 'Wiadomości RAI';

  @override
  String get ceEasyItalianDescription => 'Wiadomości w prostym włoskim';

  @override
  String get eoTitle => 'EO - Ekspresja ustna';

  @override
  String get eoChooseLevel => 'Wybierz poziom';

  @override
  String eoLevel(String level) {
    return 'Poziom $level';
  }

  @override
  String get eoNoQuestion => 'Brak dostępnych pytań';

  @override
  String get eoQuestion => 'Pytanie';

  @override
  String get eoHint => 'Podpowiedź';

  @override
  String get eoClickHint => 'Kliknij, aby uzyskać podpowiedź';

  @override
  String get eoAnswerHint => 'Wskazówka do odpowiedzi';

  @override
  String get eoClickAnswerHint =>
      'Kliknij, aby uzyskać wskazówkę do odpowiedzi';

  @override
  String get eoTimer => 'Stoper';

  @override
  String get eoTotal => 'Razem';

  @override
  String get eoSpeech => 'Mowa';

  @override
  String get eoHesitation => 'Zająknięcie';

  @override
  String get eoStart => 'Start';

  @override
  String get eoStop => 'Zatrzymaj';

  @override
  String get eoReset => 'Resetuj';

  @override
  String get eoModeFree => 'Tryb wolny';

  @override
  String get eoModeFreeDescription =>
      'Przechodź dalej, kiedy chcesz, bez pomocy.';

  @override
  String get eoModeEasy => 'Łatwy';

  @override
  String get eoModeEasyDescription =>
      'Odpowiedz, oceń siebie i zobacz wskazówkę.';

  @override
  String get eoModeHard => 'Trudny';

  @override
  String get eoModeHardDescription =>
      'Stoper, śledzenie zająknięć i samoocena.';

  @override
  String eoLevelChip(Object level) {
    return 'Poziom $level';
  }

  @override
  String get eoSelfEvaluation => 'Samoocena';

  @override
  String get eoExcellent => 'Doskonale';

  @override
  String get eoGood => 'Dobrze';

  @override
  String get eoAverage => 'Przeciętnie';

  @override
  String get eoDifficult => 'Trudno';

  @override
  String get eoNextQuestion => 'Następne pytanie';

  @override
  String get numDateTitle => 'Liczby i daty';

  @override
  String get numDateNumbersTab => 'Liczby';

  @override
  String get numDateDatesTab => 'Daty';

  @override
  String get numDateTimeTab => 'Godzina';

  @override
  String get numDatePreviewNumberTitle => 'Wybierz liczbę do podglądu';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Ta wartość jest używana tylko do szybkiej konwersji.';

  @override
  String get numDatePreviewNumberLabel => 'Liczba (podgląd)';

  @override
  String get numDatePositiveInteger =>
      'Wprowadź dodatnią liczbę całkowitą, aby rozpocząć.';

  @override
  String get numDateTraining => 'Ćwiczenia';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Wybierz inną liczbę, aby poćwiczyć pisanie jej słowami po włosku.';

  @override
  String get numDateTrainingNumberLabel => 'Liczba do ćwiczeń';

  @override
  String get numDateAnswerInWords => 'Twoja odpowiedź słownie';

  @override
  String get numDateCheck => 'Sprawdź';

  @override
  String get numDateClear => 'Wyczyść';

  @override
  String get numDatePreviewDateTitle => 'Wybierz datę do podglądu';

  @override
  String get numDatePreviewDateSubtitle =>
      'Ta data jest używana tylko jako szybkie odniesienie.';

  @override
  String get numDateToday => 'Dzisiaj';

  @override
  String get numDateTrainingDateSubtitle =>
      'Wybierz inną datę, aby poćwiczyć pisanie jej słowami po włosku.';

  @override
  String numDateExpectedDay(String day) {
    return 'Oczekiwany dzień: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Wybierz godzinę do podglądu';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Ta godzina służy tylko do szybkiego odczytu.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Wybierz inny czas do ćwiczeń, szczególnie kwadranse.';

  @override
  String get numDateDefinedTime => 'Zdefiniowany czas:';

  @override
  String get answerCorrect => 'Poprawna odpowiedź.';

  @override
  String get answerIncorrect => 'Błędna odpowiedź.';

  @override
  String answerYourAnswer(String answer) {
    return 'Twoja odpowiedź: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Poprawna odpowiedź: $answer';
  }

  @override
  String get conjugationTitle => 'Odmiana czasowników';

  @override
  String get conjugationRegular => 'Regularne';

  @override
  String get conjugationSemiRegular => 'Półregularne';

  @override
  String get conjugationIrregular => 'Nieregularne';

  @override
  String get conjugationPronominal => 'Zaimkowe';

  @override
  String conjugationGroup(Object group) {
    return 'Grupa $group';
  }

  @override
  String conjugationAuxiliary(Object auxiliary) {
    return 'Czasownik posiłkowy $auxiliary';
  }

  @override
  String get conjugationShowAnswers => 'Pokaż';

  @override
  String get conjugationHideAnswers => 'Ukryj';

  @override
  String get conjugationNonPronominal => 'Niezaimkowe';

  @override
  String get conjugationDetailsVisibility => 'Pokaż cechy czasownika';

  @override
  String get conjugationClearFilters => 'Wyczyść wszystkie filtry';

  @override
  String get conjugationChooseVerb => 'Wybierz czasownik';

  @override
  String get conjugationRandomVerb => 'Losowy czasownik';

  @override
  String get conjugationHideBaseVerb => 'Ukryj czasownik bazowy';

  @override
  String get conjugationChooseMood => 'Wybierz tryb';

  @override
  String get conjugationChooseTense => 'Wybierz czas';

  @override
  String conjugationVerb(String verb) {
    return 'Czasownik: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Tłumaczenie: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Tryb: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Czas: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Błąd ładowania: $error';
  }

  @override
  String get profileLanguage => 'Język interfejsu';

  @override
  String get profileUserName => 'Nazwa użytkownika';

  @override
  String get profileAbout => 'O aplikacji';

  @override
  String get profileAboutDescription => 'Parlami pomaga uczyć się włoskiego.';

  @override
  String get profileTheme => 'Motyw';

  @override
  String get profileThemeDescription =>
      'Przełącz między jasnym a ciemnym motywem';

  @override
  String get themeSystem => 'Motyw systemowy';

  @override
  String get themeLight => 'Jasny motyw';

  @override
  String get themeDark => 'Ciemny motyw';

  @override
  String get vocabTitle => 'Słownictwo';

  @override
  String get vocabReview => 'Powtórka';

  @override
  String get vocabCatalog => 'Katalog';

  @override
  String get vocabAdd => 'Dodaj';

  @override
  String get vocabImport => 'Importuj słowa';

  @override
  String get vocabExport => 'Eksportuj moje słowa';

  @override
  String get vocabResetCatalog => 'Zresetuj oryginalny katalog';

  @override
  String get vocabSelect => 'Wybierz';

  @override
  String get vocabSave => 'Zapisz słowo';

  @override
  String get vocabChooseCategories => 'Wybierz kategorie słów';

  @override
  String get vocabPasteJson =>
      'Wklej listę słów w formacie JSON. Akceptowany format:';

  @override
  String get vocabCancel => 'Anuluj';

  @override
  String vocabImportError(String error) {
    return 'Import nie powiódł się: $error';
  }

  @override
  String get vocabResetQuestion => 'Zresetować oryginalne słowa?';

  @override
  String get vocabResetDescription =>
      'To resetuje zaimportowane słowa i ponownie stosuje oryginalny katalog. Słowa dodane przez użytkownika są zachowane.';

  @override
  String get vocabDeleteQuestion => 'Usunąć to słowo?';

  @override
  String vocabDeleteDescription(String word) {
    return 'Usunąć \"$word\" z katalogu?';
  }

  @override
  String get vocabDelete => 'Usuń';

  @override
  String get vocabNoCategory => 'Nie wybrano kategorii';

  @override
  String get vocabLoading => 'Ładowanie słownictwa...';

  @override
  String get vocabFields => 'Pola leksykalne';

  @override
  String get vocabNoMatch => 'Żadne słowo nie pasuje do obecnych filtrów.';

  @override
  String get vocabNoTrainingMatch =>
      'Żadne słowo nie pasuje do filtrów ćwiczeń.';

  @override
  String get vocabTrainingWord => 'Słowo do ćwiczeń';

  @override
  String vocabScore(String score) {
    return 'Wynik $score%';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Język bazowy: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Odpowiedź ukryta.';

  @override
  String get vocabKnown => 'Znane';

  @override
  String get vocabUnknown => 'Nieznane';

  @override
  String get vocabNextWord => 'Następne słowo';

  @override
  String vocabCategories(String categories) {
    return 'Kategorie: $categories';
  }

  @override
  String get vocabPreparing => 'Przygotowywanie słów do ćwiczeń...';

  @override
  String get vocabPriority => 'Priorytetyzuj nieopanowane słowa';

  @override
  String get vocabPriorityDescription => 'Wyłącz, aby losować.';

  @override
  String vocabSelectedCount(String count) {
    return 'Wybrane słowa: $count';
  }

  @override
  String get vocabClearAll => 'Wyczyść wszystko';

  @override
  String get vocabConfirm => 'Potwierdź';

  @override
  String get conjugationCheck => 'Sprawdź';

  @override
  String get conjugationNextVerb => 'Następny czasownik';

  @override
  String get eeNextSentence => 'Następne zdanie';

  @override
  String get eeNoSentence => 'Brak dostępnych zdań';

  @override
  String ceLevel(String level) {
    return 'Poziom: $level';
  }

  @override
  String get sampleItems => 'Przykładowe elementy';

  @override
  String get sampleItemDetails => 'Szczegóły elementu';

  @override
  String get sampleMoreInformation => 'Więcej informacji tutaj';

  @override
  String sampleItem(String id) {
    return 'Przykładowy element $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Kultura';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Prędkość';

  @override
  String get conjugationAnswerLabel => 'Twoja odpowiedź';

  @override
  String get vocabWords => 'Słowa';

  @override
  String get vocabAverageMastery => 'Średnie opanowanie';

  @override
  String get vocabMode => 'Tryb';

  @override
  String get vocabMastery => 'Opanowanie';

  @override
  String get vocabRandom => 'Losowo';

  @override
  String get vocabSearchWord => 'Szukaj słowa';

  @override
  String get vocabBaseLanguageDisplay => 'Wyświetl język bazowy';

  @override
  String get vocabDifficulty => 'Trudność';

  @override
  String get vocabPartOfSpeech => 'Część mowy';

  @override
  String get vocabChooseFilterCategories => 'Wybierz kategorie filtrów';

  @override
  String get vocabSearchTrainingWord => 'Szukaj słowa';

  @override
  String get vocabTrainingBaseLanguage => 'Język bazowy ćwiczeń';

  @override
  String get vocabFilters => 'Filtry';

  @override
  String get vocabChooseTrainingCategories => 'Wybierz kategorie ćwiczeń';

  @override
  String get vocabItalianWord => 'Słowo włoskie';

  @override
  String get vocabFrenchTranslation => 'Tłumaczenie (język bazowy)';

  @override
  String get vocabOptionalArticle => 'Opcjonalny przedimek (il, la, l\', itd.)';

  @override
  String get vocabCategoriesTitle => 'Kategorie';

  @override
  String get vocabSearchCategory => 'Szukaj kategorii';

  @override
  String vocabAddCategory(String category) {
    return 'Dodaj \"$category\"';
  }

  @override
  String get vocabDeleteFromCatalog => 'Usuń z katalogu';

  @override
  String get vocabHideAnswer => 'Ukryj odpowiedź';

  @override
  String get vocabShowAnswer => 'Pokaż odpowiedź';

  @override
  String get vocabStatusSaved => 'Słowo zapisane i dostępne w filtrach.';

  @override
  String vocabStatusImport(String count) {
    return 'Import zakończony: dodano $count słów.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Eksport zakończony: $location';
  }

  @override
  String get vocabStatusNoExport => 'Brak słów użytkownika do wyeksportowania.';

  @override
  String get vocabStatusReset => 'Oryginalny katalog zresetowany.';

  @override
  String get vocabStatusDeleted => 'Słowo usunięte z katalogu.';

  @override
  String get vocabStatusKnown => 'Zanotowano.';

  @override
  String get vocabStatusReview => 'Do wczesnej powtórki.';

  @override
  String get vocabItalian => 'Włoski';

  @override
  String get vocabFrench => 'Francuski';

  @override
  String get vocabSourceOriginal => 'Oryginalne';

  @override
  String get vocabSourceUser => 'Użytkownik';

  @override
  String get vocabNoun => 'Rzeczownik';

  @override
  String get vocabVerb => 'Czasownik';

  @override
  String get vocabAdjective => 'Przymiotnik';

  @override
  String get vocabAdverb => 'Przysłówek';

  @override
  String get vocabPronoun => 'Zaimek';

  @override
  String get vocabDeterminer => 'Określnik';

  @override
  String get vocabPreposition => 'Przyimek';

  @override
  String get vocabConjunction => 'Spójnik';

  @override
  String get vocabInterjection => 'Wykrzyknik';

  @override
  String get vocabExpression => 'Wyrażenie';

  @override
  String get vocabOther => 'Inne';

  @override
  String get profileDonate => 'Przekaż darowiznę';

  @override
  String get profileDonateDescription => 'Dziękujemy za wsparcie';

  @override
  String get profilePrivacy => 'Polityka prywatności';

  @override
  String get profilePrivacyDescription => 'Otwórz politykę prywatności';

  @override
  String get unavailable => 'Funkcja jeszcze niedostępna.';
}
