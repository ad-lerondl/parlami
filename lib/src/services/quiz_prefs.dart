import 'package:shared_preferences/shared_preferences.dart';

class QuizPrefs {
  static const _kPrefix = 'conj.';
  static const _kInfinitive = '${_kPrefix}selectedInfinitive';
  static const _kMood = '${_kPrefix}selectedMood';
  static const _kTense = '${_kPrefix}selectedTense';
  static const _kPersons = '${_kPrefix}selectedPersons';
  static const _kShowBaseVerb = '${_kPrefix}showBaseVerb';
  static const _kShowAnswers = '${_kPrefix}showAnswers';
  static const _kShowDetails = '${_kPrefix}showDetails';
  static const _kFilterRegularity = '${_kPrefix}filterRegularity';
  static const _kFilterPronominal = '${_kPrefix}filterPronominal';
  static const _kFilterGroups = '${_kPrefix}filterGroups';
  static const _kFilterAuxiliary = '${_kPrefix}filterAuxiliary';

  static Future<void> saveState({
    String? infinitive,
    String? mood,
    String? tense,
    Iterable<String>? persons,
    bool? showBaseVerb,
    bool? showAnswers,
    bool? showDetails,
    bool? filterRegular,
    bool? filterPronominal,
    Iterable<String>? filterGroups,
    String? filterAuxiliary,
  }) async {
    try {
      final p = await SharedPreferences.getInstance();
      if (infinitive != null) await p.setString(_kInfinitive, infinitive);
      if (mood != null) await p.setString(_kMood, mood);
      if (tense != null) await p.setString(_kTense, tense);
      if (persons != null) await p.setStringList(_kPersons, persons.toList());
      if (showBaseVerb != null) await p.setBool(_kShowBaseVerb, showBaseVerb);
      if (showAnswers != null) await p.setBool(_kShowAnswers, showAnswers);
      if (showDetails != null) await p.setBool(_kShowDetails, showDetails);
      if (filterRegular != null) await p.setString(_kFilterRegularity, filterRegular ? 'regular' : 'irregular');
      if (filterPronominal != null)
        await p.setString(_kFilterPronominal, filterPronominal ? 'pronominal' : 'non-pronominal');
      if (filterGroups != null) await p.setStringList(_kFilterGroups, filterGroups.toList());
      if (filterAuxiliary != null) await p.setString(_kFilterAuxiliary, filterAuxiliary);
    } catch (e) {
      // Gracefully handle platforms where shared_preferences is not available (e.g., Web without proper setup)
      // Silently ignore preference save errors
    }
  }

  static Future<void> clearConjugationFilters() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove(_kFilterRegularity);
      await p.remove(_kFilterPronominal);
      await p.remove(_kFilterGroups);
      await p.remove(_kFilterAuxiliary);
    } catch (_) {}
  }

  static Future<void> clearRegularityFilter() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kFilterRegularity);
  }

  static Future<void> clearPronominalFilter() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kFilterPronominal);
  }

  static Future<void> clearAuxiliaryFilter() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kFilterAuxiliary);
  }

  static Future<QuizPrefsState> loadState() async {
    try {
      final p = await SharedPreferences.getInstance();
      return QuizPrefsState(
        infinitive: p.getString(_kInfinitive),
        mood: p.getString(_kMood),
        tense: p.getString(_kTense),
        persons: p.getStringList(_kPersons) ?? const <String>[],
        showBaseVerb: p.getBool(_kShowBaseVerb) ?? true,
        showAnswers: p.getBool(_kShowAnswers) ?? false,
        showDetails: p.getBool(_kShowDetails) ?? true,
        filterRegularity: p.getString(_kFilterRegularity),
        filterPronominal: p.getString(_kFilterPronominal),
        filterGroups: p.getStringList(_kFilterGroups) ?? const <String>[],
        filterAuxiliary: p.getString(_kFilterAuxiliary),
      );
    } catch (e) {
      // Return defaults if preferences unavailable
      // Silently return defaults on error
      return const QuizPrefsState(
        infinitive: null,
        mood: null,
        tense: null,
        persons: <String>[],
        showBaseVerb: true,
        showAnswers: false,
        showDetails: true,
        filterRegularity: null,
        filterPronominal: null,
        filterGroups: <String>[],
        filterAuxiliary: null,
      );
    }
  }
}

class QuizPrefsState {
  final String? infinitive;
  final String? mood;
  final String? tense;
  final List<String> persons;
  final bool showBaseVerb;
  final bool showAnswers;
  final bool showDetails;
  final String? filterRegularity;
  final String? filterPronominal;
  final List<String> filterGroups;
  final String? filterAuxiliary;

  const QuizPrefsState({
    required this.infinitive,
    required this.mood,
    required this.tense,
    required this.persons,
    required this.showBaseVerb,
    required this.showAnswers,
    required this.showDetails,
    required this.filterRegularity,
    required this.filterPronominal,
    required this.filterGroups,
    required this.filterAuxiliary,
  });
}
