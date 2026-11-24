import 'dart:math';

import 'package:parlami/src/data/models/grammar_question.dart';
import 'package:parlami/src/services/asset_loader.dart';

class GrammarRepository {
  GrammarRepository._internal();

  static final GrammarRepository _instance = GrammarRepository._internal();

  factory GrammarRepository() => _instance;

  static const _assetPath = 'assets/grammar/grammar_questions.json';

  final List<GrammarQuestion> _items = [];
  bool _initialized = false;
  List<String>? _topicCache;

  Future<void> init() async {
    if (_initialized) return;
    final list = await AssetLoader.loadJsonListFast(_assetPath);
    for (final entry in list) {
      _items.add(GrammarQuestion.fromJson(entry));
    }
    _initialized = true;
  }

  List<GrammarQuestion> all({String? topic, String? level}) {
    return _items
        .where((question) =>
            (topic == null || question.topic == topic) &&
            (level == null || question.level == level))
        .toList(growable: false);
  }

  List<String> topics() {
    if (_topicCache != null) return _topicCache!;
    final seen = <String>{};
    final topics = _items
        .where((question) => seen.add(question.topic))
        .map((question) => question.topic)
        .toList(growable: false);
    return _topicCache = topics;
  }

  List<GrammarQuestion> randomQuestions({
    required int count,
    String? topic,
    Random? random,
  }) {
    final filtered = all(topic: topic);
    final mutable = List<GrammarQuestion>.from(filtered)..shuffle(random);
    return mutable.take(count).toList(growable: false);
  }

  int get totalCount => _items.length;
}
