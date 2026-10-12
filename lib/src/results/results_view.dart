import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/vocab_word.dart';
import '../data/models/performance_attempt.dart';
import '../localization/app_localizations.dart';
import '../repositories/performance_repository.dart';
import '../repositories/vocab_repository.dart';

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
  bool _contractDone = false;

  @override
  void initState() {
    super.initState();
    _resultsFuture = _cachedResultsFuture != null &&
            _cachedPerformanceRevision == _performanceRepository.revision &&
            _cachedVocabRevision == _repository.revision
        ? _cachedResultsFuture!
        : _loadAndCacheResults();
    _loadContractState();
  }

  Future<void> _loadContractState() async {
    final preferences = await SharedPreferences.getInstance();
    final key = 'retention_contract_${_dayKey(DateTime.now())}';
    if (mounted) setState(() => _contractDone = preferences.getBool(key) ?? false);
  }

  Future<void> _setContract(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('retention_contract_${_dayKey(DateTime.now())}', value);
    if (mounted) setState(() => _contractDone = value);
  }

  static String _dayKey(DateTime date) => '${date.year}-${date.month}-${date.day}';

  static Future<_ResultsData>? _cachedResultsFuture;
  static int? _cachedPerformanceRevision;
  static int? _cachedVocabRevision;

  Future<_ResultsData> _loadResults() async {
    await _repository.init();
    await _performanceRepository.init();
    return _ResultsData(words: _repository.all(), attempts: _performanceRepository.all());
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
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<_ResultsData>(
      future: _resultsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Impossible de charger tes résultats.'));
        }

        final data = snapshot.data ?? const _ResultsData(words: [], attempts: []);
        final words = data.words;
        final reviewed = words.where((word) => word.stats.attempts > 0).toList(growable: false);
        return RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: _Header()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _OverviewCard(words: words, reviewed: reviewed),
                    const SizedBox(height: 16),
                    _FocusMetricTile(attempts: data.attempts),
                    const SizedBox(height: 8),
                    _ConjugationResultsCard(
                      attempts: data.attempts.where((attempt) => attempt.skill == 'conjugation').toList(growable: false),
                      onStartSession: widget.onStartSession,
                    ),
                    const SizedBox(height: 16),
                    _DetailsSection(
                      title: 'Autres compétences',
                      icon: Icons.extension_outlined,
                      children: [
                        _NumDateResultsCard(
                          attempts: data.attempts.where((attempt) => attempt.skill == 'numdate').toList(growable: false),
                        ),
                        _TrainingResultsCard(
                          skill: 'eo',
                          title: 'Expression orale',
                          icon: Icons.record_voice_over_outlined,
                          attempts: data.attempts.where((attempt) => attempt.skill == 'eo').toList(growable: false),
                        ),
                        _TrainingResultsCard(
                          skill: 'ee',
                          title: 'Expression écrite',
                          icon: Icons.edit_note_outlined,
                          attempts: data.attempts.where((attempt) => attempt.skill == 'ee').toList(growable: false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _RetentionPulseCard(
                      words: words,
                      attempts: data.attempts,
                      contractDone: _contractDone,
                      onContractChanged: _setContract,
                      onStartSession: widget.onStartSession,
                    ),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: 'Activité récente', icon: Icons.calendar_view_week_outlined),
                    const SizedBox(height: 8),
                    _ActivityHeatmap(words: words, attempts: data.attempts),
                    const SizedBox(height: 8),
                    _StudyTimeCard(attempts: data.attempts),
                    const SizedBox(height: 16),
                    _DetailsSection(
                      title: 'Détails du niveau',
                      icon: Icons.tune_outlined,
                      children: [
                        const _SectionTitle(title: 'Bases par niveau', icon: Icons.radar_outlined),
                        _SkillRadar(words: words),
                        const _SectionTitle(title: 'Difficultés actuelles', icon: Icons.flag_outlined),
                        _DifficultyList(words: words),
                        if (reviewed.isEmpty)
                          _EmptyResults(onStartSession: widget.onStartSession)
                        else
                          _RecentPriorities(words: reviewed),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(l10n.vocabMastery, style: Theme.of(context).textTheme.labelSmall),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResultsData {
  const _ResultsData({required this.words, required this.attempts});

  final List<VocabWord> words;
  final List<PerformanceAttempt> attempts;
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
  const _FocusMetricTile({required this.attempts});

  final List<PerformanceAttempt> attempts;

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
    final answers = selected.where((attempt) => attempt.correct != null).toList();
    final correct = answers.where((attempt) => attempt.correct == true).length;
    final duration = selected.where((attempt) => attempt.exerciseType == 'study_session').fold<int>(0, (sum, attempt) => sum + (attempt.durationMs ?? 0));
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
                  items: available.map((skill) => DropdownMenuItem(value: skill, child: Text(_labels[skill] ?? skill))).toList(),
                  onChanged: (skill) => setState(() => _selectedSkill = skill ?? _selectedSkill),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Metric(value: '${answers.isEmpty ? 0 : (correct / answers.length * 100).round()} %', label: 'réussite'),
                _Metric(value: '${answers.length}', label: 'réponses'),
                _Metric(value: _formatDuration(duration), label: 'temps actif'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(int milliseconds) {
    final minutes = (milliseconds / 60000).round();
    return minutes == 0 ? '< 1 min' : '$minutes min';
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tes résultats', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Un aperçu simple pour savoir quoi travailler aujourd’hui.'),
          ],
        ),
      );
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.words, required this.reviewed});

  final List<VocabWord> words;
  final List<VocabWord> reviewed;

  @override
  Widget build(BuildContext context) {
    final attempts = reviewed.fold<int>(0, (sum, word) => sum + word.stats.attempts);
    final correct = reviewed.fold<int>(0, (sum, word) => sum + word.stats.correctAttempts);
    final mastery = reviewed.isEmpty ? 0.0 : reviewed.map((word) => word.masteryScore()).reduce((a, b) => a + b) / reviewed.length;
    final rate = attempts == 0 ? 0.0 : correct / attempts;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ScoreRing(value: mastery / 100, label: '${mastery.round()}'),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Niveau global', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(reviewed.isEmpty ? 'Commence une première révision.' : 'Ta mémoire progresse à chaque rappel.'),
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
                _Metric(value: '${(rate * 100).round()} %', label: 'réussite'),
                _Metric(value: '${words.length}', label: 'au catalogue'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RetentionPulseCard extends StatelessWidget {
  const _RetentionPulseCard({
    required this.words,
    required this.attempts,
    required this.contractDone,
    required this.onContractChanged,
    this.onStartSession,
  });

  final List<VocabWord> words;
  final List<PerformanceAttempt> attempts;
  final bool contractDone;
  final ValueChanged<bool> onContractChanged;
  final VoidCallback? onStartSession;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final activeDays = <String>{
      ...attempts.map((attempt) => _dayKey(attempt.recordedAt)),
      ...words.map((word) => word.stats.lastReviewedAt).whereType<DateTime>().map(_dayKey),
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
    final todayAttempts = attempts.where((attempt) => _sameDay(attempt.recordedAt, now)).toList();
    final answerCount = todayAttempts.where((attempt) => attempt.correct != null || attempt.rating != null).length;
    final activeMinutes = todayAttempts
            .where((attempt) => attempt.exerciseType == 'study_session')
            .fold<int>(0, (sum, attempt) => sum + (attempt.durationMs ?? 0)) /
        60000;
    final hasConjugation = todayAttempts.any((attempt) => attempt.skill == 'conjugation' && attempt.exerciseType != 'study_session');
    final tasks = [
      _RetentionTask('Faire 3 minutes de session', activeMinutes >= 3),
      _RetentionTask('Répondre à 5 questions', answerCount >= 5),
      _RetentionTask('Valider un exercice de conjugaison', hasConjugation),
    ];
    final completed = tasks.where((task) => task.done).length;
    final atRisk = streak > 0 && !todayActive;
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(atRisk ? Icons.local_fire_department_outlined : Icons.favorite_outline),
                const SizedBox(width: 8),
                Expanded(child: Text(streak == 0 ? 'Ton rythme commence aujourd’hui' : '$streak jour${streak > 1 ? 's' : ''} de suite', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                Text('$completed/${tasks.length}'),
              ],
            ),
            const SizedBox(height: 4),
            Text(atRisk ? 'Ta série est encore récupérable : quelques minutes suffisent.' : 'Une petite présence régulière vaut mieux qu’une longue session rare.'),
            const SizedBox(height: 8),
            for (final task in tasks)
              Row(
                children: [
                  Icon(task.done ? Icons.check_circle : Icons.radio_button_unchecked, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(task.label)),
                ],
              ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: contractDone,
              onChanged: (value) => onContractChanged(value ?? false),
              title: const Text('Je garde ce petit rendez-vous avec moi aujourd’hui.'),
            ),
            if (onStartSession != null)
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(onPressed: onStartSession, icon: const Icon(Icons.play_arrow), label: const Text('Commencer maintenant')),
              ),
          ],
        ),
      ),
    );
  }

  static bool _sameDay(DateTime left, DateTime right) => left.year == right.year && left.month == right.month && left.day == right.day;

  static String _dayKey(DateTime date) => '${date.year}-${date.month}-${date.day}';
}

