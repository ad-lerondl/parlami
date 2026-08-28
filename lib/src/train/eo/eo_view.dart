import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parlami/src/data/models/eo_question.dart';
import 'package:parlami/src/repositories/eo_repository.dart';

enum EODifficulty {
  free('Mode libre', 'Tu avances quand tu veux, sans aide.'),
  selfEval('Facile', 'Réponds puis auto-évalue-toi et regarde une piste de réponse.'),
  timed('Difficile', 'Chrono, suivi des hésitations et auto-évaluation.');

  final String label;
  final String description;
  const EODifficulty(this.label, this.description);
}

class EOView extends StatefulWidget {
  const EOView({super.key});

  @override
  State<EOView> createState() => _EOViewState();
}

class _EOViewState extends State<EOView> {
  final repo = EORepository();
  EODifficulty difficulty = EODifficulty.free;
  EOQuestion? current;
  bool showTip = false;
  bool showAnswer = false;
  int? selfRating; // 0-3
  String currentLevel = 'A1';
  List<String> followUpQueue = [];

  // Chrono (mode difficile)
  Timer? _ticker;
  Timer? _autoStartTimer;
  DateTime? _segmentStart;
  Duration totalElapsed = Duration.zero;
  Duration talkElapsed = Duration.zero;
  Duration hesitateElapsed = Duration.zero;
  bool timerRunning = false;
  bool isTalking = true; // true: parole, false: hésitation

  @override
  void initState() {
    super.initState();
    repo.init().then((_) => _loadQuestion());
  }

  @override
  void dispose() {
    _stopTimer();
    _autoStartTimer?.cancel();
    super.dispose();
  }

  void _loadQuestion() {
    EOQuestion? q;
    final canFollow = difficulty == EODifficulty.free || (selfRating != null && selfRating! >= 2);
    if (followUpQueue.isNotEmpty && canFollow) {
      final nextId = followUpQueue.removeAt(0);
      q = repo.byId(nextId);
      // conserve les éventuels autres follow-ups restants
    }

    if (q == null) {
      followUpQueue.clear();
      // En mode libre, choisir aléatoirement le prochain niveau avec des probabilités
      String levelToLoad = currentLevel;
      if (difficulty == EODifficulty.free) {
        levelToLoad = _selectRandomLevel(currentLevel);
      }
      q = repo.randomQuestion(level: levelToLoad, startableOnly: true);
    }

    if (q != null) {
      followUpQueue = List.from(q.followUps);
      // Mettre à jour currentLevel avec le niveau de la question chargée
      currentLevel = q.level;
    }
    if (q == null) return;
    setState(() {
      current = q;
      showTip = false;
      showAnswer = false;
      selfRating = null;
      _resetTiming();
    });
    if (difficulty == EODifficulty.timed && mounted) {
      _autoStartTimer?.cancel();
      _autoStartTimer = Timer(const Duration(seconds: 2), () {
        if (mounted && !timerRunning) _startTimer();
      });
    }
  }

  String _selectRandomLevel(String current) {
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    final currentIdx = levels.indexOf(current);
    final rng = Random();
    final roll = rng.nextDouble();

    // Probabilités décroissantes: même niveau > +1 > -1 > +2 > +3 > -2 > -3
    // Même niveau: 50%, +1: 19%, -1: 16%, +2: 8%, +3: 4%, -2: 2%, -3: 1%
    final candidates = <(String, double)>[];

    // Même niveau (50%)
    candidates.add((current, 0.50));

    // +1 (19%)
    if (currentIdx < levels.length - 1) {
      candidates.add((levels[currentIdx + 1], 0.19));
    }

    // -1 (16%)
    if (currentIdx > 0) {
      candidates.add((levels[currentIdx - 1], 0.16));
    }

    // +2 (8%)
    if (currentIdx < levels.length - 2) {
      candidates.add((levels[currentIdx + 2], 0.08));
    }

    // +3 (4%)
    if (currentIdx < levels.length - 3) {
      candidates.add((levels[currentIdx + 3], 0.04));
    }

    // -2 (2%)
    if (currentIdx > 1) {
      candidates.add((levels[currentIdx - 2], 0.02));
    }

    // -3 (1%)
    if (currentIdx > 2) {
      candidates.add((levels[currentIdx - 3], 0.01));
    }

    // Normaliser les probabilités
    double totalProb = candidates.fold(0.0, (sum, c) => sum + c.$2);
    double cumulative = 0.0;

    for (final (level, prob) in candidates) {
      cumulative += prob / totalProb;
      if (roll < cumulative) {
        return level;
      }
    }

    return current; // Fallback
  }

