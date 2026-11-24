import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/quiz_round.dart';
import '../../data/models/performance_attempt.dart';
import '../../localization/app_localizations.dart';
import '../../repositories/performance_repository.dart';
import '../../services/asset_loader.dart';
import '../../services/study_session_tracker.dart';

class _Region {
  const _Region(this.id, this.name, this.fr, this.capital, this.stereotype, this.specialties);

  final String id;
  final String name;
  final String fr;
  final String capital;
  final String stereotype;
  final List<_Specialty> specialties;
}

class _Specialty {
  const _Specialty(this.it, this.fr);

  final String it;
  final String fr;
}

class _City {
  const _City(this.id, this.it, this.fr, this.region, this.note);

  final String id;
  final String it;
  final String fr;
  final String region;
  final String note;
}

class GeoView extends StatefulWidget {
  const GeoView({super.key});

  @override
  State<GeoView> createState() => _GeoViewState();
}

class _GeoViewState extends State<GeoView> {
  final Random _random = Random();
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  final String _sessionId = DateTime.now().microsecondsSinceEpoch.toString();

  final List<_Region> _regions = [];
  final List<_City> _cities = [];
  String _filter = '';

  bool _loaded = false;

  _Region _regionOf(String id) =>
      _regions.firstWhere((region) => region.id == id, orElse: () => _regions.first);

  @override
  void initState() {
    super.initState();
    StudySessionTracker.instance.start('geo');
    _load();
  }

  @override
  void dispose() {
    StudySessionTracker.instance.stop();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await AssetLoader.loadJson('assets/culture/geo_italia.json')
        as Map<String, dynamic>;
    final regions = (data['regions'] as List).cast<Map<String, dynamic>>();
    final cities = (data['cities'] as List).cast<Map<String, dynamic>>();
    if (!mounted) return;
    setState(() {
      _regions
        ..clear()
        ..addAll(regions.map(_parseRegion));
      _cities
        ..clear()
        ..addAll(cities.map(_parseCity));
      _loaded = true;
    });
  }

  _Region _parseRegion(Map<String, dynamic> raw) {
    final specialties =
        (raw['specialties'] as List).cast<Map<String, dynamic>>();
    return _Region(
      raw['id'] as String,
      raw['name'] as String,
      raw['fr'] as String,
      raw['capital'] as String,
      raw['stereotype'] as String? ?? '',
      specialties
          .map((entry) => _Specialty(entry['it'] as String, entry['fr'] as String))
          .toList(growable: false),
    );
  }

  _City _parseCity(Map<String, dynamic> raw) {
    return _City(
      raw['id'] as String,
      raw['it'] as String,
      raw['fr'] as String,
      raw['region'] as String,
      raw['note'] as String? ?? '',
    );
  }

  List<_City> get _filteredCities {
    final query = _filter.trim().toLowerCase();
    if (query.isEmpty) return _cities;
    return _cities
        .where((city) =>
            city.it.toLowerCase().contains(query) ||
            city.fr.toLowerCase().contains(query) ||
            _regionOf(city.region).fr.toLowerCase().contains(query))
        .toList(growable: false);
  }

