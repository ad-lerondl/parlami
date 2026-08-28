class EOQuestion {
  final String id;
  final String prompt;
  final String level; // A1, A2, B1, etc.
  final String? expectedAnswer;
  final List<String> followUps; // IDs des questions suivantes
  final String? tip;
  final String? topic;
  final bool startable;

  const EOQuestion({
    required this.id,
    required this.prompt,
    required this.level,
    this.expectedAnswer,
    this.followUps = const [],
    this.tip,
    this.topic,
    this.startable = true,
  });

  factory EOQuestion.fromJson(Map<String, dynamic> json) {
    final prompt = json['prompt'] as String?;
    final level = json['level'] as String?;
    if (prompt == null || level == null) {
      throw ArgumentError('Invalid EOQuestion json: missing prompt or level');
    }

    String id = json['id'] as String? ?? '';
    if (id.isEmpty) {
      // Fallback: generate a lightweight id from prompt and level to avoid null crashes
      final slug = prompt.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'_+'), '_').trim();
      id = 'auto_${level}_$slug';
    }

    return EOQuestion(
      id: id,
      prompt: prompt,
      level: level,
      expectedAnswer: json['expectedAnswer'] as String?,
      followUps: (json['followUps'] as List<dynamic>? ?? const []).map((e) => e as String).toList(growable: false),
      tip: json['tip'] as String?,
      topic: json['topic'] as String?,
      startable: json['startable'] as bool? ?? true,
    );
  }
}