class _RetentionTask {
  const _RetentionTask(this.label, this.done);

  final String label;
  final bool done;
}

class _ConjugationResultsCard extends StatelessWidget {
  const _ConjugationResultsCard({required this.attempts, this.onStartSession});

  final List<PerformanceAttempt> attempts;
  final VoidCallback? onStartSession;

  @override
  Widget build(BuildContext context) {
    final correct = attempts.where((attempt) => attempt.correct == true).length;
    final accuracy = attempts.isEmpty ? 0.0 : correct / attempts.length;
    final tenseStats = <String, List<int>>{};
    final personStats = <String, List<int>>{};
    for (final attempt in attempts) {
      final mood = attempt.metadata['mood']?.toString() ?? 'Mode inconnu';
      final tense = attempt.metadata['tense']?.toString() ?? 'Temps inconnu';
      _addScore(tenseStats, '$mood · $tense', attempt.correct == true);
      final persons = attempt.metadata['persons'];
      if (persons is Map) {
        for (final entry in persons.entries) {
          _addScore(personStats, entry.key.toString(), entry.value == true);
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
                Expanded(child: Text('Conjugaison', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                if (attempts.isNotEmpty) Text('${(accuracy * 100).round()} %'),
              ],
            ),
            const SizedBox(height: 10),
            if (attempts.isEmpty) ...[
              const Text('Aucune tentative enregistrée pour le moment.'),
              if (onStartSession != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(onPressed: onStartSession, icon: const Icon(Icons.play_arrow), label: const Text('S’entraîner maintenant')),
                ),
            ] else ...[
              LinearProgressIndicator(value: accuracy, minHeight: 8),
              const SizedBox(height: 8),
              Text('$correct bonne${correct > 1 ? 's' : ''} réponse${correct > 1 ? 's' : ''} sur ${attempts.length} vérification${attempts.length > 1 ? 's' : ''}.'),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text('Explorer les points à renforcer'),
                children: [
                  _ConjugationMatrix(attempts: attempts),
                  _ConjugationTenseBars(scores: tenseStats),
                  _ConjugationPersonRadar(scores: personStats),
                  if (weakestTenses.isNotEmpty) _StatLine(label: 'Temps à reprendre', value: weakestTenses.join(' · ')),
                  if (weakestPersons.isNotEmpty) _StatLine(label: 'Personnes les moins sûres', value: weakestPersons.join(', ')),
                  if (weakestTenses.isEmpty && weakestPersons.isEmpty) const Text('Pas encore assez de données pour dégager une tendance.'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static void _addScore(Map<String, List<int>> scores, String key, bool correct) {
    final score = scores.putIfAbsent(key, () => [0, 0]);
    score[0]++;
    if (correct) score[1]++;
  }

  static List<String> _weakest(Map<String, List<int>> scores) {
    final entries = scores.entries.where((entry) => entry.value[0] > 0).toList()
      ..sort((left, right) {
        final leftRate = left.value[1] / left.value[0];
        final rightRate = right.value[1] / right.value[0];
        return leftRate.compareTo(rightRate);
      });
    return entries.take(3).map((entry) => '${entry.key} (${(entry.value[1] / entry.value[0] * 100).round()} %)').toList();
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
      final key = '${attempt.metadata['mood'] ?? '?'} · ${attempt.metadata['tense'] ?? '?'}';
      final rawPersons = attempt.metadata['persons'];
      if (rawPersons is! Map) continue;
      final row = matrix.putIfAbsent(key, () => {});
      for (final entry in rawPersons.entries) {
        final person = entry.key.toString();
        persons.add(person);
        final score = row.putIfAbsent(person, () => [0, 0]);
        score[0]++;
        if (entry.value == true) score[1]++;
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
              for (final person in columns)
                DataCell(_MatrixCell(score: row.value[person])),
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
    final entries = scores.entries.toList()
      ..sort((left, right) => (right.value[0]).compareTo(left.value[0]));
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Comparaison des temps', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        for (final entry in entries.take(6))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(width: 118, child: Text(entry.key, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11))),
                Expanded(child: LinearProgressIndicator(value: entry.value[1] / entry.value[0], minHeight: 8)),
                const SizedBox(width: 8),
                Text('${(entry.value[1] / entry.value[0] * 100).round()} %'),
              ],
            ),
          ),
      ],
    );
  }
}

class _ConjugationPersonRadar extends StatelessWidget {
  const _ConjugationPersonRadar({required this.scores});

  final Map<String, List<int>> scores;

  @override
  Widget build(BuildContext context) {
    final entries = scores.entries.toList()..sort((left, right) => left.key.compareTo(right.key));
    if (entries.length < 3) return const SizedBox.shrink();
    final values = entries.map((entry) => entry.value[1] / entry.value[0]).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          const Align(alignment: Alignment.centerLeft, child: Text('Radar des personnes', style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(height: 180, child: CustomPaint(painter: _RadarPainter(values, Theme.of(context).colorScheme))),
          Wrap(spacing: 10, children: [for (var i = 0; i < entries.length; i++) Text('${entries[i].key}: ${(values[i] * 100).round()} %')]),
        ],
      ),
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
    if (attempts.isEmpty) return const SizedBox.shrink();
    final byType = <String, List<PerformanceAttempt>>{};
    for (final attempt in attempts) {
      byType.putIfAbsent(attempt.exerciseType, () => []).add(attempt);
    }
    const labels = {'number': 'Nombres', 'date': 'Dates', 'time': 'Heures'};
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
            for (final type in const ['number', 'date', 'time'])
              if (byType[type] != null)
                Builder(builder: (context) {
                  final typeAttempts = byType[type]!;
                  final correct = typeAttempts.where((attempt) => attempt.correct == true).length;
                  final rate = correct / typeAttempts.length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(labels[type]!)),
                        SizedBox(width: 110, child: LinearProgressIndicator(value: rate, minHeight: 7)),
                        const SizedBox(width: 10),
                        Text('${(rate * 100).round()} %'),
                      ],
                    ),
                  );
                }),
            if (byType['number'] != null) ...[
              const Divider(height: 20),
              const Text('Difficulté des nombres', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              _NumberBandBars(attempts: byType['number']!),
            ],
          ],
        ),
      ),
    );
  }
}

