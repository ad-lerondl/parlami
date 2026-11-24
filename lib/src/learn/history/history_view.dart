import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/quiz_round.dart';
import '../../data/models/performance_attempt.dart';
import '../../localization/app_localizations.dart';
import '../../repositories/performance_repository.dart';
import '../../services/asset_loader.dart';
import '../../services/study_session_tracker.dart';

class _HistoryPeriod {
  const _HistoryPeriod(
    this.id,
    this.name,
    this.years,
    this.summary,
    this.highlights,
    this.figures,
    this.vocab,
  );

  final String id;
  final String name;
  final String years;
  final String summary;
  final List<String> highlights;
  final List<String> figures;
  final List<MapEntry<String, String>> vocab;
}

class _HistoryQuiz {
  const _HistoryQuiz(this.id, this.question, this.options, this.correct, this.explanation);

  final String id;
  final String question;
  final List<String> options;
  final int correct;
  final String explanation;
}

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final Random _random = Random();
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  final String _sessionId = DateTime.now().microsecondsSinceEpoch.toString();

  final List<_HistoryPeriod> _periods = [];
  final List<_HistoryQuiz> _quiz = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    StudySessionTracker.instance.start('history');
    _load();
  }

  @override
  void dispose() {
    StudySessionTracker.instance.stop();
    super.dispose();
  }

  Future<void> _load() async {
    final data =
        await AssetLoader.loadJson('assets/culture/storia_italia.json') as Map<String, dynamic>;
    final periods = (data['periods'] as List).cast<Map<String, dynamic>>();
    final quiz = (data['quiz'] as List).cast<Map<String, dynamic>>();
    if (!mounted) return;
    setState(() {
      _periods
        ..clear()
        ..addAll(periods.map((raw) => _HistoryPeriod(
              raw['id'] as String,
              raw['name'] as String,
              raw['years'] as String,
              raw['summary'] as String,
              (raw['highlights'] as List).cast<String>(),
              (raw['figures'] as List).cast<String>(),
              ((raw['vocab'] as List).cast<Map<String, dynamic>>())
                  .map((entry) => MapEntry(entry['it'] as String, entry['fr'] as String))
                  .toList(growable: false),
            )));
      _quiz
        ..clear()
        ..addAll(quiz.map((raw) => _HistoryQuiz(
              raw['id'] as String,
              raw['question'] as String,
              (raw['options'] as List).cast<String>(),
              (raw['correct'] as num).toInt(),
              raw['explanation'] as String? ?? '',
            )));
      _loaded = true;
    });
  }

  void _recordAnswer(String itemId, bool correct) {
    _performanceRepository.record(PerformanceAttempt(
      id: 'history_${itemId}_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: _sessionId,
      skill: 'history',
      exerciseType: 'history_event',
      itemId: itemId,
      correct: correct,
      recordedAt: DateTime.now(),
      metadata: const {'mode': 'quiz'},
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.learnHistory),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.historyTabTimeline),
              Tab(text: l10n.historyTabQuiz),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTimelineTab(),
            _buildQuizTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var index = 0; index < _periods.length; index++)
          _buildTimelineItem(_periods[index], isLast: index == _periods.length - 1),
      ],
    );
  }

  Widget _buildTimelineItem(_HistoryPeriod period, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.green.shade200),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(left: 0, bottom: 12, top: 0),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(period.years,
                        style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                    Text(period.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(period.summary),
                    const SizedBox(height: 8),
                    ...period.highlights.map(
                      (highlight) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('• $highlight'),
                      ),
                    ),
                    if (period.figures.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: period.figures
                            .map((figure) => Chip(
                                  label: Text(figure),
                                  visualDensity: VisualDensity.compact,
                                ))
                            .toList(),
                      ),
                    ],
                    if (period.vocab.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: period.vocab
                            .map((entry) => Chip(
                                  label: Text('${entry.key} = ${entry.value}'),
                                  visualDensity: VisualDensity.compact,
                                ))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizTab() {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _HistoryQuizTab(
          quiz: _quiz,
          random: _random,
          onRecord: _recordAnswer,
          quizNext: l10n.quizNext,
          quizGood: l10n.quizGood,
          quizWrong: l10n.quizWrong,
          quizScore: l10n.quizScore,
        ),
      ],
    );
  }
}

class _HistoryQuizTab extends StatefulWidget {
  const _HistoryQuizTab({
    required this.quiz,
    required this.random,
    required this.onRecord,
    required this.quizNext,
    required this.quizGood,
    required this.quizWrong,
    required this.quizScore,
  });

  final List<_HistoryQuiz> quiz;
  final Random random;
  final void Function(String itemId, bool correct) onRecord;
  final String quizNext;
  final String quizGood;
  final String quizWrong;
  final String Function(int score, int total) quizScore;

  @override
  State<_HistoryQuizTab> createState() => _HistoryQuizTabState();
}

class _HistoryQuizTabState extends State<_HistoryQuizTab> {
  late _HistoryQuiz _item;
  List<String> _options = [];
  int _correctIndex = 0;
  int _score = 0;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _nextItem();
  }

  void _nextItem() {
    final item = widget.quiz[widget.random.nextInt(widget.quiz.length)];
    final options = [...item.options]..shuffle(widget.random);
    setState(() {
      _item = item;
      _options = options;
      _correctIndex = options.indexOf(item.options[item.correct]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.quizScore(_score, _total),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        QuizRound(
          key: ValueKey(_item.id),
          question: _item.question,
          explanation: _item.explanation,
          options: _options,
          correctIndex: _correctIndex,
          goodLabel: widget.quizGood,
          wrongLabel: widget.quizWrong,
          nextLabel: widget.quizNext,
          onAnswered: (correct) {
            if (correct) _score++;
            _total++;
            widget.onRecord(_item.id, correct);
          },
          onNext: _nextItem,
        ),
      ],
    );
  }
}
