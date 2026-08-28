class EESentence {
  final String french;
  final String italian;
  final String level;

  const EESentence({
    required this.french,
    required this.italian,
    required this.level,
  });

  factory EESentence.fromJson(Map<String, dynamic> json) => EESentence(
        french: json['fr'] as String,
        italian: json['it'] as String,
        level: json['level'] as String,
      );
}
