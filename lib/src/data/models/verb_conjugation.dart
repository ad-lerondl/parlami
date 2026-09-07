class VerbConjugation {
  final String infinitive;
  final Map<String, String> translations;
  final int group;
  final bool regular;
  final bool pronominal;
  final String? auxiliary;
  // mood -> tense -> person -> form
  final Map<String, Map<String, Map<String, String>>> conjugations;

  const VerbConjugation({
    required this.infinitive,
    this.translations = const {},
    this.group = 0,
    this.regular = false,
    this.pronominal = false,
    this.auxiliary,
    required this.conjugations,
  });

  String? translationFor(String languageCode) => translations[languageCode];

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
    final rawTranslations = json['translations'];
    final translations = rawTranslations is Map
        ? rawTranslations.map((key, value) => MapEntry(key.toString(), value.toString()))
        : const <String, String>{};
    return VerbConjugation(
      infinitive: json['infinitive'] as String,
      translations: translations,
      group: (json['group'] as num?)?.toInt() ?? 0,
      regular: json['regular'] as bool? ?? false,
      pronominal: json['pronominal'] as bool? ?? false,
      auxiliary: json['auxiliary'] as String?,
      conjugations: conj,
    );
  }
}

bool matchesConjugationAnswer(String input, String expected) {
  final expectedForms = _splitAcceptedForms(expected);
  final enteredForms = _splitAcceptedForms(input);
  return enteredForms.isNotEmpty && enteredForms.every(expectedForms.contains);
}

Set<String> _splitAcceptedForms(String value) =>
    value.split(RegExp(r'[,/]')).map((form) => form.trim().toLowerCase()).where((form) => form.isNotEmpty).toSet();
