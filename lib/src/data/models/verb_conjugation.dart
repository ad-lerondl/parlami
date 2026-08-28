class VerbConjugation {
  final String infinitive;
  final String? translation;
  // mood -> tense -> person -> form
  final Map<String, Map<String, Map<String, String>>> conjugations;

  const VerbConjugation({
    required this.infinitive,
    this.translation,
    required this.conjugations,
  });

  factory VerbConjugation.fromJson(Map<String, dynamic> json) {
    final Map<String, Map<String, Map<String, String>>> conj = {};
    final rawConj = json['conjugations'] as Map<String, dynamic>;
    rawConj.forEach((mood, tensesMap) {
      final moodMap = <String, Map<String, String>>{};
      final tensesMapTyped = tensesMap as Map<String, dynamic>;
      tensesMapTyped.forEach((tense, persons) {
        if (persons is String) {
          // Direct string value
          moodMap[tense] = {'value': persons};
        } else if (persons is List) {
          // Array of forms (e.g., participles with gender/number variants)
          moodMap[tense] = {'value': persons.join(' / ')};
        } else if (persons is Map) {
          final personMap = persons as Map<String, dynamic>;
          // Convert all values to strings, handle arrays within person entries
          moodMap[tense] = personMap.map((k, v) {
            if (v is List) {
              return MapEntry(k, v.join(' / '));
            }
            return MapEntry(k, v.toString());
          });
        }
      });
      conj[mood] = moodMap;
    });
    return VerbConjugation(
      infinitive: json['infinitive'] as String,
      translation: json['translation'] as String?,
      conjugations: conj,
    );
  }
}