class _NumberBandBars extends StatelessWidget {
  const _NumberBandBars({required this.attempts});

  final List<PerformanceAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final bands = <String, List<PerformanceAttempt>>{};
    for (final attempt in attempts) {
      final band = attempt.metadata['difficultyBand']?.toString() ?? 'Inconnu';
      bands.putIfAbsent(band, () => []).add(attempt);
    }
    final orderedBands = ['0–99', '100–999', '1 000–9 999', '10 000–999 999', '1 000 000+'];
    return Column(
      children: [
        for (final band in orderedBands)
          if (bands[band] != null)
            Builder(builder: (context) {
              final bandAttempts = bands[band]!;
              final rate = bandAttempts.where((attempt) => attempt.correct == true).length / bandAttempts.length;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(width: 105, child: Text(band)),
                    Expanded(child: LinearProgressIndicator(value: rate, minHeight: 7)),
                    const SizedBox(width: 8),
                    Text('${(rate * 100).round()} %'),
                  ],
                ),
              );
            }),
      ],
    );
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
    if (attempts.isEmpty) return const SizedBox.shrink();
    final average = skill == 'eo'
        ? attempts.map((attempt) => attempt.rating ?? 0).reduce((left, right) => left + right) / (attempts.length * 3)
        : attempts.where((attempt) => attempt.correct == true).length / attempts.length;
    final detail = skill == 'eo'
        ? 'Auto-évaluation moyenne : ${(average * 3).toStringAsFixed(1)} / 3'
        : '${(average * 100).round()} % de traductions réussies';
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
                  Text('$detail · ${attempts.length} session${attempts.length > 1 ? 's' : ''}'),
                ],
              ),
            ),
            SizedBox(width: 54, child: CircularProgressIndicator(value: average)),
          ],
        ),
      ),
    );
  }
}

