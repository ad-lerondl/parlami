
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

import '../data/models/vocab_word.dart';
import '../data/models/performance_attempt.dart';
import '../localization/app_localizations.dart';
import '../repositories/performance_repository.dart';
import '../repositories/vocab_repository.dart';
import 'dashboard_charts.dart';
import 'results_analytics.dart';

// ============================================================================
// 1. PRÉPARATION DES DONNÉES
// ============================================================================
// Les vues filtrées sont préparées en un seul passage, sans recopier tout
// l’historique dans un isolate uniquement pour effectuer des filtres.
_ResultsData _processResultsData(
  List<VocabWord> words,
  List<PerformanceAttempt> attempts,
) {
  final reviewedWords = <VocabWord>[];
  final conjugationAttempts = <PerformanceAttempt>[];
  final eeAttempts = <PerformanceAttempt>[];
  final eoAttempts = <PerformanceAttempt>[];
  final numdateAttempts = <PerformanceAttempt>[];

  // Single pass per collection. Calling compute() here previously copied the
  // complete object graph into an isolate and copied all words/attempts back,
  // only to perform several linear filters.
  for (final word in words) {
    if (word.stats.attempts > 0) reviewedWords.add(word);
  }
  for (final attempt in attempts) {
    switch (attempt.skill) {
      case 'conjugation':
        conjugationAttempts.add(attempt);
        break;
      case 'ee':
        eeAttempts.add(attempt);
        break;
      case 'eo':
        eoAttempts.add(attempt);
        break;
      case 'numdate':
        numdateAttempts.add(attempt);
        break;
    }
  }

  return _ResultsData(
    words: words,
    attempts: attempts,
    reviewedWords: reviewedWords,
    conjugationAttempts: conjugationAttempts,
    eeAttempts: eeAttempts,
    eoAttempts: eoAttempts,
    numdateAttempts: numdateAttempts,
    studyDurationSummary: ResultsAnalytics.studyDurations(attempts),
  );
}

class _ResultsData {
  const _ResultsData({
    required this.words,
    required this.attempts,
    required this.reviewedWords,
    required this.conjugationAttempts,
    required this.eeAttempts,
    required this.eoAttempts,
    required this.numdateAttempts,
    required this.studyDurationSummary,
  });

  final List<VocabWord> words;
  final List<PerformanceAttempt> attempts;
  final List<VocabWord> reviewedWords;
  final List<PerformanceAttempt> conjugationAttempts;
  final List<PerformanceAttempt> eeAttempts;
  final List<PerformanceAttempt> eoAttempts;
  final List<PerformanceAttempt> numdateAttempts;
  final StudyDurationSummary studyDurationSummary;
}

// ============================================================================
// 2. VUE PRINCIPALE (DASHBOARD)
// ============================================================================
class ResultsView extends StatefulWidget {
  const ResultsView({super.key, this.onStartSession});

  final VoidCallback? onStartSession;

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  final VocabRepository _repository = VocabRepository();
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  late Future<_ResultsData> _resultsFuture;

  static Future<_ResultsData>? _cachedResultsFuture;
  static int? _cachedPerformanceRevision;
  static int? _cachedVocabRevision;

  @override
  void initState() {
    super.initState();
    _resultsFuture = _cachedResultsFuture != null &&
            _cachedPerformanceRevision == _performanceRepository.revision &&
            _cachedVocabRevision == _repository.revision
        ? _cachedResultsFuture!
        : _loadAndCacheResults();
  }

  Future<_ResultsData> _loadResults() async {
    final total = Stopwatch()..start();
    // These repositories share the same Sembast database. Initialise in a
    // deterministic order; do not race two open/bootstrap operations here.
    final vocabTimer = Stopwatch()..start();
    await _repository.init();
    final vocabMs = vocabTimer.elapsedMilliseconds;

    final performanceTimer = Stopwatch()..start();
    await _performanceRepository.init();
    final performanceMs = performanceTimer.elapsedMilliseconds;

    final words = _repository.all();
    final attempts = _performanceRepository.all();
    final processingTimer = Stopwatch()..start();
    final data = _processResultsData(words, attempts);
    if (kDebugMode) {
      debugPrint('[Results] vocab init: ${vocabMs}ms; performance init: ${performanceMs}ms; '
          'partition: ${processingTimer.elapsedMilliseconds}ms; '
          'words=${words.length}; attempts=${attempts.length}; total=${total.elapsedMilliseconds}ms');
    }
    return data;
  }