  void _resetTiming() {
    _autoStartTimer?.cancel();
    _autoStartTimer = null;
    _stopTimer();
    setState(() {
      totalElapsed = Duration.zero;
      talkElapsed = Duration.zero;
      hesitateElapsed = Duration.zero;
      _segmentStart = null;
      isTalking = true;
    });
  }

  void _startTimer() {
    if (timerRunning) return;
    setState(() {
      _segmentStart = DateTime.now();
      timerRunning = true;
    });
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) setState(() {});
    });
  }

  void _stopTimer() {
    _ticker?.cancel();
    _ticker = null;
    if (_segmentStart != null && timerRunning) {
      _commitSegment();
    }
    setState(() {
      timerRunning = false;
    });
  }

  void _toggleSpeechMode() {
    if (!timerRunning) return;
    setState(() {
      _commitSegment();
      isTalking = !isTalking;
    });
  }

  void _commitSegment() {
    if (_segmentStart == null) return;
    final now = DateTime.now();
    final delta = now.difference(_segmentStart!);
    if (isTalking) {
      talkElapsed += delta;
    } else {
      hesitateElapsed += delta;
    }
    totalElapsed = talkElapsed + hesitateElapsed;
    _segmentStart = now;
  }

  void _onEvaluate(int rating) {
    setState(() {
      selfRating = rating;
    });
    final rng = Random();
    final levels = ['A1', 'A2', 'B1', 'B2'];
    final idx = levels.indexOf(currentLevel);

    if (rating == 0 && idx > 0 && rng.nextDouble() < 0.7) {
      currentLevel = levels[idx - 1];
    } else if (rating == 1 && idx > 0 && rng.nextDouble() < 0.3) {
      currentLevel = levels[idx - 1];
    } else if (rating == 2 && idx < levels.length - 1 && rng.nextDouble() < 0.2) {
      currentLevel = levels[idx + 1];
    } else if (rating == 3 && idx < levels.length - 1 && rng.nextDouble() < 0.6) {
      currentLevel = levels[idx + 1];
    }
  }

  void _selectLevel(String level) {
    setState(() {
      currentLevel = level;
      followUpQueue.clear();
      selfRating = null;
    });
    _loadQuestion();
  }

  String _format(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  void _showLevelPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir le niveau'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioGroup<String>(
              groupValue: currentLevel,
              onChanged: (val) {
                if (val != null) _selectLevel(val);
                Navigator.pop(context);
              },
              child: Column(
                children: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                    .map((level) => RadioListTile<String>(
                          title: Text('Niveau $level'),
                          value: level,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = current;
    final liveTalk = talkElapsed +
        ((timerRunning && isTalking && _segmentStart != null)
            ? DateTime.now().difference(_segmentStart!)
            : Duration.zero);
    final liveHesitate = hesitateElapsed +
        ((timerRunning && !isTalking && _segmentStart != null)
            ? DateTime.now().difference(_segmentStart!)
            : Duration.zero);
    final liveTotal = liveTalk + liveHesitate;

    return Scaffold(
      appBar: AppBar(title: const Text('EO - Expression Orale')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<EODifficulty>(
                segments: EODifficulty.values.map((d) => ButtonSegment(value: d, label: Text(d.label))).toList(),
                selected: {difficulty},
                onSelectionChanged: (s) {
                  setState(() {
                    difficulty = s.first;
                    showAnswer = false;
                    selfRating = null;
                    followUpQueue.clear();
                    _resetTiming();
                  });
                  if (s.first == EODifficulty.timed && current != null && mounted) {
                    _autoStartTimer?.cancel();
                    _autoStartTimer = Timer(const Duration(seconds: 2), () {
                      if (mounted && !timerRunning) _startTimer();
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(difficulty.description, style: theme.textTheme.bodySmall),
              const SizedBox(height: 20),
              if (q == null) ...[
                const Center(child: Text('Aucune question disponible')),
              ] else ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                q.topic != null ? 'Question : ${q.topic}' : 'Question',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            ActionChip(
                              label: Text('Niveau $currentLevel'),
                              onPressed: () => _showLevelPicker(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(q.prompt, style: theme.textTheme.headlineSmall),
                        if (q.tip != null) ...[
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => setState(() => showTip = !showTip),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: showTip ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: showTip
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        showTip ? Icons.lightbulb : Icons.lightbulb_outline,
                                        color: showTip ? Colors.amber : theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        showTip ? 'Indice' : 'Cliquer pour un indice',
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: showTip ? theme.colorScheme.primary : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (showTip) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      q.tip!,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (q.expectedAnswer != null) ...[
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => setState(() => showAnswer = !showAnswer),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: showAnswer ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3) : null,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: showAnswer
                                      ? theme.colorScheme.secondary
                                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        showAnswer ? Icons.visibility : Icons.visibility_outlined,
                                        color: showAnswer ? theme.colorScheme.secondary : theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        showAnswer ? 'Piste de réponse' : 'Cliquer pour une piste de réponse',
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: showAnswer ? theme.colorScheme.secondary : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (showAnswer) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      q.expectedAnswer!,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (difficulty == EODifficulty.timed) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Chronomètre', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _MetricBox(
                                label: 'Total',
                                value: _format(liveTotal),
                                color: theme.colorScheme.primary,
                              ),
                              _MetricBox(
                                label: 'Parole',
                                value: _format(liveTalk),
                                color: Colors.green,
                              ),
                              _MetricBox(
                                label: 'Hésitation',
                                value: _format(liveHesitate),
                                color: Colors.orange,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilledButton.icon(
                                onPressed: timerRunning ? _toggleSpeechMode : _startTimer,
                                style: FilledButton.styleFrom(
                                  backgroundColor: timerRunning ? (isTalking ? Colors.orange : Colors.green) : null,
                                ),
                                icon: Icon(
                                  timerRunning
                                      ? (isTalking ? Icons.more_time : Icons.record_voice_over)
                                      : Icons.play_arrow,
                                ),
                                label: Text(
                                  timerRunning
                                      ? (isTalking ? 'Marquer une hésitation' : 'Reprendre la parole')
                                      : 'Démarrer',
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (timerRunning)
                                FilledButton.icon(
                                  onPressed: _stopTimer,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  icon: const Icon(Icons.stop),
                                  label: const Text('Arrêter'),
                                ),
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: 'Réinitialiser',
                                onPressed: _resetTiming,
                                icon: const Icon(Icons.restart_alt),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (difficulty != EODifficulty.free) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Auto-évaluation', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _EvalChip(label: 'Excellent', index: 3, current: selfRating, onTap: () => _onEvaluate(3)),
                              _EvalChip(label: 'Bien', index: 2, current: selfRating, onTap: () => _onEvaluate(2)),
                              _EvalChip(label: 'Moyen', index: 1, current: selfRating, onTap: () => _onEvaluate(1)),
                              _EvalChip(label: 'Difficile', index: 0, current: selfRating, onTap: () => _onEvaluate(0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: ((difficulty == EODifficulty.timed && (timerRunning || selfRating == null)) ||
                          (difficulty == EODifficulty.selfEval && selfRating == null))
                      ? null
                      : _loadQuestion,
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Question suivante'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _EvalChip extends StatelessWidget {
  const _EvalChip({required this.label, required this.index, required this.current, required this.onTap});
  final String label;
  final int index;
  final int? current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = current == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: _colorForRating(index),
      onSelected: (_) => onTap(),
    );
  }

  Color? _colorForRating(int idx) {
    switch (idx) {
      case 3:
        return Colors.green.withValues(alpha: 0.3);
      case 2:
        return Colors.lightGreen.withValues(alpha: 0.3);
      case 1:
        return Colors.orange.withValues(alpha: 0.3);
      case 0:
        return Colors.red.withValues(alpha: 0.3);
      default:
        return null;
    }
  }
}