class _ActivityHeatmap extends StatelessWidget {
  const _ActivityHeatmap({required this.words, required this.attempts});

  final List<VocabWord> words;
  final List<PerformanceAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final counts = List<int>.filled(14, 0);
    for (final word in words) {
      final date = word.stats.lastReviewedAt;
      if (date == null) continue;
      final age = DateTime(now.year, now.month, now.day).difference(DateTime(date.year, date.month, date.day)).inDays;
      if (age >= 0 && age < counts.length) counts[age]++;
    }
    for (final attempt in attempts) {
      final age = DateTime(now.year, now.month, now.day).difference(DateTime(attempt.recordedAt.year, attempt.recordedAt.month, attempt.recordedAt.day)).inDays;
      if (age >= 0 && age < counts.length) counts[age]++;
    }
    final maxCount = counts.fold<int>(0, (max, count) => count > max ? count : max);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Les 14 derniers jours', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              children: List.generate(counts.length, (index) {
                final intensity = maxCount == 0 ? 0.0 : counts[index] / maxCount;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12 + intensity * 0.78),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text('${counts[index]}', style: Theme.of(context).textTheme.labelSmall)),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudyTimeCard extends StatelessWidget {
  const _StudyTimeCard({required this.attempts});

  final List<PerformanceAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final durations = <String, int>{};
    for (final attempt in attempts.where((attempt) => attempt.exerciseType == 'study_session')) {
      durations.update(attempt.skill, (value) => value + (attempt.durationMs ?? 0), ifAbsent: () => attempt.durationMs ?? 0);
    }
    final measured = durations.entries.where((entry) => entry.value > 0).toList();
    if (measured.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.timer_outlined),
          title: Text('Temps d’étude'),
          subtitle: Text('Le temps sera mesuré dès tes prochaines sessions.'),
        ),
      );
    }
    final total = measured.fold<int>(0, (sum, entry) => sum + entry.value);
    final labels = {'vocabulary': 'Vocabulaire', 'conjugation': 'Conjugaison', 'numdate': 'Nombres & dates', 'eo': 'Expression orale', 'ee': 'Expression écrite'};
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [const Icon(Icons.timer_outlined), const SizedBox(width: 8), Text('Temps d’étude mesuré', style: Theme.of(context).textTheme.titleMedium)]),
            const SizedBox(height: 8),
            for (final entry in measured)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(child: Text(labels[entry.key] ?? entry.key)),
                    Text(_formatDuration(entry.value)),
                    const SizedBox(width: 8),
                    SizedBox(width: 80, child: LinearProgressIndicator(value: entry.value / total, minHeight: 7)),
                  ],
                ),
              ),
            const Divider(),
            Text('Total : ${_formatDuration(total)}'),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(int milliseconds) {
    final minutes = (milliseconds / 60000).round();
    if (minutes < 60) return '$minutes min';
    return '${minutes ~/ 60} h ${minutes % 60} min';
  }
}

