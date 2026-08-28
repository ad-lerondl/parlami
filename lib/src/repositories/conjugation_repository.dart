import 'package:parlami/src/data/models/verb_conjugation.dart';
import 'package:parlami/src/services/asset_loader.dart';

class ConjugationRepository {
  final List<VerbConjugation> _items = [];
  final Map<String, VerbConjugation> _byInfinitive = {};
  final Map<String, String> _groupByInfinitive = {}; // are/ere/ire
  final Map<String, String> _regularityByInfinitive = {}; // regular/irregular

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final files = [
      'assets/conjugaison/strict-regular_are.json',
      'assets/conjugaison/strict-regular_ere.json',
      'assets/conjugaison/strict-regular_ire.json',
      'assets/conjugaison/semi-regular_are.json',
      'assets/conjugaison/semi-regular_ere.json',
      'assets/conjugaison/semi-regular_ire.json',
      'assets/conjugaison/irregular_are.json',
      'assets/conjugaison/irregular_ere.json',
      'assets/conjugaison/irregular_ire.json',
      'assets/conjugaison/irregular-particips_ere.json',
    ];
    for (final path in files) {
      final list = await AssetLoader.loadJsonListFast(path);
      for (final m in list) {
        final v = VerbConjugation.fromJson(m);
        _items.add(v);
        _byInfinitive[v.infinitive] = v;
        _groupByInfinitive[v.infinitive] = _inferGroup(v.infinitive);
        // Classify regularity based on filename
        if (path.contains('strict-regular')) {
          _regularityByInfinitive[v.infinitive] = 'regular';
        } else if (path.contains('semi-regular') || path.contains('irregular-particips')) {
          _regularityByInfinitive[v.infinitive] = 'semi-regular';
        } else {
          _regularityByInfinitive[v.infinitive] = 'irregular';
        }
      }
    }
    _initialized = true;
  }

  List<VerbConjugation> all() => List.unmodifiable(_items);

  VerbConjugation? byInfinitive(String infinitive) => _byInfinitive[infinitive];

  Iterable<String> moods(String infinitive) => byInfinitive(infinitive)?.conjugations.keys ?? const Iterable.empty();

  Iterable<String> tenses(String infinitive, String mood) =>
      byInfinitive(infinitive)?.conjugations[mood]?.keys ?? const Iterable.empty();

  Map<String, String>? forms(String infinitive, String mood, String tense) {
    final v = byInfinitive(infinitive);
    if (v == null) return null;
    return v.conjugations[mood]?[tense];
  }

  // Derived metadata
  String? groupOf(String infinitive) => _groupByInfinitive[infinitive];
  String? regularityOf(String infinitive) => _regularityByInfinitive[infinitive];

  static String _inferGroup(String infinitive) {
    if (infinitive.endsWith('are')) return 'are';
    if (infinitive.endsWith('ere')) return 'ere';
    if (infinitive.endsWith('ire')) return 'ire';
    return 'other';
  }

  // Filtering and random selection for exercises
  List<VerbConjugation> filter({
    String? regularity, // 'regular' | 'irregular'
    Set<String>? groups, // e.g., {'are','ere','ire'}
    Set<String>? includePersons, // restrict to verbs that have these persons
    Set<String>? excludePersons,
    Set<String>? infinitives, // pick among specific verbs
  }) {
    Iterable<VerbConjugation> it = _items;
    if (regularity != null) {
      it = it.where((v) => _regularityByInfinitive[v.infinitive] == regularity);
    }
    if (groups != null && groups.isNotEmpty) {
      it = it.where((v) => groups.contains(_groupByInfinitive[v.infinitive]));
    }
    if (infinitives != null && infinitives.isNotEmpty) {
      final set = infinitives;
      it = it.where((v) => set.contains(v.infinitive));
    }
    if ((includePersons != null && includePersons.isNotEmpty) ||
        (excludePersons != null && excludePersons.isNotEmpty)) {
      it = it.where((v) {
        final persons = <String>{};
        for (final mood in v.conjugations.keys) {
          final tenses = v.conjugations[mood] ?? const <String, Map<String, String>>{};
          for (final tense in tenses.keys) {
            final forms = tenses[tense] ?? const <String, String>{};
            persons.addAll(forms.keys);
          }
        }
        if (includePersons != null && includePersons.isNotEmpty) {
          if (!persons.any((p) => includePersons.contains(p))) return false;
        }
        if (excludePersons != null && excludePersons.isNotEmpty) {
          if (persons.any((p) => excludePersons.contains(p))) return false;
        }
        return true;
      });
    }
    return it.toList(growable: false);
  }

  VerbConjugation? random({
    String? regularity,
    Set<String>? groups,
    Set<String>? includePersons,
    Set<String>? excludePersons,
    Set<String>? infinitives,
  }) {
    final list = filter(
      regularity: regularity,
      groups: groups,
      includePersons: includePersons,
      excludePersons: excludePersons,
      infinitives: infinitives,
    );
    if (list.isEmpty) return null;
    final ts = DateTime.now().microsecondsSinceEpoch;
    final idx = ts % list.length;
    return list[idx];
  }
}