  Future<_ResultsData> _loadAndCacheResults() async {
    final data = await _loadResults();
    _cachedResultsFuture = Future.value(data);
    _cachedPerformanceRevision = _performanceRepository.revision;
    _cachedVocabRevision = _repository.revision;
    return data;
  }

  Future<void> _refresh() async {
    final future = _loadAndCacheResults();
    setState(() => _resultsFuture = future);
    // FutureBuilder renders the error state; avoid an unhandled refresh error.
    try {
      await future;
    } catch (_) {
      // Intentionally handled by the FutureBuilder attached to _resultsFuture.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.vocabMastery, style: const TextStyle(fontWeight: FontWeight.w800)),
          bottom: const TabBar(
            indicatorWeight: 4,
            tabs: [
              Tab(icon: Icon(Icons.local_fire_department_rounded), text: "Aujourd'hui"),
              Tab(icon: Icon(Icons.insert_chart_rounded), text: 'Progression'),
              Tab(icon: Icon(Icons.psychology_rounded), text: 'Compétences'),
            ],
          ),
        ),
        body: FutureBuilder<_ResultsData>(
          future: _resultsFuture,
          builder: (context, snapshot) {
            // Keep the existing content visible during a refresh.
            if (snapshot.hasData) return _buildTabs(snapshot.data!);
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      const Text('Impossible de charger tes résultats.'),
                      TextButton(
                        onPressed: _refresh,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildTabs(_ResultsData data) {
    return TabBarView(
      children: [
        RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _TodayActionTab(
                words: data.words,
                attempts: data.attempts,
                onStartSession: widget.onStartSession,
              ),
            ],
          ),
        ),
        RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SuccessTrendChart(attempts: data.attempts),
              const SizedBox(height: 12),
              _ActivityHeatmap(attempts: data.attempts),
              const SizedBox(height: 12),
              StudyTimeTrendChart(attempts: data.attempts),
              const SizedBox(height: 12),
              _DetailsSection(
                title: 'Analyses avancées',
                icon: Icons.query_stats_outlined,
                children: [
                  ProductivityChart(attempts: data.attempts),
                  CognitiveFluidityMatrix(attempts: data.attempts),
                  MemoryHealthCard(words: data.words),
                  _StudyTimeCard(summary: data.studyDurationSummary),
                ],
              ),
            ],
          ),
        ),
        RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _OverviewCard(reviewed: data.reviewedWords),
              const SizedBox(height: 16),
              _FocusMetricTile(
                attempts: data.attempts,
                studyDurationSummary: data.studyDurationSummary,
              ),
              const SizedBox(height: 16),
              _ConjugationResultsCard(
                attempts: data.conjugationAttempts,
                onStartSession: widget.onStartSession,
              ),
              const SizedBox(height: 16),
              _DetailsSection(
                title: 'Autres compétences',
                icon: Icons.extension_outlined,
                children: [
                  _NumDateResultsCard(attempts: data.numdateAttempts),
                  _TrainingResultsCard(
                    skill: 'eo',
                    title: 'Expression orale',
                    icon: Icons.record_voice_over_outlined,
                    attempts: data.eoAttempts,
                  ),
                  _TrainingResultsCard(
                    skill: 'ee',
                    title: 'Expression écrite',
                    icon: Icons.edit_note_outlined,
                    attempts: data.eeAttempts,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DetailsSection(
                title: 'Détails du vocabulaire',
                icon: Icons.tune_outlined,
                children: [
                  const _SectionTitle(title: 'Maîtrise par niveau', icon: Icons.bar_chart_rounded),
                  _VocabularyLevelBars(words: data.words),
                  const SizedBox(height: 12),
                  const _SectionTitle(title: 'Priorités de révision', icon: Icons.flag_outlined),
                  if (data.reviewedWords.isEmpty)
                    _EmptyResults(onStartSession: widget.onStartSession)
                  else
                    _RecentPriorities(words: data.reviewedWords),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 3. WIDGETS PRIVÉS DE L'UI (Anciens et Nouveaux)
// ============================================================================

class _TodayActionTab extends StatelessWidget {
  const _TodayActionTab({required this.words, required this.attempts, this.onStartSession});

  final List<VocabWord> words;
  final List<PerformanceAttempt> attempts;
  final VoidCallback? onStartSession;

  static String _dayKey(DateTime date) {
    final local = date.toLocal();
    return '${local.year}-${local.month}-${local.day}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final activeDays = <String>{
      ...attempts.map((attempt) => _dayKey(attempt.recordedAt.toLocal())),
      ...words.map((word) => word.stats.lastReviewedAt).whereType<DateTime>().map((date) => _dayKey(date.toLocal())),
    };

    final todayKey = _dayKey(now);
    final todayActive = activeDays.contains(todayKey);

    var streak = 0;
    var cursor = DateTime(now.year, now.month, now.day);
    if (!todayActive) cursor = cursor.subtract(const Duration(days: 1));
    while (activeDays.contains(_dayKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    final todayAttempts = attempts.where((attempt) {
      final local = attempt.recordedAt.toLocal();
      return local.year == now.year && local.month == now.month && local.day == now.day;
    }).toList(growable: false);

    final activeMs = ResultsAnalytics.studyDurations(todayAttempts).totalMs;
    final hasTimeTracking = attempts.any((attempt) =>
        attempt.exerciseType.trim().toLowerCase() == 'study_session' && (attempt.durationMs ?? 0) > 0);
    final double dailyGoalProgress = (activeMs / 120000.0).clamp(0.0, 1.0).toDouble();
    final bool goalReached = dailyGoalProgress >= 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Icon(
                  streak > 0 ? Icons.local_fire_department : Icons.local_fire_department_outlined,
                  size: 64,
                  color: streak > 0 ? Colors.orange : Theme.of(context).colorScheme.onPrimaryContainer
                ),
                Text(
                  streak == 0 ? "Commence ta série" : "$streak Jours consécutifs",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  streak == 0 ? "2 minutes suffisent pour aujourd'hui." : "Ne brise pas ton élan !",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (hasTimeTracking)
          Center(
            child: SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: dailyGoalProgress,
                    strokeWidth: 16,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: goalReached ? Colors.green : Theme.of(context).colorScheme.primary,
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${(dailyGoalProgress * 100).round()}%",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          goalReached ? 'Objectif atteint !' : 'Objectif : 2 min',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer_off_outlined),
              title: const Text('Temps d’étude non mesuré'),
              subtitle: const Text('Le temps restera indisponible tant que les séances ne seront pas enregistrées avec une durée.'),
            ),
          ),
        const SizedBox(height: 32),
        if (onStartSession != null)
          FilledButton.icon(
            onPressed: onStartSession,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: goalReached ? Colors.blueGrey : Theme.of(context).colorScheme.primary,
            ),
            icon: Icon(goalReached ? Icons.fitness_center : Icons.play_arrow_rounded),
            label: Text(
              goalReached ? 'S\'entraîner encore' : 'Échauffement rapide (2 min)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.title, required this.icon, required this.children});
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          leading: Icon(icon),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          children: children,
        ),
      );
}

class _FocusMetricTile extends StatefulWidget {
  const _FocusMetricTile({
    required this.attempts,
    required this.studyDurationSummary,
  });
  final List<PerformanceAttempt> attempts;
  final StudyDurationSummary studyDurationSummary;

  @override
  State<_FocusMetricTile> createState() => _FocusMetricTileState();
}

class _FocusMetricTileState extends State<_FocusMetricTile> {
  String _selectedSkill = 'conjugation';

  static const _labels = {
    'vocabulary': 'Vocabulaire',
    'conjugation': 'Conjugaison',
    'numdate': 'Nombres & dates',
    'eo': 'Expression orale',
    'ee': 'Expression écrite',
  };

  @override
  Widget build(BuildContext context) {
    final available = widget.attempts.map((attempt) => attempt.skill).toSet().toList()..sort();
    if (available.isEmpty) available.add('conjugation');
    if (!available.contains(_selectedSkill)) _selectedSkill = available.first;
    final selected = widget.attempts.where((attempt) => attempt.skill == _selectedSkill).toList();
    final answers = selected.where((attempt) => attempt.correct != null && attempt.exerciseType.trim().toLowerCase() != 'study_session').toList(growable: false);
    final correct = answers.where((attempt) => attempt.correct == true).length;
    final duration = widget.studyDurationSummary.bySkillMs[_selectedSkill] ?? 0;
    final durationLabel = duration > 0 ? _formatDuration(duration) : '—';
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_alt_outlined, size: 20),
                const SizedBox(width: 8),
                const Expanded(child: Text('Mon focus', style: TextStyle(fontWeight: FontWeight.bold))),
                DropdownButton<String>(
                  value: _selectedSkill,
                  underline: const SizedBox.shrink(),
                  items: available
                      .map((skill) => DropdownMenuItem(value: skill, child: Text(_labels[skill] ?? skill)))
                      .toList(),
                  onChanged: (skill) => setState(() => _selectedSkill = skill ?? _selectedSkill),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Metric(
                    value: answers.isEmpty ? '—' : '${(correct / answers.length * 100).round()} %',
                    label: 'réussite'),
                _Metric(value: '${answers.length}', label: 'réponses'),
                _Metric(value: durationLabel, label: 'temps actif'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(int milliseconds) {
    if (milliseconds <= 0) return '0 min';
    if (milliseconds < 60000) return '< 1 min';
    final minutes = (milliseconds / 60000).floor();
    return '$minutes min';
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.reviewed});
  final List<VocabWord> reviewed;

  @override
  Widget build(BuildContext context) {
    final attempts = reviewed.fold<int>(0, (sum, word) => sum + word.stats.attempts);
    final correct = reviewed.fold<int>(0, (sum, word) => sum + word.stats.correctAttempts);
    final now = DateTime.now();
    final mastery = reviewed.isEmpty
        ? 0.0
        : reviewed.map((word) => word.masteryScore(now)).reduce((a, b) => a + b) / reviewed.length;
    final rate = attempts == 0 ? null : correct / attempts;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ScoreRing(value: mastery / 100, label: reviewed.isEmpty ? '—' : '${mastery.round()}'),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Niveau vocabulaire', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(reviewed.isEmpty
                          ? 'Commence une première révision.'
                          : 'Ta mémoire progresse à chaque rappel.'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Metric(value: '${reviewed.length}', label: 'mots revus'),
                _Metric(value: '$attempts', label: 'réponses'),
                _Metric(value: rate == null ? '—' : '${(rate * 100).round()} %', label: 'réussite'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConjugationResultsCard extends StatelessWidget {
  const _ConjugationResultsCard({required this.attempts, this.onStartSession});
  final List<PerformanceAttempt> attempts;
  final VoidCallback? onStartSession;

  @override
  Widget build(BuildContext context) {
    final evaluated = attempts.where((attempt) => attempt.correct != null && attempt.exerciseType.trim().toLowerCase() != 'study_session').toList(growable: false);
    final correct = evaluated.where((attempt) => attempt.correct == true).length;
    final accuracy = evaluated.isEmpty ? null : correct / evaluated.length;
    final tenseStats = <String, List<int>>{};
    final personStats = <String, List<int>>{};

    for (final attempt in evaluated) {
      final mood = attempt.metadata['mood']?.toString() ?? 'Mode inconnu';
      final tense = attempt.metadata['tense']?.toString() ?? 'Temps inconnu';
      _addScore(tenseStats, '$mood · $tense', attempt.correct == true);
      final persons = attempt.metadata['persons'];
      if (persons is Map) {
        for (final entry in persons.entries) {
          final value = _readBool(entry.value);
          if (value != null) _addScore(personStats, entry.key.toString(), value);
        }
      }
    }

    final weakestTenses = _weakest(tenseStats);
    final weakestPersons = _weakest(personStats);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_graph_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Conjugaison',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                if (accuracy != null) Text('${(accuracy * 100).round()} %'),
              ],
            ),
            const SizedBox(height: 10),
            if (evaluated.isEmpty) ...[
              const Text('Aucune réponse évaluée pour le moment.'),
              if (attempts.isNotEmpty)
                Text('${attempts.length} tentative(s) enregistrée(s), sans résultat exploitable.'),
              if (onStartSession != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: onStartSession,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('S’entraîner maintenant'),
                  ),
                ),
            ] else ...[
              LinearProgressIndicator(value: accuracy, minHeight: 8),
              const SizedBox(height: 8),
              Text('$correct bonne(s) réponse(s) sur ${evaluated.length} réponse(s) évaluée(s).'),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text('Explorer les points à renforcer'),
                children: [
                  _ConjugationMatrix(attempts: evaluated),
                  _ConjugationTenseBars(scores: tenseStats),
                  _ConjugationPersonBars(scores: personStats),
                  if (weakestTenses.isNotEmpty)
                    _StatLine(label: 'Temps à reprendre (au moins 3 réponses)', value: weakestTenses.join(' · ')),
                  if (weakestPersons.isNotEmpty)
                    _StatLine(label: 'Personnes à reprendre', value: weakestPersons.join(', ')),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static bool? _readBool(dynamic value) {
    if (value is bool) return value;
    if (value == 'true' || value == 1) return true;
    if (value == 'false' || value == 0) return false;
    return null;
  }

  static void _addScore(Map<String, List<int>> scores, String key, bool correct) {
    final score = scores.putIfAbsent(key, () => [0, 0]);
    score[0]++;
    if (correct) score[1]++;
  }

  static List<String> _weakest(Map<String, List<int>> scores) {
    final entries = scores.entries.where((entry) => entry.value[0] >= 3).toList()
      ..sort((left, right) {
        final leftRate = left.value[1] / left.value[0];
        final rightRate = right.value[1] / right.value[0];
        return leftRate.compareTo(rightRate);
      });
    return entries.take(3).map((entry) =>
        '${entry.key} (${(entry.value[1] / entry.value[0] * 100).round()} %, n=${entry.value[0]})').toList();
  }
}

class _ConjugationMatrix extends StatelessWidget {
  const _ConjugationMatrix({required this.attempts});
  final List<PerformanceAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final matrix = <String, Map<String, List<int>>>{};
    final persons = <String>{};
    for (final attempt in attempts) {
      if (attempt.correct == null) continue;
      final key = '${attempt.metadata['mood'] ?? '?'} · ${attempt.metadata['tense'] ?? '?'}';
      final rawPersons = attempt.metadata['persons'];
      if (rawPersons is! Map) continue;
      Map<String, List<int>>? row;
      for (final entry in rawPersons.entries) {
        final person = entry.key.toString();
        final rawValue = entry.value;
        if (rawValue is! bool && rawValue != 'true' && rawValue != 'false' && rawValue != 1 && rawValue != 0) {
          continue;
        }
        row ??= matrix.putIfAbsent(key, () => {});
        persons.add(person);
        final score = row.putIfAbsent(person, () => [0, 0]);
        score[0]++;
        if (rawValue == true || rawValue == 'true' || rawValue == 1) score[1]++;
      }
    }
    if (matrix.isEmpty) return const SizedBox.shrink();
    final columns = persons.toList()..sort();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 34,
        dataRowMinHeight: 34,
        dataRowMaxHeight: 42,
        columns: [
          const DataColumn(label: Text('Temps')),
          for (final person in columns) DataColumn(label: Text(person)),
        ],
        rows: [
          for (final row in matrix.entries)
            DataRow(cells: [
              DataCell(Text(row.key, style: const TextStyle(fontSize: 12))),
              for (final person in columns) DataCell(_MatrixCell(score: row.value[person])),
            ]),
        ],
      ),
    );
  }
}

class _ConjugationTenseBars extends StatelessWidget {
  const _ConjugationTenseBars({required this.scores});
  final Map<String, List<int>> scores;

  @override
  Widget build(BuildContext context) {
    final entries = scores.entries.where((entry) => entry.value[0] >= 3).toList()
      ..sort((left, right) {
        final leftRate = left.value[1] / left.value[0];
        final rightRate = right.value[1] / right.value[0];
        return leftRate.compareTo(rightRate);
      });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Temps les moins réussis (minimum 3 réponses)', style: TextStyle(fontWeight: FontWeight.bold)),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Pas assez de réponses pour comparer les temps.'),
          )
        else
          for (final entry in entries.take(6))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 118, child: Text(entry.key, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11))),
                  Expanded(child: LinearProgressIndicator(value: entry.value[1] / entry.value[0], minHeight: 8)),
                  const SizedBox(width: 8),
                  Text('${(entry.value[1] / entry.value[0] * 100).round()} % · n=${entry.value[0]}'),
                ],
              ),
            ),
      ],
    );
  }

}

