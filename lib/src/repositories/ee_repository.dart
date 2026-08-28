import 'package:parlami/src/data/models/ee_sentence.dart';
import 'package:parlami/src/services/asset_loader.dart';

class EERepository {
  final List<EESentence> _items = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final list = await AssetLoader.loadJsonListFast('assets/train/ee_sentences.json');
    for (final m in list) {
      _items.add(EESentence.fromJson(m));
    }
    _initialized = true;
  }

  List<EESentence> all({String? level}) {
    if (level == null) return List.unmodifiable(_items);
    return _items.where((s) => s.level == level).toList(growable: false);
  }

  EESentence? randomSentence({String? level}) {
    final filtered = all(level: level);
    if (filtered.isEmpty) return null;
    final mutable = List<EESentence>.from(filtered);
    mutable.shuffle();
    return mutable.first;
  }
}
