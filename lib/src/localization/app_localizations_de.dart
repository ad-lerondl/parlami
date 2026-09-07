// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Parlami';

  @override
  String get navLearn => 'Lernen';

  @override
  String get navTrain => 'Üben';

  @override
  String get navEvaluate => 'Testen';

  @override
  String get navResults => 'Ergebnisse';

  @override
  String get navProfile => 'Profil';

  @override
  String get learnConjugation => 'Konjugation';

  @override
  String get learnConjugationDescription => 'Verben konjugieren üben';

  @override
  String get learnVocabulary => 'Wortschatz';

  @override
  String get learnVocabularyDescription => 'Nach Themen und Niveaus';

  @override
  String get learnNumbersDates => 'Zahlen & Daten';

  @override
  String get learnNumbersDatesDescription => 'Zahlen und Daten schreiben';

  @override
  String get learnGrammar => 'Grammatik';

  @override
  String get learnGrammarDescription => 'Kursnotizen';

  @override
  String get learnSpelling => 'Rechtschreibung';

  @override
  String get learnSpellingDescription => 'Demnächst verfügbar';

  @override
  String get trainOralExpression => 'EO - Mündlicher Ausdruck';

  @override
  String get trainOralExpressionDescription => 'Laut antworten';

  @override
  String get trainOralComprehension => 'CO - Hörverstehen';

  @override
  String get trainOralComprehensionDescription => 'Radiosender hören';

  @override
  String get trainWrittenComprehension => 'CE - Leseverstehen';

  @override
  String get trainWrittenComprehensionDescription =>
      'Italienische Nachrichten lesen';

  @override
  String get trainWrittenExpression => 'EE - Schriftlicher Ausdruck';

  @override
  String get trainWrittenExpressionDescription => 'Sätze übersetzen';

  @override
  String get evaluateTitle => 'Sich selbst testen - Reale Situationen';

  @override
  String get evaluateIntro =>
      'Kombiniere mehrere Fähigkeiten gleichzeitig, um reale Situationen zu simulieren.';

  @override
  String get evaluateProgression =>
      'Lernen schafft die Grundlagen. Üben zielt auf spezifische Fähigkeiten ab. Testen misst deine Gesamtbeherrschung.';

  @override
  String get scenarioDailyConversation => 'Alltagsgespräch';

  @override
  String get scenarioArticleSummary => 'Artikelzusammenfassung';

  @override
  String get scenarioMatchDebrief => 'Spielnachbesprechung';

  @override
  String get scenarioQuickDiscussion => 'Schnelle Diskussion';

  @override
  String get scenarioDailyConversationDetails =>
      'Zuhören, verstehen und natürlich antworten.';

  @override
  String get scenarioArticleSummaryDetails =>
      'Einen Text lesen und eine klare, strukturierte Zusammenfassung erstellen.';

  @override
  String get scenarioMatchDebriefDetails =>
      'Über ein Spiel mit Vokabeln und kulturellen Referenzen sprechen.';

  @override
  String get scenarioQuickDiscussionDetails =>
      'In einem dynamischen Austausch unter Zeitdruck schnell reagieren.';

  @override
  String get resultsComingSoon => 'Leistungsdiagramme (demnächst verfügbar)';

  @override
  String get grammarTitle => 'Grammatik';

  @override
  String get grammarComingSoon =>
      'Grammatiknotizen - Inhalt demnächst verfügbar.\n\nFüge Notizen als Seiten oder gerendertes Markdown zu diesem Modul hinzu.';

  @override
  String get spellingTitle => 'Rechtschreibung';

  @override
  String get spellingComingSoon => 'Rechtschreibmodul - demnächst verfügbar.';

  @override
  String get ceTitle => 'CE - Leseverstehen';

  @override
  String get ceIntro =>
      'Lies italienische Artikel, um dein Leseverstehen zu verbessern';

  @override
  String get ceAdviceTitle => 'Rat';

  @override
  String get ceAdvice =>
      'Beginne mit kurzen Artikeln. Lies zuerst für den allgemeinen Sinn, dann noch einmal für die Details.';

  @override
  String get ceOpenSource => 'Quell-Website öffnen';

  @override
  String get eeTitle => 'EE - Schriftlicher Ausdruck';

  @override
  String get eePrompt => 'Übersetze den folgenden Satz ins Italienische';

  @override
  String get eeTranslationLabel => 'Deine Übersetzung ins Italienische';

  @override
  String get eeTranslationHint => 'Schreibe deine Übersetzung hier...';

  @override
  String get eeCheck => 'Prüfen';

  @override
  String get eeCorrection => 'Korrektur';

  @override
  String get eeYourAnswer => 'Deine Antwort';

  @override
  String get coTitle => 'CO - Hörverstehen';

  @override
  String get coIntro =>
      'Höre italienische Radiosender, um dein Hörverstehen zu verbessern';

  @override
  String get coLive => 'Live:';

  @override
  String coStopped(Object station) {
    return '$station gestoppt';
  }

  @override
  String coConnecting(Object station) {
    return 'Verbinde mit $station...';
  }

  @override
  String get coPlay => 'Abspielen';

  @override
  String get coStop => 'Stopp';

  @override
  String get eoTitle => 'EO - Mündlicher Ausdruck';

  @override
  String get eoChooseLevel => 'Level wählen';

  @override
  String eoLevel(String level) {
    return 'Level $level';
  }

  @override
  String get eoNoQuestion => 'Keine Fragen verfügbar';

  @override
  String get eoQuestion => 'Frage';

  @override
  String get eoHint => 'Tipp';

  @override
  String get eoClickHint => 'Klicken für einen Tipp';

  @override
  String get eoAnswerHint => 'Antworthinweis';

  @override
  String get eoClickAnswerHint => 'Klicken für einen Antworthinweis';

  @override
  String get eoTimer => 'Timer';

  @override
  String get eoTotal => 'Gesamt';

  @override
  String get eoSpeech => 'Sprache';

  @override
  String get eoHesitation => 'Zögern';

  @override
  String get eoStart => 'Start';

  @override
  String get eoStop => 'Stopp';

  @override
  String get eoReset => 'Zurücksetzen';

  @override
  String get eoModeFree => 'Freier Modus';

  @override
  String get eoModeFreeDescription =>
      'Gehe vorwärts, wann immer du willst, ohne Hilfe.';

  @override
  String get eoModeEasy => 'Einfach';

  @override
  String get eoModeEasyDescription =>
      'Antworten, selbst bewerten und einen Antworthinweis anzeigen.';

  @override
  String get eoModeHard => 'Schwer';

  @override
  String get eoModeHardDescription =>
      'Timer, Zögerungsverfolgung und Selbstbewertung.';

  @override
  String eoLevelChip(Object level) {
    return 'Level $level';
  }

  @override
  String get eoSelfEvaluation => 'Selbstbewertung';

  @override
  String get eoExcellent => 'Ausgezeichnet';

  @override
  String get eoGood => 'Gut';

  @override
  String get eoAverage => 'Durchschnittlich';

  @override
  String get eoDifficult => 'Schwer';

  @override
  String get eoNextQuestion => 'Nächste Frage';

  @override
  String get numDateTitle => 'Zahlen & Daten';

  @override
  String get numDateNumbersTab => 'Zahlen';

  @override
  String get numDateDatesTab => 'Daten';

  @override
  String get numDateTimeTab => 'Uhrzeit';

  @override
  String get numDatePreviewNumberTitle => 'Vorschaunummer wählen';

  @override
  String get numDatePreviewNumberSubtitle =>
      'Dieser Wert dient nur zur schnellen Umrechnung.';

  @override
  String get numDatePreviewNumberLabel => 'Vorschaunummer';

  @override
  String get numDatePositiveInteger =>
      'Gib eine positive ganze Zahl ein, um zu beginnen.';

  @override
  String get numDateTraining => 'Üben';

  @override
  String get numDateTrainingNumberSubtitle =>
      'Wähle eine andere Zahl, um zu üben, sie in italienischen Wörtern zu schreiben.';

  @override
  String get numDateTrainingNumberLabel => 'Übungsnummer';

  @override
  String get numDateAnswerInWords => 'Deine Antwort in Wörtern';

  @override
  String get numDateCheck => 'Prüfen';

  @override
  String get numDateClear => 'Löschen';

  @override
  String get numDatePreviewDateTitle => 'Vorschaudatum wählen';

  @override
  String get numDatePreviewDateSubtitle =>
      'Dieses Datum dient nur als schnelle Referenz.';

  @override
  String get numDateToday => 'Heute';

  @override
  String get numDateTrainingDateSubtitle =>
      'Wähle ein anderes Datum, um zu üben, es in italienischen Wörtern zu schreiben.';

  @override
  String numDateExpectedDay(String day) {
    return 'Erwarteter Tag: $day';
  }

  @override
  String get numDatePreviewTimeTitle => 'Vorschauzeit wählen';

  @override
  String get numDatePreviewTimeSubtitle =>
      'Diese Zeit dient nur zum schnellen Ablesen.';

  @override
  String get numDateTrainingTimeSubtitle =>
      'Wähle eine andere Zeit zum Üben, besonders Viertelstunden.';

  @override
  String get numDateDefinedTime => 'Definierte Zeit:';

  @override
  String get answerCorrect => 'Richtige Antwort.';

  @override
  String get answerIncorrect => 'Falsche Antwort.';

  @override
  String answerYourAnswer(String answer) {
    return 'Deine Antwort: $answer';
  }

  @override
  String answerExpected(String answer) {
    return 'Richtige Antwort: $answer';
  }

  @override
  String get conjugationTitle => 'Konjugation';

  @override
  String get conjugationRegular => 'Regelmäßig';

  @override
  String get conjugationSemiRegular => 'Halbregelmäßig';

  @override
  String get conjugationIrregular => 'Unregelmäßig';

  @override
  String get conjugationClearFilters => 'Alle Filter löschen';

  @override
  String get conjugationChooseVerb => 'Ein Verb wählen';

  @override
  String get conjugationRandomVerb => 'Zufälliges Verb';

  @override
  String get conjugationHideBaseVerb => 'Basisverb ausblenden';

  @override
  String get conjugationChooseMood => 'Einen Modus wählen';

  @override
  String get conjugationChooseTense => 'Eine Zeitform wählen';

  @override
  String conjugationVerb(String verb) {
    return 'Verb: $verb';
  }

  @override
  String conjugationTranslation(String translation) {
    return 'Übersetzung: $translation';
  }

  @override
  String conjugationMood(String mood) {
    return 'Modus: $mood';
  }

  @override
  String conjugationTense(String tense) {
    return 'Zeitform: $tense';
  }

  @override
  String conjugationLoadingError(String error) {
    return 'Ladefehler: $error';
  }

  @override
  String get profileLanguage => 'Sprache der Benutzeroberfläche';

  @override
  String get profileUserName => 'Benutzername';

  @override
  String get profileAbout => 'Über die App';

  @override
  String get profileAboutDescription =>
      'Parlami hilft dir, Italienisch zu lernen.';

  @override
  String get profileTheme => 'Thema';

  @override
  String get profileThemeDescription =>
      'Zwischen hellem und dunklem Modus wechseln';

  @override
  String get themeSystem => 'Systemthema';

  @override
  String get themeLight => 'Helles Thema';

  @override
  String get themeDark => 'Dunkles Thema';

  @override
  String get vocabTitle => 'Wortschatz';

  @override
  String get vocabReview => 'Wiederholen';

  @override
  String get vocabCatalog => 'Katalog';

  @override
  String get vocabAdd => 'Hinzufügen';

  @override
  String get vocabImport => 'Wörter importieren';

  @override
  String get vocabExport => 'Meine Wörter exportieren';

  @override
  String get vocabResetCatalog => 'Originalkatalog zurücksetzen';

  @override
  String get vocabSelect => 'Auswählen';

  @override
  String get vocabSave => 'Wort speichern';

  @override
  String get vocabChooseCategories => 'Wortkategorien wählen';

  @override
  String get vocabPasteJson =>
      'Füge eine JSON-Liste von Wörtern ein. Akzeptiertes Format:';

  @override
  String get vocabCancel => 'Abbrechen';

  @override
  String vocabImportError(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get vocabResetQuestion => 'Originalwörter zurücksetzen?';

  @override
  String get vocabResetDescription =>
      'Dadurch werden importierte Wörter zurückgesetzt und der Originalkatalog wiederhergestellt. Vom Benutzer hinzugefügte Wörter bleiben erhalten.';

  @override
  String get vocabDeleteQuestion => 'Dieses Wort löschen?';

  @override
  String vocabDeleteDescription(String word) {
    return '\"$word\" aus dem Katalog löschen?';
  }

  @override
  String get vocabDelete => 'Löschen';

  @override
  String get vocabNoCategory => 'Keine Kategorie ausgewählt';

  @override
  String get vocabLoading => 'Wortschatz wird geladen...';

  @override
  String get vocabFields => 'Wortfelder';

  @override
  String get vocabNoMatch => 'Kein Wort entspricht den aktuellen Filtern.';

  @override
  String get vocabNoTrainingMatch => 'Kein Wort entspricht den Übungsfiltern.';

  @override
  String get vocabTrainingWord => 'Übungswort';

  @override
  String vocabScore(String score) {
    return 'Punktzahl $score %';
  }

  @override
  String vocabBaseLanguage(String language) {
    return 'Ausgangssprache: $language';
  }

  @override
  String get vocabHiddenAnswer => 'Antwort verborgen.';

  @override
  String get vocabKnown => 'Bekannt';

  @override
  String get vocabUnknown => 'Unbekannt';

  @override
  String get vocabNextWord => 'Nächstes Wort';

  @override
  String vocabCategories(String categories) {
    return 'Kategorien: $categories';
  }

  @override
  String get vocabPreparing => 'Bereite Übungswörter vor...';

  @override
  String get vocabPriority => 'Noch nicht beherrschte Wörter priorisieren';

  @override
  String get vocabPriorityDescription =>
      'Deaktivieren, um zufällig zu mischen.';

  @override
  String vocabSelectedCount(String count) {
    return 'Ausgewählte Wörter: $count';
  }

  @override
  String get vocabClearAll => 'Alles löschen';

  @override
  String get vocabConfirm => 'Bestätigen';

  @override
  String get conjugationCheck => 'Prüfen';

  @override
  String get conjugationNextVerb => 'Nächstes Verb';

  @override
  String get eeNextSentence => 'Nächster Satz';

  @override
  String get eeNoSentence => 'Kein Satz verfügbar';

  @override
  String ceLevel(String level) {
    return 'Level: $level';
  }

  @override
  String get sampleItems => 'Beispielelemente';

  @override
  String get sampleItemDetails => 'Elementdetails';

  @override
  String get sampleMoreInformation => 'Weitere Informationen hier';

  @override
  String sampleItem(String id) {
    return 'Beispielelement $id';
  }

  @override
  String get evaluateScenarioOral => 'CO + EO';

  @override
  String get evaluateScenarioWritten => 'CE + EE';

  @override
  String get evaluateScenarioCulture => 'EO + Kultur';

  @override
  String get evaluateScenarioSpeed => 'CO + EO + Geschwindigkeit';

  @override
  String get conjugationAnswerLabel => 'Deine Antwort';

  @override
  String get vocabWords => 'Wörter';

  @override
  String get vocabAverageMastery => 'Durchschnittliche Beherrschung';

  @override
  String get vocabMode => 'Modus';

  @override
  String get vocabMastery => 'Beherrschung';

  @override
  String get vocabRandom => 'Zufällig';

  @override
  String get vocabSearchWord => 'Nach einem Wort suchen';

  @override
  String get vocabBaseLanguageDisplay => 'Ausgangssprache anzeigen';

  @override
  String get vocabDifficulty => 'Schwierigkeit';

  @override
  String get vocabPartOfSpeech => 'Wortart';

  @override
  String get vocabChooseFilterCategories => 'Filterkategorien wählen';

  @override
  String get vocabSearchTrainingWord => 'Nach einem Wort suchen';

  @override
  String get vocabTrainingBaseLanguage => 'Übungsausgangssprache';

  @override
  String get vocabFilters => 'Filter';

  @override
  String get vocabChooseTrainingCategories => 'Übungskategorien wählen';

  @override
  String get vocabItalianWord => 'Italienisches Wort';

  @override
  String get vocabFrenchTranslation => 'Übersetzung (Ausgangssprache)';

  @override
  String get vocabOptionalArticle => 'Optionaler Artikel (il, la, l\', etc.)';

  @override
  String get vocabCategoriesTitle => 'Kategorien';

  @override
  String get vocabSearchCategory => 'Nach einer Kategorie suchen';

  @override
  String vocabAddCategory(String category) {
    return '\"$category\" hinzufügen';
  }

  @override
  String get vocabDeleteFromCatalog => 'Aus Katalog löschen';

  @override
  String get vocabHideAnswer => 'Antwort ausblenden';

  @override
  String get vocabShowAnswer => 'Antwort anzeigen';

  @override
  String get vocabStatusSaved => 'Wort gespeichert und in Filtern verfügbar.';

  @override
  String vocabStatusImport(String count) {
    return 'Import abgeschlossen: $count Wort(e) hinzugefügt.';
  }

  @override
  String vocabStatusExport(String location) {
    return 'Export abgeschlossen: $location';
  }

  @override
  String get vocabStatusNoExport => 'Keine Benutzerwörter zum Exportieren.';

  @override
  String get vocabStatusReset => 'Originalkatalog zurückgesetzt.';

  @override
  String get vocabStatusDeleted => 'Wort aus dem Katalog entfernt.';

  @override
  String get vocabStatusKnown => 'Gut gemerkt.';

  @override
  String get vocabStatusReview => 'Bald wiederholen.';

  @override
  String get vocabItalian => 'Italienisch';

  @override
  String get vocabFrench => 'Französisch';

  @override
  String get vocabSourceOriginal => 'Original';

  @override
  String get vocabSourceUser => 'Benutzer';

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
  String get vocabDeterminer => 'Begleiter';

  @override
  String get vocabPreposition => 'Präposition';

  @override
  String get vocabConjunction => 'Konjunktion';

  @override
  String get vocabInterjection => 'Interjektion';

  @override
  String get vocabExpression => 'Ausdruck';

  @override
  String get vocabOther => 'Andere';

  @override
  String get profileDonate => 'Spenden';

  @override
  String get profileDonateDescription => 'Danke für deine Unterstützung';

  @override
  String get profilePrivacy => 'Datenschutzrichtlinie';

  @override
  String get profilePrivacyDescription => 'Datenschutzrichtlinie öffnen';

  @override
  String get unavailable => 'Funktion noch nicht verfügbar.';
}