class _ConjugationPersonBars extends StatelessWidget {
  const _ConjugationPersonBars({required this.scores});
  final Map<String, List<int>> scores;

  @override
  Widget build(BuildContext context) {
    final entries = scores.entries.where((entry) => entry.value[0] >= 3).toList()
      ..sort((left, right) {
        final leftRate = left.value[1] / left.value[0];
        final rightRate = right.value[1] / right.value[0];
        return leftRate.compareTo(rightRate);
      });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Réussite par personne (minimum 3 réponses)', style: TextStyle(fontWeight: FontWeight.bold)),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Pas assez de réponses pour comparer les personnes.'),
          )
        else
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(width: 64, child: Text(entry.key, overflow: TextOverflow.ellipsis)),
                  Expanded(child: LinearProgressIndicator(value: entry.value[1] / entry.value[0], minHeight: 8)),
                  const SizedBox(width: 8),
                  Text('${(entry.value[1] / entry.value[0] * 100).round()} % · n=${entry.value[0]}'),
                ],
              ),
            ),
      ],
    );
  }

}

class _MatrixCell extends StatelessWidget {
  const _MatrixCell({required this.score});
  final List<int>? score;

  @override
  Widget build(BuildContext context) {
    if (score == null || score![0] == 0) return const Text('—');
    final rate = score![1] / score![0];
    final color = Color.lerp(Theme.of(context).colorScheme.errorContainer, Theme.of(context).colorScheme.primaryContainer, rate);
    return Container(
      constraints: const BoxConstraints(minWidth: 44),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text('${(rate * 100).round()} %', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 12),
            Flexible(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      );
}

class _NumDateResultsCard extends StatelessWidget {
  const _NumDateResultsCard({required this.attempts});
  final List<PerformanceAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    if (attempts.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.access_time_outlined),
          title: Text('Nombres & dates'),
          subtitle: Text('Aucun exercice enregistré pour le moment.'),
        ),
      );
    }
    final byType = <String, List<PerformanceAttempt>>{};
    var unevaluated = 0;
    for (final attempt in attempts) {
      if (attempt.exerciseType.trim().toLowerCase() == 'study_session') continue;
      final category = _categoryFor(attempt);
      byType.putIfAbsent(category, () => <PerformanceAttempt>[]).add(attempt);
      if (attempt.correct == null) unevaluated++;
    }
    if (byType.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.access_time_outlined),
          title: Text('Nombres & dates'),
          subtitle: Text('Aucune réponse individuelle enregistrée pour le moment.'),
        ),
      );
    }
    const labels = <String, String>{
      'number': 'Nombres',
      'date': 'Dates',
      'time': 'Heures',
      'other': 'Autres exercices',
    };
    const order = <String>['number', 'date', 'time', 'other'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time_outlined),
                const SizedBox(width: 8),
                Text('Nombres & dates', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            for (final type in order)
              if (byType[type] != null)
                Builder(builder: (context) {
                  final typeAttempts = byType[type]!;
                  final evaluated = typeAttempts.where((attempt) => attempt.correct != null).toList(growable: false);
                  final accuracy = ResultsAnalytics.accuracy(evaluated);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(labels[type]!)),
                            Text(accuracy == null ? '—' : '${(accuracy * 100).round()} %'),
                            const SizedBox(width: 8),
                            Text('n=${evaluated.length}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        if (accuracy != null) ...[
                          const SizedBox(height: 4),
                          LinearProgressIndicator(value: accuracy, minHeight: 7),
                        ] else
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Text('Aucune réponse évaluée', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                  );
                }),
            if (unevaluated > 0)
              Text('$unevaluated tentative(s) sans résultat évalué.', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  static String _categoryFor(PerformanceAttempt attempt) {
    final values = <String>[
      attempt.metadata['category']?.toString() ?? '',
      attempt.metadata['kind']?.toString() ?? '',
      attempt.metadata['type']?.toString() ?? '',
      attempt.metadata['subtype']?.toString() ?? '',
      attempt.exerciseType,
    ].join(' ').toLowerCase();
    if (values.contains('date') || values.contains('calendar')) return 'date';
    if (values.contains('time') || values.contains('hour') || values.contains('heure')) return 'time';
    if (values.contains('number') || values.contains('numeric') || values.contains('nombre')) return 'number';
    return 'other';
  }

}

