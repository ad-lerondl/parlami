import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/quiz_round.dart';
import '../../data/models/performance_attempt.dart';
import '../../localization/app_localizations.dart';
import '../../repositories/performance_repository.dart';
import '../../services/asset_loader.dart';
import '../../services/study_session_tracker.dart';

class PastaShape {
  const PastaShape(this.id, this.it, this.region, this.shape, this.sauce, this.fact, this.regional);

  final String id;
  final String it;
  final String region;
  final String shape;
  final String sauce;
  final String fact;
  final bool regional;
}

class PastaView extends StatefulWidget {
  const PastaView({super.key});

  @override
  State<PastaView> createState() => _PastaViewState();
}

class _PastaViewState extends State<PastaView> {
  final Random _random = Random();
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  final String _sessionId = DateTime.now().microsecondsSinceEpoch.toString();

  final List<PastaShape> _shapes = [];
  Map<String, String> _regionNames = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    StudySessionTracker.instance.start('pasta');
    _load();
  }

  @override
  void dispose() {
    StudySessionTracker.instance.stop();
    super.dispose();
  }

  Future<void> _load() async {
    final pastaData =
        await AssetLoader.loadJson('assets/culture/pasta_italia.json') as Map<String, dynamic>;
    final geoData = await AssetLoader.loadJson('assets/culture/geo_italia.json') as Map<String, dynamic>;
    final shapes = (pastaData['shapes'] as List).cast<Map<String, dynamic>>();
    final regions = (geoData['regions'] as List).cast<Map<String, dynamic>>();
    if (!mounted) return;
    setState(() {
      _shapes
        ..clear()
        ..addAll(shapes.map((raw) => PastaShape(
              raw['id'] as String,
              raw['it'] as String,
              raw['region'] as String,
              raw['shape'] as String? ?? '',
              raw['sauce'] as String? ?? '',
              raw['fact'] as String? ?? '',
              raw['regional'] as bool? ?? false,
            )));
      _regionNames = {
        for (final region in regions)
          region['id'] as String: '${region['name'] as String} (${region['fr'] as String})',
      };
      _loaded = true;
    });
  }

  void _recordAnswer(String itemId, bool correct) {
    _performanceRepository.record(PerformanceAttempt(
      id: 'pasta_${itemId}_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: _sessionId,
      skill: 'pasta',
      exerciseType: 'pasta_region',
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
          title: Text(l10n.learnPasta),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.pastaTabExplore),
              Tab(text: l10n.pastaTabQuiz),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildExploreTab(),
            _buildQuizTab(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _shapes.map((shape) {
        final region = _regionNames[shape.region] ?? shape.region;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(shape.it, style: Theme.of(context).textTheme.titleMedium),
                    ),
                    if (shape.regional)
                      Chip(
                        label: Text(region),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                if (shape.shape.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(shape.shape),
                ],
                if (shape.sauce.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('🥫 ${shape.sauce}'),
                ],
                if (shape.fact.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    shape.fact,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuizTab(AppLocalizations l10n) {
    final quizShapes = _shapes.where((shape) => shape.regional).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.pastaQuizIntro,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        _PastaQuiz(
          shapes: quizShapes,
          regionNames: _regionNames,
          random: _random,
          onRecord: _recordAnswer,
          quizNext: l10n.quizNext,
          quizGood: l10n.quizGood,
          quizWrong: l10n.quizWrong,
          quizScore: l10n.quizScore,
          questionBuilder: (name) => l10n.pastaQuizQuestion(name),
        ),
      ],
    );
  }
}

class _PastaQuiz extends StatefulWidget {
  const _PastaQuiz({
    required this.shapes,
    required this.regionNames,
    required this.random,
    required this.onRecord,
    required this.quizNext,
    required this.quizGood,
    required this.quizWrong,
    required this.quizScore,
    required this.questionBuilder,
  });

  final List<PastaShape> shapes;
  final Map<String, String> regionNames;
  final Random random;
  final void Function(String itemId, bool correct) onRecord;
  final String quizNext;
  final String quizGood;
  final String quizWrong;
  final String Function(int score, int total) quizScore;
  final String Function(String pastaName) questionBuilder;

  @override
  State<_PastaQuiz> createState() => _PastaQuizState();
}

class _PastaQuizState extends State<_PastaQuiz> {
  late PastaShape _shape;
  late List<String> _options;
  late int _correctIndex;
  int _score = 0;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _nextShape();
  }

  void _nextShape() {
    final shape = widget.shapes[widget.random.nextInt(widget.shapes.length)];
    final otherRegions =
        widget.regionNames.keys.where((region) => region != shape.region).toList()
          ..shuffle(widget.random);
    final ids = [shape.region, ...otherRegions.take(3)]..shuffle(widget.random);
    setState(() {
      _shape = shape;
      _options = ids.map((id) => widget.regionNames[id] ?? id).toList(growable: false);
      _correctIndex = ids.indexOf(shape.region);
    });
  }

  @override
  Widget build(BuildContext context) {
    final shape = _shape;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.quizScore(_score, _total),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        QuizRound(
          key: ValueKey(shape.id),
          question: widget.questionBuilder(shape.it),
          explanation: [
            if (shape.shape.isNotEmpty) shape.shape,
            if (shape.sauce.isNotEmpty) 'Avec : ${shape.sauce}',
            if (shape.fact.isNotEmpty) shape.fact,
          ].join(' • '),
          options: _options,
          correctIndex: _correctIndex,
          goodLabel: widget.quizGood,
          wrongLabel: widget.quizWrong,
          nextLabel: widget.quizNext,
          onAnswered: (correct) {
            if (correct) _score++;
            _total++;
            widget.onRecord(shape.id, correct);
          },
          onNext: _nextShape,
        ),
      ],
    );
  }
}