class _SkillRadar extends StatelessWidget {
  const _SkillRadar({required this.words});

  final List<VocabWord> words;

  @override
  Widget build(BuildContext context) {
    final values = VocabDifficulty.values.map((difficulty) {
      final levelWords = words.where((word) => word.difficulty == difficulty && word.stats.attempts > 0).toList();
      if (levelWords.isEmpty) return 0.0;
      return levelWords.map((word) => word.masteryScore() / 100).reduce((a, b) => a + b) / levelWords.length;
    }).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 240, child: CustomPaint(painter: _RadarPainter(values, Theme.of(context).colorScheme))),
            Wrap(
              spacing: 12,
              children: [
                for (var index = 0; index < VocabDifficulty.values.length; index++)
                  Text('${VocabDifficulty.values[index].label}: ${(values[index] * 100).round()} %'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyList extends StatelessWidget {
  const _DifficultyList({required this.words});

  final List<VocabWord> words;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (final difficulty in VocabDifficulty.values)
            Builder(builder: (context) {
              final items = words.where((word) => word.difficulty == difficulty && word.stats.attempts > 0).toList();
              final value = items.isEmpty ? 0.0 : items.map((word) => word.masteryScore()).reduce((a, b) => a + b) / items.length;
              return ListTile(
                dense: true,
                leading: CircleAvatar(radius: 14, child: Text(difficulty.label)),
                title: Text(items.isEmpty ? 'Pas encore évalué' : '${items.length} mot${items.length > 1 ? 's' : ''} revu${items.length > 1 ? 's' : ''}'),
                subtitle: LinearProgressIndicator(value: value / 100, minHeight: 6),
                trailing: Text('${value.round()} %'),
              );
            }),
        ],
      ),
    );
  }
}