class _TrainingResultsCard extends StatelessWidget {
  const _TrainingResultsCard({required this.skill, required this.title, required this.icon, required this.attempts});
  final String skill;
  final String title;
  final IconData icon;
  final List<PerformanceAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    if (attempts.isEmpty) {
      return Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: const Text('Aucune tentative enregistrée pour le moment.'),
        ),
      );
    }
    final isOral = skill == 'eo';
    final evaluated = isOral
        ? attempts.where((attempt) =>
            attempt.exerciseType.trim().toLowerCase() != 'study_session' &&
            attempt.rating != null && attempt.rating! >= 0 && attempt.rating! <= 3).toList(growable: false)
        : attempts.where((attempt) =>
            attempt.correct != null &&
            attempt.exerciseType.trim().toLowerCase() != 'study_session').toList(growable: false);
    final average = isOral
        ? ResultsAnalytics.meanRatingNormalised(evaluated)
        : ResultsAnalytics.accuracy(evaluated);
    final detail = average == null
        ? 'Aucune évaluation disponible · ${attempts.length} tentative(s)'
        : isOral
            ? 'Auto-évaluation : ${(average * 3).toStringAsFixed(1)} / 3 · n=${evaluated.length}'
            : '${(average * 100).round()} % de réussite · n=${evaluated.length}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(detail),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 54,
              height: 54,
              child: average == null
                  ? const Icon(Icons.hourglass_empty_outlined)
                  : CircularProgressIndicator(value: average),
            ),
          ],
        ),
      ),
    );
  }

}

