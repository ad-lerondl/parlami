import '../data/models/performance_attempt.dart';
import '../data/models/vocab_word.dart';

/// Pure calculations shared by the results dashboard.
///
/// Accuracy is nullable: null means "not evaluated / no data", while 0 means
/// that evaluated answers exist and none were correct.
class ResultsAnalytics {
  const ResultsAnalytics._();

  static double? accuracy(Iterable<PerformanceAttempt> attempts) {
    var evaluated = 0;
    var correct = 0;
    for (final attempt in attempts) {
      final result = attempt.correct;
      if (result == null || attempt.exerciseType.trim().toLowerCase() == 'study_session') continue;
      evaluated++;
      if (result) correct++;
    }
    if (evaluated == 0) return null;
    return correct / evaluated;
  }

  /// Mean self-rating in [0, 3], normalised to [0, 1]. Missing ratings are
  /// excluded instead of being silently counted as zero.
  static double? meanRatingNormalised(Iterable<PerformanceAttempt> attempts) {
    var count = 0;
    var sum = 0;
    for (final attempt in attempts) {
      final rating = attempt.rating;
      if (rating == null || rating < 0 || rating > 3 || attempt.exerciseType.trim().toLowerCase() == 'study_session') continue;
      count++;
      sum += rating;
    }
    if (count == 0) return null;
    return sum / (count * 3);
  }

  /// Returns [days] calendar-day buckets, oldest first. `accuracy == null`
  /// indicates that no evaluated answers were recorded on that day.
  static List<DailyPerformanceSummary> dailyAccuracy(
    Iterable<PerformanceAttempt> attempts, {
    required int days,
    DateTime? now,
  }) {
    if (days <= 0) return const [];
    final current = now ?? DateTime.now();
    final today = _utcDay(current);
    final start = today.subtract(Duration(days: days - 1));
    final buckets = <DateTime, _MutableDailySummary>{};

    for (final attempt in attempts) {
      if (attempt.correct == null || attempt.exerciseType.trim().toLowerCase() == 'study_session') continue;
      final day = _utcDay(attempt.recordedAt.toLocal());
      if (day.isBefore(start) || day.isAfter(today)) continue;
      final bucket = buckets.putIfAbsent(day, _MutableDailySummary.new);
      bucket.evaluated++;
      if (attempt.correct == true) bucket.correct++;
    }

    return List<DailyPerformanceSummary>.generate(days, (index) {
      final date = start.add(Duration(days: index));
      final bucket = buckets[date];
      return DailyPerformanceSummary(
        day: date,
        evaluated: bucket?.evaluated ?? 0,
        correct: bucket?.correct ?? 0,
      );
    }, growable: false);
  }

  /// Daily unique study time, oldest first. A session ID is counted once and
  /// assigned to the calendar day of its latest recorded session event.
  static List<DailyStudyTimeSummary> dailyStudyTime(
    Iterable<PerformanceAttempt> attempts, {
    required int days,
    DateTime? now,
  }) {
    if (days <= 0) return const [];
    final current = now ?? DateTime.now();
    final today = _utcDay(current);
    final start = today.subtract(Duration(days: days - 1));
    final sessions = <String, _MutableSessionDuration>{};

    for (final attempt in attempts) {
      if (attempt.exerciseType.trim().toLowerCase() != 'study_session') continue;
      final duration = attempt.durationMs;
      if (duration == null || duration <= 0) continue;
      final sessionKey = attempt.sessionId.trim().isEmpty
          ? 'attempt:${attempt.id}'
          : 'session:${attempt.sessionId}';
      final session = sessions.putIfAbsent(sessionKey, _MutableSessionDuration.new);
      if (duration > session.durationMs) session.durationMs = duration;
      final localRecordedAt = attempt.recordedAt.toLocal();
      if (session.lastRecordedAt == null || localRecordedAt.isAfter(session.lastRecordedAt!)) {
        session.lastRecordedAt = localRecordedAt;
      }
    }

    final dailyMs = <DateTime, int>{};
    final dailySessions = <DateTime, int>{};
    for (final session in sessions.values) {
      final lastRecordedAt = session.lastRecordedAt;
      if (lastRecordedAt == null) continue;
      final day = _utcDay(lastRecordedAt);
      if (day.isBefore(start) || day.isAfter(today)) continue;
      dailyMs.update(day, (value) => value + session.durationMs,
          ifAbsent: () => session.durationMs);
      dailySessions.update(day, (value) => value + 1, ifAbsent: () => 1);
    }

    return List<DailyStudyTimeSummary>.generate(days, (index) {
      final day = start.add(Duration(days: index));
      return DailyStudyTimeSummary(
        day: day,
        durationMs: dailyMs[day] ?? 0,
        sessions: dailySessions[day] ?? 0,
      );
    }, growable: false);
  }

