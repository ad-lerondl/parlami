import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/data/models/performance_attempt.dart';
import 'package:parlami/src/data/models/vocab_word.dart';
import 'package:parlami/src/views/results_analytics.dart';

PerformanceAttempt attempt({
  required String id,
  required DateTime at,
  bool? correct,
  String skill = 'vocabulary',
  String exerciseType = 'answer',
  String sessionId = '',
  int? durationMs,
  int? rating,
}) {
  return PerformanceAttempt(
    id: id,
    sessionId: sessionId,
    skill: skill,
    exerciseType: exerciseType,
    itemId: 'item-$id',
    recordedAt: at,
    correct: correct,
    durationMs: durationMs,
    rating: rating,
  );
}

void main() {
  group('ResultsAnalytics.accuracy', () {
    test('excludes unevaluated answers and session markers', () {
      final result = ResultsAnalytics.accuracy([
        attempt(id: '1', at: DateTime(2026, 10, 12, 9), correct: true),
        attempt(id: '2', at: DateTime(2026, 10, 12, 9), correct: false),
        attempt(id: '3', at: DateTime(2026, 10, 12, 9), correct: null),
        attempt(
          id: '4',
          at: DateTime(2026, 10, 12, 9),
          correct: true,
          exerciseType: 'study_session',
        ),
      ]);
      expect(result, 0.5);
    });

    test('returns null when no evaluated answers exist', () {
      expect(
        ResultsAnalytics.accuracy([
          attempt(id: '1', at: DateTime(2026, 10, 12), correct: null),
        ]),
        isNull,
      );
    });
  });

  test('daily accuracy distinguishes no data from zero accuracy', () {
    final summaries = ResultsAnalytics.dailyAccuracy(
      [
        attempt(id: 'ok', at: DateTime(2026, 10, 12, 10), correct: true),
        attempt(id: 'wrong', at: DateTime(2026, 10, 12, 11), correct: false),
      ],
      days: 2,
      now: DateTime(2026, 10, 12, 18),
    );

    expect(summaries, hasLength(2));
    expect(summaries.first.accuracy, isNull);
    expect(summaries.last.accuracy, 0.5);
    expect(summaries.last.evaluated, 2);
  });

  test('study duration is not double-counted for repeated session records', () {
    final summary = ResultsAnalytics.studyDurations([
      attempt(
        id: '1',
        at: DateTime(2026, 10, 12, 10),
        skill: 'conjugation',
        exerciseType: 'study_session',
        sessionId: 'session-a',
        durationMs: 90000,
      ),
      attempt(
        id: '2',
        at: DateTime(2026, 10, 12, 10, 1),
        skill: 'conjugation',
        exerciseType: 'study_session',
        sessionId: 'session-a',
        durationMs: 90000,
      ),
    ]);

    expect(summary.totalMs, 90000);
    expect(summary.bySkillMs['conjugation'], 90000);
    expect(summary.sessionCount, 1);
  });

  test('a session attached to several skills is not split or duplicated', () {
    final summary = ResultsAnalytics.studyDurations([
      attempt(
        id: '1',
        at: DateTime(2026, 10, 12, 10),
        skill: 'conjugation',
        exerciseType: 'study_session',
        sessionId: 'session-a',
        durationMs: 120000,
      ),
      attempt(
        id: '2',
        at: DateTime(2026, 10, 12, 10),
        skill: 'vocabulary',
        exerciseType: 'study_session',
        sessionId: 'session-a',
        durationMs: 120000,
      ),
    ]);

    expect(summary.totalMs, 120000);
    expect(summary.bySkillMs['mixed'], 120000);
    expect(summary.mixedSessionCount, 1);
  });

  test('daily study time counts a session once and puts it on its latest day', () {
    final summaries = ResultsAnalytics.dailyStudyTime(
      [
        attempt(
          id: 'session-marker-1',
          at: DateTime(2026, 10, 11, 23, 30),
          skill: 'conjugation',
          exerciseType: 'study_session',
          sessionId: 'session-a',
          durationMs: 120000,
        ),
        attempt(
          id: 'session-marker-2',
          at: DateTime(2026, 10, 12, 0, 5),
          skill: 'conjugation',
          exerciseType: 'study_session',
          sessionId: 'session-a',
          durationMs: 120000,
        ),
      ],
      days: 2,
      now: DateTime(2026, 10, 12, 18),
    );

    expect(summaries, hasLength(2));
    expect(summaries.first.durationMs, 0);
    expect(summaries.last.durationMs, 120000);
    expect(summaries.last.sessions, 1);
  });

  test('vocabulary level summary includes only reviewed words', () {
    final now = DateTime(2026, 10, 12, 12);
    final reviewed = VocabWord(
      id: 'w1',
      italian: 'casa',
      french: 'maison',
      difficulty: VocabDifficulty.a1,
      categories: const [],
      partOfSpeech: VocabPartOfSpeech.noun,
      article: 'la',
      source: VocabWordSource.original,
      createdAt: now,
      updatedAt: now,
      stats: VocabReviewStats.initial().recordReview(true, now),
    );
    final unseen = VocabWord(
      id: 'w2',
      italian: 'altrove',
      french: 'ailleurs',
      difficulty: VocabDifficulty.a1,
      categories: const [],
      partOfSpeech: VocabPartOfSpeech.adverb,
      article: null,
      source: VocabWordSource.original,
      createdAt: now,
      updatedAt: now,
      stats: VocabReviewStats.initial(),
    );

    final summary = ResultsAnalytics.vocabularyByDifficulty(
      [reviewed, unseen],
      now: now,
    );
    expect(summary[VocabDifficulty.a1]!.reviewedWords, 1);
    expect(summary[VocabDifficulty.a1]!.averageMastery, 100);
    expect(summary[VocabDifficulty.a2]!.averageMastery, isNull);
  });
}
