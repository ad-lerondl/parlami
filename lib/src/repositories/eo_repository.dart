import 'package:parlami/src/data/models/eo_question.dart';
import 'package:parlami/src/services/asset_loader.dart';

class EORepository {
  final List<EOQuestion> _items = [];
  final Map<String, EOQuestion> _byId = {};
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final list = await AssetLoader.loadJsonListFast('assets/train/eo_questions.json');
    for (final m in list) {
      final q = EOQuestion.fromJson(m);
      _items.add(q);
      _byId[q.id] = q;
    }
    _initialized = true;
  }

  List<EOQuestion> all({String? level, bool startableOnly = false}) {
    Iterable<EOQuestion> it = _items;
    if (level != null) it = it.where((q) => q.level == level);
    if (startableOnly) it = it.where((q) => q.startable);
    return it.toList(growable: false);
  }

  EOQuestion? randomQuestion({String? level, bool startableOnly = false}) {
    final filtered = all(level: level, startableOnly: startableOnly);
    if (filtered.isEmpty) return null;
    final mutable = List<EOQuestion>.from(filtered);
    mutable.shuffle();
    return mutable.first;
  }

  EOQuestion? byId(String id) => _byId[id];
}
