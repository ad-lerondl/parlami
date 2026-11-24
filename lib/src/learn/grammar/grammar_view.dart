import 'package:flutter/material.dart';

import '../../data/models/grammar_question.dart';
import '../../data/models/performance_attempt.dart';
import '../../localization/app_localizations.dart';
import '../../repositories/grammar_repository.dart';
import '../../repositories/performance_repository.dart';
import '../../services/study_session_tracker.dart';

class GrammarView extends StatefulWidget {
  const GrammarView({super.key});

  @override
  State<GrammarView> createState() => _GrammarViewState();
}

class _GrammarViewState extends State<GrammarView> {
  final GrammarRepository _repository = GrammarRepository();
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  static const int _sessionSize = 10;

  DateTime _questionStart = DateTime.now();
  String? _sessionId;
  List<GrammarQuestion> _questions = const [];
  int _currentIndex = 0;
  int? _selectedOption;
  bool _checked = false;
  int _correctCount = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    StudySessionTracker.instance.start('grammar');
    _repository.init().then((_) => _startSession());
  }

  @override
  void dispose() {
    StudySessionTracker.instance.stop();
    super.dispose();
  }

  GrammarQuestion? get _currentQuestion =>
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;

  void _startSession() {
    setState(() {
      _questions = _repository.randomQuestions(count: _sessionSize);
      _sessionId = 'grammar_${DateTime.now().microsecondsSinceEpoch}';
      _currentIndex = 0;
      _selectedOption = null;
      _checked = false;
      _correctCount = 0;
      _finished = false;
      _questionStart = DateTime.now();
    });
  }

  Future<void> _checkAnswer() async {
    final question = _currentQuestion;
    final selected = _selectedOption;
    if (question == null || selected == null || _checked) return;
    final isCorrect = question.isAnswerCorrect(selected);
    final now = DateTime.now();
    await _performanceRepository.record(
      PerformanceAttempt(
        id: '${_sessionId}_${question.id}_${now.microsecondsSinceEpoch}',
        sessionId: _sessionId ?? '',
        skill: 'grammar',
        exerciseType: 'multiple_choice',
        itemId: question.id,
        recordedAt: now,
        correct: isCorrect,
        durationMs: now.difference(_questionStart).inMilliseconds,
        metadata: <String, dynamic>{
          'topic': question.topic,
          'level': question.level,
          'answer': question.options[selected],
        },
      ),
    );
    setState(() {
      _checked = true;
      if (isCorrect) _correctCount++;
    });
  }

  void _nextQuestion() {
    final isLast = _currentIndex + 1 >= _questions.length;
    setState(() {
      _checked = false;
      _selectedOption = null;
      if (isLast) {
        _finished = true;
      } else {
        _currentIndex++;
        _questionStart = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final question = _currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.grammarTitle),
        actions: [
          if (!_finished)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.grammarQuestionProgress(_currentIndex + 1, _questions.length),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(context, l10n, question),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, GrammarQuestion? question) {
    if (_repository.totalCount == 0) {
      return Center(child: Text(l10n.grammarNoQuestions));
    }
    if (_finished) {
      return _buildSummary(l10n);
    }
    if (question == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildQuestion(context, l10n, question);
  }

  Widget _buildQuestion(BuildContext context, AppLocalizations l10n, GrammarQuestion question) {
    final isCorrectAnswer = _selectedOption == question.answerIndex;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.grammarIntro,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Text(
          question.prompt,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              question.sentence,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 16),
        RadioGroup<int>(
          groupValue: _selectedOption,
          onChanged: (value) => setState(() => _selectedOption = value),
          child: Column(
            children: List.generate(question.options.length, (index) {
              return RadioListTile<int>(
                value: index,
                title: Text(question.options[index]),
                enabled: !_checked,
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        if (!_checked)
          FilledButton.icon(
            onPressed: _selectedOption == null ? null : _checkAnswer,
            icon: const Icon(Icons.check),
            label: Text(l10n.eeCheck),
          )
        else ...[
          Card(
            color: isCorrectAnswer ? Colors.green.shade50 : Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                        color: isCorrectAnswer
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          isCorrectAnswer
                              ? l10n.answerCorrect
                              : l10n.answerIncorrect,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.grammarExplanation(question.explanation)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _nextQuestion,
            icon: Icon(_currentIndex + 1 >= _questions.length
                ? Icons.flag
                : Icons.skip_next),
            label: Text(_currentIndex + 1 >= _questions.length
                ? l10n.grammarFinishedTitle
                : l10n.grammarNext),
          ),
        ],
      ],
    );
  }

  Widget _buildSummary(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 64),
            const SizedBox(height: 16),
            Text(
              l10n.grammarFinishedTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.grammarScore(_correctCount, _questions.length),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _startSession,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.grammarRestart),
            ),
          ],
        ),
      ),
    );
  }
}