class _ActivityHeatmap extends StatelessWidget {
  const _ActivityHeatmap({required this.attempts});
  final List<PerformanceAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    const dayCount = 14;
    final counts = List<int>.filled(dayCount, 0);
    for (final attempt in attempts) {
      if (attempt.correct == null || attempt.exerciseType.trim().toLowerCase() == 'study_session') continue;
      final local = attempt.recordedAt.toLocal();
      final date = DateTime.utc(local.year, local.month, local.day);
      final age = today.difference(date).inDays;
      if (age >= 0 && age < dayCount) counts[dayCount - 1 - age]++;
    }
    final maximum = counts.fold<int>(0, (current, value) => value > current ? value : current);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Réponses évaluées · 14 jours', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Chaque case est un jour ; aujourd’hui se trouve à droite.', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Row(
              children: List.generate(dayCount, (index) {
                final age = dayCount - 1 - index;
                final day = today.subtract(Duration(days: age));
                final count = counts[index];
                final intensity = maximum == 0 ? 0.0 : count / maximum;
                final background = count == 0
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Color.lerp(
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                        Theme.of(context).colorScheme.primary,
                        0.18 + intensity * 0.72,
                      )!;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Tooltip(
                      message: '${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')} : $count réponse(s) évaluée(s)',
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 0.92,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: background,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.45)),
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(count == 0 ? '—' : '$count', style: Theme.of(context).textTheme.labelSmall),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${day.day}', style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            if (maximum == 0)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Aucune réponse évaluée enregistrée sur cette période.'),
              ),
          ],
        ),
      ),
    );
  }

}