class _RecentPriorities extends StatelessWidget {
  const _RecentPriorities({required this.words});

  final List<VocabWord> words;

  @override
  Widget build(BuildContext context) {
    final priorities = [...words]..sort((a, b) => a.masteryScore().compareTo(b.masteryScore()));
    return Card(
      child: Column(
        children: [
          for (final word in priorities.take(3))
            ListTile(
              leading: const Icon(Icons.refresh_outlined),
              title: Text(word.labelFor(VocabLanguage.italian)),
              subtitle: Text(word.french),
              trailing: Text('${word.masteryScore().round()} %'),
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
              OutlinedButton.icon(onPressed: onStartSession, icon: const Icon(Icons.play_arrow), label: const Text('Réviser maintenant')),
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
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(title, style: Theme.of(context).textTheme.titleMedium)]);
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(children: [Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text(label, style: Theme.of(context).textTheme.labelSmall)]);
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.value, required this.label});

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(width: 76, height: 76, child: Stack(alignment: Alignment.center, children: [CircularProgressIndicator(value: value), Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))]));
}

class _RadarPainter extends CustomPainter {
  _RadarPainter(this.values, this.colors);

  final List<double> values;
  final ColorScheme colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.36;
    final outline = Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = colors.outlineVariant;
    final fill = Paint()..style = PaintingStyle.fill..color = colors.primary.withValues(alpha: 0.24);
    final line = Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = colors.primary;
    for (var ring = 1; ring <= 4; ring++) {
      canvas.drawPath(_polygon(center, radius * ring / 4, values.length), outline);
    }
    for (var index = 0; index < values.length; index++) {
      canvas.drawLine(center, _point(center, radius, index, values.length), outline);
    }
    final valuePath = Path();
    for (var index = 0; index < values.length; index++) {
      final point = _point(center, radius * values[index].clamp(0.08, 1), index, values.length);
      if (index == 0) {
        valuePath.moveTo(point.dx, point.dy);
      } else {
        valuePath.lineTo(point.dx, point.dy);
      }
    }
    valuePath.close();
    canvas.drawPath(valuePath, fill);
    canvas.drawPath(valuePath, line);
  }

  Path _polygon(Offset center, double radius, int count) {
    final path = Path();
    for (var index = 0; index < count; index++) {
      final point = _point(center, radius, index, count);
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  Offset _point(Offset center, double radius, int index, int count) {
    final angle = -math.pi / 2 + 2 * math.pi * index / count;
    return Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => oldDelegate.values != values || oldDelegate.colors != colors;
}
