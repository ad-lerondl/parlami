import 'package:parlami/src/data/models/verb_conjugation.dart';
import 'package:parlami/src/services/asset_loader.dart';

class ConjugationRepository {
  final List<VerbConjugation> _items = [];
  final Map<String, VerbConjugation> _byInfinitive = {};
  final Map<String, List<VerbConjugation>> _filterCache = {};

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final list = await AssetLoader.loadJsonListFast('assets/conjugaison/BDD_conjugaison.json');
    for (final m in list) {
      final v = VerbConjugation.fromJson(m);
      _items.add(v);
      _byInfinitive[v.infinitive] = v;
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

  int? groupOf(String infinitive) => _byInfinitive[infinitive]?.group;
  bool? regularityOf(String infinitive) => _byInfinitive[infinitive]?.regular;

  // Filtering and random selection for exercises
  List<VerbConjugation> filter({
    bool? regular,
    bool? pronominal,
    Set<int>? groups,
    String? auxiliary,
    Set<String>? includePersons, // restrict to verbs that have these persons
    Set<String>? excludePersons,
    Set<String>? infinitives, // pick among specific verbs
  }) {
    final sortedGroups = groups == null ? null : (List<int>.from(groups)..sort());
    final sortedIncludes = includePersons == null ? null : (List<String>.from(includePersons)..sort());
    final sortedExcludes = excludePersons == null ? null : (List<String>.from(excludePersons)..sort());
    final cacheKey = '$regular|$pronominal|$sortedGroups|$auxiliary|$infinitives|$sortedIncludes|$sortedExcludes';
    final cached = _filterCache[cacheKey];
    if (cached != null) return cached;
    Iterable<VerbConjugation> it = _items;
    if (regular != null) it = it.where((v) => v.regular == regular);
    if (pronominal != null) it = it.where((v) => v.pronominal == pronominal);
    if (groups != null && groups.isNotEmpty) {
      it = it.where((v) => groups.contains(v.group));
    }
    if (auxiliary != null) it = it.where((v) => v.auxiliary == auxiliary);
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
    final result = it.toList(growable: false);
    _filterCache[cacheKey] = result;
    return result;
  }

  List<VerbConjugation> search(String query,
      {int limit = 100, bool? regular, bool? pronominal, Set<int>? groups, String? auxiliary}) {
    final normalized = query.trim().toLowerCase();
    final source = filter(regular: regular, pronominal: pronominal, groups: groups, auxiliary: auxiliary);
    if (normalized.isEmpty) return source.take(limit).toList(growable: false);
    return source
        .where((v) {
          return v.infinitive.toLowerCase().contains(normalized) ||
              v.translations.values.any((translation) => translation.toLowerCase().contains(normalized));
        })
        .take(limit)
        .toList(growable: false);
  }

  VerbConjugation? random({
    bool? regular,
    bool? pronominal,
    Set<int>? groups,
    String? auxiliary,
    Set<String>? includePersons,
    Set<String>? excludePersons,
    Set<String>? infinitives,
  }) {
    final list = filter(
      regular: regular,
      pronominal: pronominal,
      groups: groups,
      auxiliary: auxiliary,
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