class _StudyTimeCard extends StatelessWidget {
  const _StudyTimeCard({required this.summary});
  final StudyDurationSummary summary;

  @override
  Widget build(BuildContext context) {
    final labels = <String, String>{
      'vocabulary': 'Vocabulaire',
      'conjugation': 'Conjugaison',
      'numdate': 'Nombres & dates',
      'eo': 'Expression orale',
      'ee': 'Expression écrite',
      'mixed': 'Sessions multi-compétences (non réparties)',
    };
    final measured = summary.bySkillMs.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));
    if (summary.totalMs <= 0) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.timer_outlined),
          title: Text('Temps d’étude'),
          subtitle: Text('Aucune durée de session exploitable. Vérifie que les événements study_session enregistrent durationMs.'),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.timer_outlined),
              const SizedBox(width: 8),
              Text('Temps d’étude mesuré', style: Theme.of(context).textTheme.titleMedium),
            ]),
            const SizedBox(height: 8),
            for (final entry in measured)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(labels[entry.key] ?? entry.key)),
                    Text(_formatDuration(entry.value)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 72,
                      child: LinearProgressIndicator(
                        value: entry.value / summary.totalMs,
                        minHeight: 7,
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
            Text('Total : ${_formatDuration(summary.totalMs)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '${summary.sessionCount} session(s) mesurée(s). Les durées répétées avec le même sessionId ne sont comptées qu’une fois.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (summary.mixedSessionCount > 0)
              Text(
                '${summary.mixedSessionCount} session(s) associée(s) à plusieurs compétences ne sont pas réparties artificiellement.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(int milliseconds) {
    if (milliseconds <= 0) return '0 min';
    if (milliseconds < 60000) return '< 1 min';
    final minutes = (milliseconds / 60000).floor();
    if (minutes < 60) return '$minutes min';
    return '${minutes ~/ 60} h ${minutes % 60} min';
  }

}

class _VocabularyLevelBars extends StatelessWidget {
  const _VocabularyLevelBars({required this.words});
  final List<VocabWord> words;

  @override
  Widget build(BuildContext context) {
    final summary = ResultsAnalytics.vocabularyByDifficulty(words);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Maîtrise estimée par niveau', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('La moyenne est calculée uniquement sur les mots déjà révisés.', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            for (final difficulty in VocabDifficulty.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Builder(builder: (context) {
                  final item = summary[difficulty]!;
                  final mastery = item.averageMastery;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 32, child: Text(difficulty.label, style: const TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(
                            child: mastery == null
                                ? Text('Pas encore évalué', style: Theme.of(context).textTheme.bodySmall)
                                : LinearProgressIndicator(value: mastery / 100, minHeight: 8),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 42,
                            child: Text(mastery == null ? '—' : '${mastery.round()} %', textAlign: TextAlign.end),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32, top: 2),
                        child: Text('${item.reviewedWords} mot(s) révisé(s)', style: Theme.of(context).textTheme.labelSmall),
                      ),
                    ],
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecentPriorities extends StatelessWidget {
  const _RecentPriorities({required this.words});
  final List<VocabWord> words;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final priorities = <VocabWord>[];
    for (final word in words) {
      priorities.add(word);
      priorities.sort((a, b) => a.masteryScore(now).compareTo(b.masteryScore(now)));
      if (priorities.length > 3) priorities.removeLast();
    }
    return Card(
      child: Column(
        children: [
          for (final word in priorities.take(3))
            ListTile(
              leading: const Icon(Icons.refresh_outlined),
              title: Text(word.labelFor(VocabLanguage.italian)),
              subtitle: Text(word.french),
              trailing: Text('${word.masteryScore(now).round()} %'),
            ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({this.onStartSession});
  final VoidCallback? onStartSession;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.auto_awesome_outlined, size: 36),
            const SizedBox(height: 12),
            const Text('Ton tableau de bord se remplira dès ta première révision.', textAlign: TextAlign.center),
            if (onStartSession != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                  onPressed: onStartSession,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Réviser maintenant')),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium)
      ]);
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.labelSmall)
      ]);
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.value, required this.label});
  final double value;
  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 76,
      height: 76,
      child: Stack(alignment: Alignment.center, children: [
        CircularProgressIndicator(value: value),
        Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))
      ]));
}
