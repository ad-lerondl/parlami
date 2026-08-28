import 'package:shared_preferences/shared_preferences.dart';

class QuizPrefs {
  static const _kPrefix = 'conj.';
  static const _kInfinitive = '${_kPrefix}selectedInfinitive';
  static const _kMood = '${_kPrefix}selectedMood';
  static const _kTense = '${_kPrefix}selectedTense';
  static const _kPersons = '${_kPrefix}selectedPersons';
  static const _kShowBaseVerb = '${_kPrefix}showBaseVerb';
  static const _kShowAnswers = '${_kPrefix}showAnswers';
  static const _kFilterRegular = '${_kPrefix}filterRegular';
  static const _kFilterGroups = '${_kPrefix}filterGroups';

  static Future<void> saveState({
    String? infinitive,
    String? mood,
    String? tense,
    Iterable<String>? persons,
    bool? showBaseVerb,
    bool? showAnswers,
    bool? filterRegular,
    Iterable<String>? filterGroups,
  }) async {
    try {
      final p = await SharedPreferences.getInstance();
      if (infinitive != null) await p.setString(_kInfinitive, infinitive);
      if (mood != null) await p.setString(_kMood, mood);
      if (tense != null) await p.setString(_kTense, tense);
      if (persons != null) await p.setStringList(_kPersons, persons.toList());
      if (showBaseVerb != null) await p.setBool(_kShowBaseVerb, showBaseVerb);
      if (showAnswers != null) await p.setBool(_kShowAnswers, showAnswers);
      if (filterRegular != null) await p.setBool(_kFilterRegular, filterRegular);
      if (filterGroups != null) await p.setStringList(_kFilterGroups, filterGroups.toList());
    } catch (e) {
      // Gracefully handle platforms where shared_preferences is not available (e.g., Web without proper setup)
      // Silently ignore preference save errors
    }
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
        filterRegular: p.getBool(_kFilterRegular) ?? false,
        filterGroups: p.getStringList(_kFilterGroups) ?? const <String>[],
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
        filterRegular: false,
        filterGroups: <String>[],
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
  final bool filterRegular;
  final List<String> filterGroups;

  const QuizPrefsState({
    required this.infinitive,
    required this.mood,
    required this.tense,
    required this.persons,
    required this.showBaseVerb,
    required this.showAnswers,
    required this.filterRegular,
    required this.filterGroups,
  });
}
