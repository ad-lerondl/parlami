class PerformanceAttempt {
  const PerformanceAttempt({
    required this.id,
    required this.sessionId,
    required this.skill,
    required this.exerciseType,
    required this.itemId,
    required this.recordedAt,
    this.correct,
    this.rating,
    this.durationMs,
    this.metadata = const {},
  });

  final String id;
  final String sessionId;
  final String skill;
  final String exerciseType;
  final String itemId;
  final DateTime recordedAt;
  final bool? correct;
  final int? rating;
  final int? durationMs;
  final Map<String, dynamic> metadata;

  factory PerformanceAttempt.fromJson(Map<String, dynamic> json, {String? idFallback}) {
    return PerformanceAttempt(
      id: (json['id']?.toString().trim().isNotEmpty ?? false) ? json['id'].toString() : (idFallback ?? ''),
      sessionId: json['sessionId']?.toString() ?? '',
      skill: json['skill']?.toString() ?? 'unknown',
      exerciseType: json['exerciseType']?.toString() ?? 'unknown',
      itemId: json['itemId']?.toString() ?? '',
      recordedAt: DateTime.tryParse(json['recordedAt']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      correct: json['correct'] as bool?,
      rating: (json['rating'] as num?)?.toInt(),
      durationMs: (json['durationMs'] as num?)?.toInt(),
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : const <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionId': sessionId,
        'skill': skill,
        'exerciseType': exerciseType,
        'itemId': itemId,
        'recordedAt': recordedAt.toIso8601String(),
        'correct': correct,
        'rating': rating,
        'durationMs': durationMs,
        'metadata': metadata,
      };
}
