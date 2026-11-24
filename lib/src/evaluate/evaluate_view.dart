import 'package:flutter/material.dart';

import '../data/models/performance_attempt.dart';
import '../data/models/vocab_word.dart';
import '../localization/app_localizations.dart';
import '../repositories/ee_repository.dart';
import '../repositories/eo_repository.dart';
import '../repositories/grammar_repository.dart';
import '../repositories/performance_repository.dart';
import '../services/asset_loader.dart';
import '../services/study_session_tracker.dart';
import 'evaluate_engine.dart';

class EvaluateView extends StatefulWidget {
  const EvaluateView({super.key});

  @override
  State<EvaluateView> createState() => _EvaluateViewState();
}

class _EvaluateViewState extends State<EvaluateView> {
  final GrammarRepository _grammarRepository = GrammarRepository();
  final EERepository _eeRepository = EERepository();
  final EORepository _eoRepository = EORepository();
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  static const _vocabAssetPath =
      'assets/vocabulaire/vocab_apprendreitalien-vocabulaire.json';

  final TextEditingController _answerController = TextEditingController();
  DateTime _stepStart = DateTime.now();
  String? _sessionId;
  bool _loadingBanks = true;
  List<EvaluateQuestion> _session = const [];
  int _stepIndex = 0;
  int? _selectedOption;
  EvaluateAnswerRecord? _lastRecord;
  final List<EvaluateAnswerRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadBanks() async {
    await Future.wait([
      _grammarRepository.init(),
      _eeRepository.init(),
      _eoRepository.init(),
      _performanceRepository.init(),
    ]);
    if (!mounted) return;
    setState(() => _loadingBanks = false);
  }

  bool get _inSession => _stepIndex < _session.length;

