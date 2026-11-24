import 'package:flutter/material.dart';

import '../../data/models/performance_attempt.dart';
import '../../data/models/vocab_word.dart';
import '../../localization/app_localizations.dart';
import '../../repositories/performance_repository.dart';
import '../../services/asset_loader.dart';
import '../../services/study_session_tracker.dart';
import 'spelling_checker.dart';

class SpellingView extends StatefulWidget {
  const SpellingView({super.key});

  @override
  State<SpellingView> createState() => _SpellingViewState();
}

class _SpellingViewState extends State<SpellingView> {
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  static const _assetPath =
      'assets/vocabulaire/vocab_apprendreitalien-vocabulaire.json';
  static const _maxSessionWords = 200;

  final TextEditingController _answerController = TextEditingController();
  DateTime _exerciseStart = DateTime.now();
  String? _sessionId;
  List<VocabWord> _words = const [];
  int _wordIndex = 0;
  bool _loading = true;
  String? _hint;
  SpellingCheckResult? _result;
  int _correctCount = 0;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    StudySessionTracker.instance.start('spelling');
    _sessionId = 'spelling_${DateTime.now().microsecondsSinceEpoch}';
    AssetLoader.loadJsonListFast(_assetPath).then(_onWordsLoaded);
  }

  @override
  void dispose() {
    StudySessionTracker.instance.stop();
    _answerController.dispose();
    super.dispose();
  }

  void _onWordsLoaded(List<Map<String, dynamic>> payload) {
    final words = payload
        .map((entry) =>
            VocabWord.fromJson(entry, idFallback: entry['id']?.toString()))
        .where((word) => word.italian.trim().isNotEmpty)
        .toList(growable: false);
    final sensitive = words.where(SpellingChecker.isSpellingSensitive).toList();
    final selection = (sensitive.length >= 20 ? sensitive : words)..shuffle();
    if (!mounted) return;
    setState(() {
      _words = selection.take(_maxSessionWords).toList(growable: false);
      _loading = false;
      _wordIndex = 0;
    });
    _prepareExercise();
  }

  VocabWord? get _currentWord =>
      _words.isEmpty ? null : _words[_wordIndex % _words.length];

  void _prepareExercise() {
    setState(() {
      _result = null;
      _hint = null;
      _exerciseStart = DateTime.now();
      _answerController.clear();
    });
  }

  void _nextWord() {
    setState(() => _wordIndex = (_wordIndex + 1) % _words.length);
    _prepareExercise();
  }

  Future<void> _checkAnswer() async {
    final word = _currentWord;
    if (word == null || _result != null) return;
    final result = SpellingChecker.check(
      answer: _answerController.text,
      expected: word.labelFor(VocabLanguage.italian),
    );
    final now = DateTime.now();
    await _performanceRepository.record(
      PerformanceAttempt(
        id: '${_sessionId}_${word.id}_${now.microsecondsSinceEpoch}',
        sessionId: _sessionId ?? '',
        skill: 'spelling',
        exerciseType: 'dictation',
        itemId: word.id,
        recordedAt: now,
        correct: result.isCorrect,
        durationMs: now.difference(_exerciseStart).inMilliseconds,
        metadata: <String, dynamic>{
          'answer': result.answer,
          'expected': result.expected,
          'accentOnlyMismatch': result.isAlmostCorrect,
          'level': word.difficulty.label,
        },
      ),
    );
    setState(() {
      _result = result;
      _totalCount++;
      if (result.isCorrect) _correctCount++;
    });
  }

  double get _accuracy =>
      _totalCount == 0 ? 0 : _correctCount / _totalCount * 100;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.spellingTitle),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_accuracy.toStringAsFixed(0)}% ($_correctCount/$_totalCount)',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    final word = _currentWord;
    if (word == null) return Center(child: Text(l10n.spellingNoWords));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.spellingIntro,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              word.french,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            labelText: l10n.spellingInputLabel,
            border: const OutlineInputBorder(),
          ),
          enabled: _result == null,
        ),
        const SizedBox(height: 8),
        if (_hint != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l10n.spellingHintShown(_hint!)),
          ),
        if (_result == null) ...[
          TextButton.icon(
            onPressed: () => setState(() {
              _hint = SpellingChecker.firstLetter(
                  word.labelFor(VocabLanguage.italian));
            }),
            icon: const Icon(Icons.lightbulb_outline),
            label: Text(l10n.spellingHintButton),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed:
                _answerController.text.trim().isEmpty ? null : _checkAnswer,
            icon: const Icon(Icons.check),
            label: Text(l10n.eeCheck),
          ),
        ] else ...[
          _buildFeedback(l10n),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _nextWord,
            icon: const Icon(Icons.skip_next),
            label: Text(l10n.vocabNextWord),
          ),
        ],
      ],
    );
  }

  Widget _buildFeedback(AppLocalizations l10n) {
    final result = _result!;
    final color = switch (result.kind) {
      SpellingResultKind.exact => Colors.green.shade50,
      SpellingResultKind.accentOnlyMismatch => Colors.orange.shade50,
      SpellingResultKind.mismatch => Colors.red.shade50,
    };
    final icon = switch (result.kind) {
      SpellingResultKind.exact => Icons.check_circle,
      SpellingResultKind.accentOnlyMismatch => Icons.error_outline,
      SpellingResultKind.mismatch => Icons.cancel,
    };
    final message = switch (result.kind) {
      SpellingResultKind.exact => l10n.spellingCorrectFeedback,
      SpellingResultKind.accentOnlyMismatch => l10n.spellingAccentOnlyFeedback,
      SpellingResultKind.mismatch => l10n.spellingWrongFeedback,
    };
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.answerExpected(result.expected)),
            const SizedBox(height: 4),
            Text(
              l10n.answerYourAnswer(result.answer),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
