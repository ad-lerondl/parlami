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
    this.metadata = const <String, dynamic>{},
  });

  final String id;
  final String sessionId;
  final String skill;
  final String exerciseType;
  final String itemId;
  final DateTime recordedAt;

  /// null means that no evaluable result was recorded; it must not be counted
  /// as an incorrect answer by dashboard statistics.
  final bool? correct;

  /// Optional oral self-rating on the app's 0–3 scale.
  final int? rating;

  /// Duration in milliseconds. Its contract should be consistent per event
  /// type: per-answer duration for answers, total duration for study_session.
  final int? durationMs;
  final Map<String, dynamic> metadata;

  factory PerformanceAttempt.fromJson(
    Map<String, dynamic> json, {
    String? idFallback,
  }) {
    final rawId = json['id']?.toString().trim();
    final rawMetadata = json['metadata'];
    final metadata = rawMetadata is Map
        ? <String, dynamic>{
            for (final entry in rawMetadata.entries)
              entry.key.toString(): entry.value,
          }
        : const <String, dynamic>{};

    return PerformanceAttempt(
      id: rawId != null && rawId.isNotEmpty ? rawId : (idFallback ?? ''),
      sessionId: json['sessionId']?.toString() ?? '',
      skill: json['skill']?.toString() ?? 'unknown',
      exerciseType: json['exerciseType']?.toString() ?? 'unknown',
      itemId: json['itemId']?.toString() ?? '',
      recordedAt: DateTime.tryParse(json['recordedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      correct: _parseBool(json['correct']),
      rating: _parseInt(json['rating']),
      durationMs: _parseInt(json['durationMs']),
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
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

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value == 1 || value == '1') return true;
    if (value == 0 || value == '0') return false;
    if (value is String) {
      switch (value.trim().toLowerCase()) {
        case 'true':
          return true;
        case 'false':
          return false;
      }
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }
}