  Future<void> _startScenario(EvaluateScenario scenario, AppLocalizations l10n) async {
    final vocabPayload = await AssetLoader.loadJsonListFast(_vocabAssetPath);
    final vocabWords = vocabPayload
        .map((entry) =>
            VocabWord.fromJson(entry, idFallback: entry['id']?.toString()))
        .toList(growable: false);
    final questions = EvaluateEngine.buildSession(
      scenario: scenario,
      banks: EvaluateBanks(
        grammarQuestions: _grammarRepository.all(),
        vocabWords: vocabWords,
        eeSentences: _eeRepository.all(),
        eoQuestions: _eoRepository.all(startableOnly: true),
      ),
    );
    if (!mounted) return;
    await StudySessionTracker.instance.start('evaluate');
    if (!mounted) return;
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.grammarNoQuestions)),
      );
      return;
    }
    setState(() {
      _sessionId = 'evaluate_${DateTime.now().microsecondsSinceEpoch}';
      _session = questions;
      _stepIndex = 0;
      _records.clear();
      _lastRecord = null;
      _selectedOption = null;
      _stepStart = DateTime.now();
      _answerController.clear();
    });
  }

  void _backToScenarios() {
    setState(() {
      _session = const [];
      _stepIndex = 0;
      _records.clear();
      _lastRecord = null;
    });
  }

  EvaluateQuestion get _currentQuestion => _session[_stepIndex];

  Future<void> _recordAnswer(EvaluateAnswerRecord record) async {
    final now = DateTime.now();
    await _performanceRepository.record(
      PerformanceAttempt(
        id: '${_sessionId}_${record.question.id}_${now.microsecondsSinceEpoch}',
        sessionId: _sessionId ?? '',
        skill: record.question.skill,
        exerciseType: record.question.kind.name,
        itemId: record.question.id,
        recordedAt: now,
        correct: record.correct,
        rating: record.rating,
        durationMs: record.durationMs,
        metadata: <String, dynamic>{
          'answer': record.answer,
          'level': record.question.level ?? '',
        },
      ),
    );
    setState(() {
      _records.add(record);
      _lastRecord = record;
    });
  }

  Future<void> _checkTypedAnswer(AppLocalizations l10n) async {
    final question = _currentQuestion;
    if (_lastRecord != null) return;
    final correct = question.isTypedAnswerCorrect(_answerController.text);
    await _recordAnswer(
      EvaluateAnswerRecord(
        question: question,
        correct: correct,
        answer: _answerController.text,
        durationMs: DateTime.now().difference(_stepStart).inMilliseconds,
      ),
    );
  }

  Future<void> _checkMultipleChoice(AppLocalizations l10n) async {
    final question = _currentQuestion;
    final selected = _selectedOption;
    if (_lastRecord != null || selected == null) return;
    await _recordAnswer(
      EvaluateAnswerRecord(
        question: question,
        correct: question.isMultipleChoiceCorrect(selected),
        answer: question.options[selected],
        durationMs: DateTime.now().difference(_stepStart).inMilliseconds,
      ),
    );
  }

  Future<void> _submitOralRating(int rating) async {
    final question = _currentQuestion;
    if (_lastRecord != null) return;
    await _recordAnswer(
      EvaluateAnswerRecord(
        question: question,
        correct: null,
        rating: rating,
        answer: '',
        durationMs: DateTime.now().difference(_stepStart).inMilliseconds,
      ),
    );
  }

  void _nextStep() {
    final isLast = _stepIndex + 1 >= _session.length;
    setState(() {
      _stepIndex++;
      _lastRecord = null;
      _selectedOption = null;
      _stepStart = DateTime.now();
      _answerController.clear();
    });
    if (isLast) {
      StudySessionTracker.instance.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.evaluateTitle)),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loadingBanks) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_session.isEmpty) {
      return _buildScenarioList(l10n);
    }
    if (!_inSession) {
      return _buildSessionSummary(l10n);
    }
    return _buildStep(l10n);
  }

  Widget _buildScenarioList(AppLocalizations l10n) {
    final scenarios = [
      (EvaluateScenario.dailyConversation, l10n.scenarioDailyConversation,
          l10n.scenarioDailyConversationDetails, Icons.forum),
      (EvaluateScenario.articleSummary, l10n.scenarioArticleSummary,
          l10n.scenarioArticleSummaryDetails, Icons.summarize),
      (EvaluateScenario.matchDebrief, l10n.scenarioMatchDebrief,
          l10n.scenarioMatchDebriefDetails, Icons.sports_soccer),
      (EvaluateScenario.quickDiscussion, l10n.scenarioQuickDiscussion,
          l10n.scenarioQuickDiscussionDetails, Icons.speed),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.evaluateIntro, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 12),
        Text(
          l10n.evaluateProgression,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        ...scenarios.map((entry) {
          final (scenario, title, details, icon) = entry;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(child: Icon(icon)),
              title: Text(title),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(details),
              ),
              isThreeLine: true,
              trailing: FilledButton(
                onPressed: () => _startScenario(scenario, l10n),
                child: Text(l10n.evaluateStartButton),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep(AppLocalizations l10n) {
    final question = _currentQuestion;
    final feedback = _lastRecord;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.evaluateQuestionProgress(_stepIndex + 1, _session.length),
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        Text(
          question.prompt,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (question.sentence != null) ...[
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                question.sentence!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        _buildQuestionInput(l10n, question),
        const SizedBox(height: 16),
        if (feedback == null) _buildCheckControls(l10n, question),
        if (feedback != null) ...[
          _buildFeedback(l10n, question),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _nextStep,
            icon: Icon(
                _stepIndex + 1 >= _session.length ? Icons.flag : Icons.skip_next),
            label: Text(_stepIndex + 1 >= _session.length
                ? l10n.evaluateFinishedTitle
                : l10n.evaluateNextStep),
          ),
        ],
      ],
    );
  }

  Widget _buildQuestionInput(AppLocalizations l10n, EvaluateQuestion question) {
    switch (question.kind) {
      case EvaluateQuestionKind.multipleChoice:
        return RadioGroup<int>(
          groupValue: _selectedOption,
          onChanged: (value) => setState(() => _selectedOption = value),
          child: Column(
            children: List.generate(question.options.length, (index) {
              return RadioListTile<int>(
                value: index,
                title: Text(question.options[index]),
                enabled: _lastRecord == null,
              );
            }),
          ),
        );
      case EvaluateQuestionKind.translation:
      case EvaluateQuestionKind.sentence:
        return TextField(
          controller: _answerController,
          enabled: _lastRecord == null,
          maxLines: 3,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.evaluateTypeAnswerLabel,
            border: const OutlineInputBorder(),
          ),
        );
      case EvaluateQuestionKind.oral:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.tip != null && _lastRecord != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  question.tip!,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black54),
                ),
              ),
            Text(
              l10n.evaluateSelfRatingPrompt,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Wrap(
              spacing: 8,
              children: [
                for (var rating = 0; rating <= 3; rating++)
                  OutlinedButton(
                    onPressed: _lastRecord != null
                        ? null
                        : () => _submitOralRating(rating),
                    child: Text(l10n.evaluateRatingLabel(rating)),
                  ),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildCheckControls(AppLocalizations l10n, EvaluateQuestion question) {
    if (question.kind == EvaluateQuestionKind.oral) {
      return const SizedBox.shrink();
    }
    final enabled = question.kind == EvaluateQuestionKind.multipleChoice
        ? _selectedOption != null
        : _answerController.text.trim().isNotEmpty;
    return FilledButton.icon(
      onPressed: enabled
          ? () {
              if (question.kind == EvaluateQuestionKind.multipleChoice) {
                _checkMultipleChoice(l10n);
              } else {
                _checkTypedAnswer(l10n);
              }
            }
          : null,
      icon: const Icon(Icons.check),
      label: Text(l10n.eeCheck),
    );
  }

  Widget _buildFeedback(AppLocalizations l10n, EvaluateQuestion question) {
    final record = _lastRecord!;
    if (record.correct == null && record.rating != null) {
      return Text(
        l10n.evaluateRatingRecorded(record.rating!),
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      );
    }
    final isCorrect = record.correct == true;
    return Card(
      color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect
                        ? Colors.green.shade700
                        : Colors.red.shade700),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isCorrect ? l10n.answerCorrect : l10n.answerIncorrect,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (!isCorrect && question.expectedAnswers.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l10n.answerExpected(question.expectedAnswers.first)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSessionSummary(AppLocalizations l10n) {
    final result = EvaluateSessionResult(
      evaluated: _records.where((record) => record.correct != null).length,
      correct: _records.where((record) => record.correct == true).length,
      ratings: _records
          .map((record) => record.rating)
          .whereType<int>()
          .toList(growable: false),
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 64),
            const SizedBox(height: 16),
            Text(
              l10n.evaluateFinishedTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.evaluateResultScore(result.correct, result.evaluated),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (result.meanRating != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.evaluateResultOral(result.meanRating!.toStringAsFixed(1)),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _backToScenarios,
              icon: const Icon(Icons.replay),
              label: Text(l10n.evaluateRetakeButton),
            ),
          ],
        ),
      ),
    );
  }
}
