import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/models/performance_attempt.dart';
import '../data/models/vocab_word.dart';
import 'results_analytics.dart';

/// Recent evaluated-answer accuracy. Days without evaluated answers are shown
/// as missing (—), never as 0% success.
class SuccessTrendChart extends StatefulWidget {
  const SuccessTrendChart({
    super.key,
    required this.attempts,
  });

  final List<PerformanceAttempt> attempts;

  @override
  State<SuccessTrendChart> createState() => _SuccessTrendChartState();
}

class _SuccessTrendChartState extends State<SuccessTrendChart> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final summaries = ResultsAnalytics.dailyAccuracy(
      widget.attempts,
      days: _days,
    );
    final colorScheme = Theme.of(context).colorScheme;
    final hasData = summaries.any((day) => day.evaluated > 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Évolution de la réussite', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Réponses évaluées uniquement. Une journée sans réponse reste inconnue.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('7 jours'),
                  selected: _days == 7,
                  onSelected: (_) => setState(() => _days = 7),
                ),
                ChoiceChip(
                  label: const Text('30 jours'),
                  selected: _days == 30,
                  onSelected: (_) => setState(() => _days = 30),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!hasData)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('Pas encore de réponse évaluée sur cette période.'),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = _days == 7 ? constraints.maxWidth / _days : 38.0;
                  return SizedBox(
                    height: 176,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: itemWidth * _days,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final summary in summaries)
                              SizedBox(
                                width: itemWidth,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Tooltip(
                                    message: summary.accuracy == null
                                        ? '${_dateLabel(summary.day)} : aucune réponse évaluée'
                                        : '${_dateLabel(summary.day)} : ${(summary.accuracy! * 100).round()} % · ${summary.evaluated} réponse(s)',
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          summary.accuracy == null
                                              ? '—'
                                              : '${(summary.accuracy! * 100).round()}%',
                                          style: Theme.of(context).textTheme.labelSmall,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: summary.accuracy == null
                                                ? Container(
                                                    height: 2,
                                                    width: double.infinity,
                                                    color: colorScheme.outlineVariant,
                                                  )
                                                : Container(
                                                    height: math.max(5.0, 88.0 * summary.accuracy!).toDouble(),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: colorScheme.primary,
                                                      borderRadius: const BorderRadius.vertical(
                                                        top: Radius.circular(4),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _weekdayLabel(summary.day),
                                          style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                        Text(
                                          '${summary.evaluated}',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 4),
            Text(
              'Sous chaque barre : nombre de réponses évaluées.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  static String _weekdayLabel(DateTime utcDay) {
    const labels = <String>['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];
    return labels[utcDay.weekday - 1];
  }

  static String _dateLabel(DateTime utcDay) =>
      '${utcDay.day.toString().padLeft(2, '0')}/${utcDay.month.toString().padLeft(2, '0')}';
}

/// Scatter plot of recent, timed answers. It deliberately caps the number of
/// plotted points to keep the page responsive on large histories.
class CognitiveFluidityMatrix extends StatelessWidget {
  const CognitiveFluidityMatrix({
    super.key,
    required this.attempts,
  });

  final List<PerformanceAttempt> attempts;
  static const int _maxVisiblePoints = 300;

  @override
  Widget build(BuildContext context) {
    final valid = <PerformanceAttempt>[];
    var validCount = 0;
    for (final attempt in attempts) {
      if (attempt.correct == null ||
          attempt.exerciseType.trim().toLowerCase() == 'study_session' ||
          attempt.durationMs == null ||
          attempt.durationMs! <= 0 ||
          attempt.durationMs! >= 30000) {
        continue;
      }
      validCount++;
      if (valid.length < _maxVisiblePoints) valid.add(attempt);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temps de réponse et réussite',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Chaque point représente une réponse évaluée de moins de 30 secondes.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (valid.isEmpty)
              const Text('Pas encore assez de réponses chronométrées pour afficher ce graphique.')
            else ...[
              SizedBox(
                height: 210,
                child: ScatterChart(
                  ScatterChartData(
                    scatterSpots: valid.map((attempt) {
                      final seconds = attempt.durationMs! / 1000;
                      // Tiny deterministic horizontal jitter makes repeated
                      // answers visible without random redraws.
                      final jitter = (((attempt.id.hashCode & 0x7fffffff) % 11) - 5) / 20;
                      final x = (seconds + jitter).clamp(0.0, 30.0).toDouble();
                      final isCorrect = attempt.correct == true;
                      return ScatterSpot(
                        x,
                        isCorrect ? 1 : 0,
                        radius: 4,
                        color: isCorrect
                            ? Colors.green.withValues(alpha: 0.65)
                            : Theme.of(context).colorScheme.error.withValues(alpha: 0.65),
                      );
                    }).toList(growable: false),
                    minX: 0,
                    maxX: 30,
                    minY: -0.2,
                    maxY: 1.2,
                    gridData: FlGridData(
                      show: true,
                      verticalInterval: 5,
                      horizontalInterval: 1,
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text(
                          'Temps de réponse (secondes)',
                          style: TextStyle(fontSize: 11),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}s',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) {
                              return const Text('Échec', style: TextStyle(fontSize: 10));
                            }
                            if (value == 1) {
                              return const Text('Réussite', style: TextStyle(fontSize: 10));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Affichage des ${valid.length} réponses récentes${validCount > valid.length ? ' (limité à $_maxVisiblePoints points)' : ''}.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Unique, recorded study time by local calendar day.
class StudyTimeTrendChart extends StatefulWidget {
  const StudyTimeTrendChart({super.key, required this.attempts});

  final List<PerformanceAttempt> attempts;

  @override
  State<StudyTimeTrendChart> createState() => _StudyTimeTrendChartState();
}

class _StudyTimeTrendChartState extends State<StudyTimeTrendChart> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final days = ResultsAnalytics.dailyStudyTime(widget.attempts, days: _days);
    final hasData = days.any((entry) => entry.durationMs > 0);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Temps étudié par jour', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Durées de sessions uniques enregistrées. Les jours sans session ne sont pas assimilés à une durée mesurée nulle.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(label: const Text('7 jours'), selected: _days == 7, onSelected: (_) => setState(() => _days = 7)),
                ChoiceChip(label: const Text('30 jours'), selected: _days == 30, onSelected: (_) => setState(() => _days = 30)),
              ],
            ),
            const SizedBox(height: 12),
            if (!hasData)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Aucune durée de session exploitable sur cette période.'),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = _days == 7 ? constraints.maxWidth / 7 : 38.0;
                  final maxDurationMs = days.fold<int>(0, (maximum, entry) =>
                      entry.durationMs > maximum ? entry.durationMs : maximum);
                  return SizedBox(
                    height: 176,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: itemWidth * _days,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final entry in days)
                              SizedBox(
                                width: itemWidth,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Tooltip(
                                    message: '${entry.day.day.toString().padLeft(2, '0')}/${entry.day.month.toString().padLeft(2, '0')}: '
                                        '${_formatDuration(entry.durationMs)} · ${entry.sessions} session(s)',
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          entry.durationMs == 0 ? '—' : _compactDuration(entry.durationMs),
                                          style: Theme.of(context).textTheme.labelSmall,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: entry.durationMs == 0
                                                ? Container(height: 2, width: double.infinity, color: scheme.outlineVariant)
                                                : Container(
                                                    height: math.max(5.0, 88.0 * entry.durationMs / maxDurationMs).toDouble(),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: scheme.tertiary,
                                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(_weekdayLabel(entry.day), style: Theme.of(context).textTheme.labelSmall),
                                        Text('${entry.sessions}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 4),
            Text('Sous chaque barre : nombre de sessions.', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  static String _weekdayLabel(DateTime day) {
    const labels = <String>['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];
    return labels[day.weekday - 1];
  }

  static String _compactDuration(int ms) {
    final minutes = (ms / 60000).round();
    if (minutes < 60) return '${minutes}m';
    return '${minutes ~/ 60}h${(minutes % 60).toString().padLeft(2, '0')}';
  }

  static String _formatDuration(int ms) {
    if (ms <= 0) return 'durée non mesurée';
    if (ms < 60000) return '< 1 min';
    final minutes = ms ~/ 60000;
    if (minutes < 60) return '$minutes min';
    return '${minutes ~/ 60} h ${minutes % 60} min';
  }
}

/// Shows an observed time-of-day pattern only when enough evaluated answers
/// exist in an hour. Empty/under-sampled hours are omitted, not plotted as 0%.
class ProductivityChart extends StatefulWidget {
  const ProductivityChart({super.key, required this.attempts});

  final List<PerformanceAttempt> attempts;

  @override
  State<ProductivityChart> createState() => _ProductivityChartState();
}

class _ProductivityChartState extends State<ProductivityChart> {
  static const int _minimumSamples = 5;
  int? _days = 30; // null = full history

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = _days == null ? null : today.subtract(Duration(days: _days! - 1));
    final hourCounts = List<int>.filled(24, 0);
    final hourCorrect = List<int>.filled(24, 0);
    for (final attempt in widget.attempts) {
      if (attempt.correct == null || attempt.exerciseType.trim().toLowerCase() == 'study_session') continue;
      final local = attempt.recordedAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      if (start != null && (day.isBefore(start) || day.isAfter(today))) continue;
      final hour = local.hour;
      hourCounts[hour]++;
      if (attempt.correct == true) hourCorrect[hour]++;
    }

    final eligibleHours = <int>[
      for (var hour = 0; hour < 24; hour++)
        if (hourCounts[hour] >= _minimumSamples) hour,
    ];
    int? bestHour;
    double bestRate = -1;
    for (final hour in eligibleHours) {
      final rate = hourCorrect[hour] / hourCounts[hour];
      if (rate > bestRate) {
        bestRate = rate;
        bestHour = hour;
      }
    }

    final periodLabel = _days == null ? 'tout l’historique' : 'sur $_days jours';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Réussite selon l’heure', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              bestHour == null
                  ? 'Pas assez de réponses évaluées $periodLabel pour comparer les heures.'
                  : 'Meilleur taux observé : ${bestHour.toString().padLeft(2, '0')} h (${(bestRate * 100).round()} %, n=${hourCounts[bestHour]}). C’est une tendance descriptive, pas une preuve de productivité.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(label: const Text('7 jours'), selected: _days == 7, onSelected: (_) => setState(() => _days = 7)),
                ChoiceChip(label: const Text('30 jours'), selected: _days == 30, onSelected: (_) => setState(() => _days = 30)),
                ChoiceChip(label: const Text('Tout'), selected: _days == null, onSelected: (_) => setState(() => _days = null)),
              ],
            ),
            const SizedBox(height: 14),
            if (eligibleHours.isEmpty)
              const Text('Il faut au moins 5 réponses évaluées sur une même heure pour afficher une tendance.')
            else
              SizedBox(
                height: 170,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    minY: 0,
                    maxY: 1,
                    barTouchData: BarTouchData(enabled: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final hour = value.toInt();
                            if (hour < 0 || hour > 23 || hour % 4 != 0) return const SizedBox.shrink();
                            return Text('${hour}h', style: const TextStyle(fontSize: 10));
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var hour = 0; hour < 24; hour++)
                        BarChartGroupData(
                          x: hour,
                          barRods: [
                            BarChartRodData(
                              toY: hourCounts[hour] >= _minimumSamples ? hourCorrect[hour] / hourCounts[hour] : 0,
                              color: hourCounts[hour] < _minimumSamples
                                  ? Colors.transparent
                                  : hour == bestHour
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.primaryContainer,
                              width: 7,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            Text(
              'Seules les heures avec au moins $_minimumSamples réponses sont comparées. n = nombre de réponses évaluées.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// A factual recency indicator. Time since last review is not presented as a
/// direct estimate of whether the learner has forgotten a word.
class MemoryHealthCard extends StatelessWidget {
  const MemoryHealthCard({
    super.key,
    required this.words,
  });

  final List<VocabWord> words;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    var fresh = 0;
    var recent = 0;
    var overdue = 0;
    var missingDate = 0;

    final reviewed = words.where((word) => word.stats.attempts > 0);
    for (final word in reviewed) {
      final lastReview = word.stats.lastReviewedAt;
      if (lastReview == null) {
        missingDate++;
        continue;
      }
      final todayUtc = DateTime.utc(now.year, now.month, now.day);
      final localReview = lastReview.toLocal();
      final reviewDayUtc = DateTime.utc(localReview.year, localReview.month, localReview.day);
      final days = todayUtc.difference(reviewDayUtc).inDays.clamp(0, 100000);
      if (days <= 3) {
        fresh++;
      } else if (days <= 10) {
        recent++;
      } else {
        overdue++;
      }
    }

    final datedTotal = fresh + recent + overdue;
    if (reviewed.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.history_toggle_off),
          title: Text('Récence des révisions'),
          subtitle: Text('Les données apparaîtront après les premières révisions.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Récence des révisions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Cela indique quand les mots ont été revus, pas une probabilité de les avoir oubliés.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (datedTotal > 0)
              LinearProgressIndicator(
                value: fresh / datedTotal,
                minHeight: 10,
                borderRadius: BorderRadius.circular(6),
              ),
            const SizedBox(height: 10),
            _RecencyRow(label: 'Revus dans les 3 derniers jours', count: fresh),
            _RecencyRow(label: 'Revus il y a 4 à 10 jours', count: recent),
            _RecencyRow(label: 'Revus il y a plus de 10 jours', count: overdue),
            if (missingDate > 0)
              _RecencyRow(label: 'Date de révision inconnue', count: missingDate),
            Text(
              '$datedTotal mot(s) avec une date de révision exploitable.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecencyRow extends StatelessWidget {
  const _RecencyRow({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 12),
            Text('$count', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
