class GrammarQuestion {
  final String id;
  final String topic;
  final String level;
  final String prompt;
  final String sentence;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  const GrammarQuestion({
    required this.id,
    required this.topic,
    required this.level,
    required this.prompt,
    required this.sentence,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  factory GrammarQuestion.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List<dynamic>? ?? const [])
        .map((option) => option.toString())
        .toList(growable: false);
    return GrammarQuestion(
      id: json['id']?.toString() ?? '',
      topic: json['topic']?.toString() ?? 'general',
      level: json['level']?.toString() ?? 'A1',
      prompt: json['prompt']?.toString() ?? '',
      sentence: json['sentence']?.toString() ?? '',
      options: options,
      answerIndex: (json['answerIndex'] as num?)?.toInt() ?? 0,
      explanation: json['explanation']?.toString() ?? '',
    );
  }

  bool isAnswerCorrect(int selectedIndex) => selectedIndex == answerIndex;
}
