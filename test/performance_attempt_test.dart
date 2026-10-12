import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/data/models/performance_attempt.dart';

void main() {
  test('PerformanceAttempt round-trips conjugation context', () {
    final recordedAt = DateTime.utc(2026, 10, 12, 9, 30);
    final attempt = PerformanceAttempt(
      id: 'attempt-1',
      sessionId: 'session-1',
      skill: 'conjugation',
      exerciseType: 'verb_forms',
      itemId: 'essere',
      recordedAt: recordedAt,
      correct: false,
      metadata: {
        'mood': 'Indicativo',
        'tense': 'Presente',
        'persons': {'io': true, 'tu': false},
      },
    );

    final restored = PerformanceAttempt.fromJson(attempt.toJson());

    expect(restored.id, attempt.id);
    expect(restored.skill, 'conjugation');
    expect(restored.recordedAt, recordedAt);
    expect(restored.correct, isFalse);
    expect(restored.metadata['tense'], 'Presente');
    expect((restored.metadata['persons'] as Map)['tu'], isFalse);
  });
}