  void _recordAnswer(String itemId, bool correct) {
    _performanceRepository.record(PerformanceAttempt(
      id: 'geo_${itemId}_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: _sessionId,
      skill: 'geo',
      exerciseType: 'geo_region',
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.learnGeo),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.geoTabRegions),
              Tab(text: l10n.geoTabCities),
              Tab(text: l10n.geoTabQuiz),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRegionsTab(),
            _buildCitiesTab(),
            _GeoQuizTab(
              regions: _regions,
              cities: _cities,
              random: _random,
              onAnswered: _recordAnswer,
              quizNext: l10n.quizNext,
              quizGood: l10n.quizGood,
              quizWrong: l10n.quizWrong,
              quizScore: (score, total) => l10n.quizScore(score, total),
              cityQuestion: (city) => l10n.geoQuizCity(city),
              specialtyQuestion: (specialty) => l10n.geoQuizSpecialty(specialty),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionsTab() {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      children: _regions.map((region) {
        final capitalCity = _cities.cast<_City?>().firstWhere(
              (city) => city!.region == region.id && (city.it == region.capital || city.id == region.id),
              orElse: () => null,
            );
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ExpansionTile(
            title: Text('${region.name} (${region.fr})'),
            subtitle: Text('${l10n.geoCapital}: ${region.capital}'),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('« ${region.stereotype} »',
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(height: 8),
                    if (capitalCity != null) ...[
                      Text('• ${capitalCity.it} (${capitalCity.fr}) : ${capitalCity.note}'),
                      const SizedBox(height: 8),
                    ],
                    Text('${l10n.geoSpecialties}:',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    ...region.specialties.map(
                      (specialty) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('• ${specialty.it} — ${specialty.fr}'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCitiesTab() {
    final l10n = AppLocalizations.of(context)!;
    final cities = _filteredCities;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.geoSearchCities,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _filter = value),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: cities.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final city = cities[index];
              final region = _regionOf(city.region);
              return ListTile(
                title: Text('${city.it} (${city.fr})'),
                subtitle: Text('${region.name} — ${city.note}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GeoQuizTab extends StatefulWidget {
  const _GeoQuizTab({
    required this.regions,
    required this.cities,
    required this.random,
    required this.onAnswered,
    required this.quizNext,
    required this.quizGood,
    required this.quizWrong,
    required this.quizScore,
    required this.cityQuestion,
    required this.specialtyQuestion,
  });

  final List<_Region> regions;
  final List<_City> cities;
  final Random random;
  final void Function(String itemId, bool correct) onAnswered;
  final String quizNext;
  final String quizGood;
  final String quizWrong;
  final String Function(int score, int total) quizScore;
  final String Function(String city) cityQuestion;
  final String Function(String specialty) specialtyQuestion;

  @override
  State<_GeoQuizTab> createState() => _GeoQuizTabState();
}

class _GeoQuizTabState extends State<_GeoQuizTab> {
  late _QuizItem _item;
  int _score = 0;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _item = _buildItem();
  }

  List<String> _wrongRegions(String correctRegionId) {
    final pool = widget.regions.where((region) => region.id != correctRegionId).toList()
      ..shuffle(widget.random);
    return pool.take(3).map((region) => region.id).toList();
  }

  List<String> _shuffledIds(List<String> wrongIds, String correctId) {
    final ids = [correctId, ...wrongIds]..shuffle(widget.random);
    return ids;
  }

  _QuizItem _buildItem() {
    final useCity = widget.random.nextBool();
    final String correctId;
    String question;
    String explanation;
    String itemId;
    if (useCity) {
      final city = widget.cities[widget.random.nextInt(widget.cities.length)];
      correctId = city.region;
      question = widget.cityQuestion(city.it);
      explanation = '${widget.regions.firstWhere((r) => r.id == city.region).fr} — ${city.note}';
      itemId = 'city_${city.id}';
    } else {
      final region = widget.regions[widget.random.nextInt(widget.regions.length)];
      final specialty = region.specialties[widget.random.nextInt(region.specialties.length)];
      correctId = region.id;
      question = widget.specialtyQuestion(specialty.it);
      explanation = '${region.fr} : ${specialty.it} — ${specialty.fr}';
      itemId = 'specialty_${region.id}_${specialty.it}';
    }

    final wrongIds = _wrongRegions(correctId);
    final ids = _shuffledIds(wrongIds, correctId);
    return _QuizItem(
      question: question,
      options: ids
          .map((id) => widget.regions.firstWhere((r) => r.id == id).fr)
          .toList(growable: false),
      correctIndex: ids.indexOf(correctId),
      explanation: explanation,
      itemId: itemId,
    );
  }

  void _next() {
    setState(() {
      _item = _buildItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          widget.quizScore(_score, _total),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        QuizRound(
          key: ValueKey(_item.question),
          question: _item.question,
          explanation: _item.explanation,
          options: _item.options,
          correctIndex: _item.correctIndex,
          goodLabel: widget.quizGood,
          wrongLabel: widget.quizWrong,
          nextLabel: widget.quizNext,
          onAnswered: (correct) {
            if (correct) _score++;
            _total++;
            widget.onAnswered(_item.itemId, correct);
          },
          onNext: _next,
        ),
      ],
    );
  }
}

class _QuizItem {
  const _QuizItem({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.itemId,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String itemId;
}