  /// Counts study-session durations without adding repeated copies of the same
  /// session duration. A duration repeated across different skills is assigned
  /// to `mixed`, rather than duplicated across those skills.
  static StudyDurationSummary studyDurations(
    Iterable<PerformanceAttempt> attempts,
  ) {
    final sessions = <String, _MutableSessionDuration>{};
    for (final attempt in attempts) {
      if (attempt.exerciseType.trim().toLowerCase() != 'study_session') continue;
      final duration = attempt.durationMs;
      if (duration == null || duration <= 0) continue;
      final sessionKey = attempt.sessionId.trim().isEmpty
          ? 'attempt:${attempt.id}'
          : 'session:${attempt.sessionId}';
      final session = sessions.putIfAbsent(sessionKey, _MutableSessionDuration.new);
      if (duration > session.durationMs) session.durationMs = duration;
      if (attempt.skill.trim().isNotEmpty) session.skills.add(attempt.skill);
    }

    final bySkill = <String, int>{};
    var total = 0;
    var mixedSessions = 0;
    for (final session in sessions.values) {
      total += session.durationMs;
      final skill = session.skills.length == 1 ? session.skills.first : 'mixed';
      if (skill == 'mixed') mixedSessions++;
      bySkill.update(skill, (value) => value + session.durationMs,
          ifAbsent: () => session.durationMs);
    }
    return StudyDurationSummary(
      totalMs: total,
      bySkillMs: Map.unmodifiable(bySkill),
      sessionCount: sessions.length,
      mixedSessionCount: mixedSessions,
    );
  }

  static Map<VocabDifficulty, VocabularyLevelSummary> vocabularyByDifficulty(
    Iterable<VocabWord> words, {
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final sums = <VocabDifficulty, _MutableVocabularyLevel>{};
    for (final word in words) {
      if (word.stats.attempts <= 0) continue;
      final entry = sums.putIfAbsent(word.difficulty, _MutableVocabularyLevel.new);
      entry.count++;
      entry.masterySum += word.masteryScore(reference);
    }

    return Map.unmodifiable({
      for (final difficulty in VocabDifficulty.values)
        difficulty: VocabularyLevelSummary(
          reviewedWords: sums[difficulty]?.count ?? 0,
          averageMastery: sums[difficulty] == null
              ? null
              : sums[difficulty]!.masterySum / sums[difficulty]!.count,
        ),
    });
  }

  static DateTime _utcDay(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);
}

class DailyPerformanceSummary {
  const DailyPerformanceSummary({
    required this.day,
    required this.evaluated,
    required this.correct,
  });

  /// Stored at UTC midnight to make calendar-day arithmetic DST-safe.
  final DateTime day;
  final int evaluated;
  final int correct;

  double? get accuracy => evaluated == 0 ? null : correct / evaluated;
}

class DailyStudyTimeSummary {
  const DailyStudyTimeSummary({
    required this.day,
    required this.durationMs,
    required this.sessions,
  });

  final DateTime day;
  final int durationMs;
  final int sessions;
}

class StudyDurationSummary {
  const StudyDurationSummary({
    required this.totalMs,
    required this.bySkillMs,
    required this.sessionCount,
    required this.mixedSessionCount,
  });

  final int totalMs;
  final Map<String, int> bySkillMs;
  final int sessionCount;
  final int mixedSessionCount;
}

class VocabularyLevelSummary {
  const VocabularyLevelSummary({
    required this.reviewedWords,
    required this.averageMastery,
  });

  final int reviewedWords;
  final double? averageMastery;
}

class _MutableDailySummary {
  int evaluated = 0;
  int correct = 0;
}

class _MutableSessionDuration {
  int durationMs = 0;
  DateTime? lastRecordedAt;
  final Set<String> skills = <String>{};
}

class _MutableVocabularyLevel {
  int count = 0;
  double masterySum = 0;
}
