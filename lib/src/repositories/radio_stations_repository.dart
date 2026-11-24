import 'package:parlami/src/data/models/radio_station.dart';
import 'package:parlami/src/services/asset_loader.dart';

class RadioStationsRepository {
  RadioStationsRepository._internal();

  static final RadioStationsRepository _instance =
      RadioStationsRepository._internal();

  factory RadioStationsRepository() => _instance;

  static const _assetPath = 'assets/radio/stations.json';

  final List<RadioStation> _items = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final list = await AssetLoader.loadJsonListFast(_assetPath);
    for (final entry in list) {
      _items.add(RadioStation.fromJson(entry));
    }
    _initialized = true;
  }

  List<RadioStation> all() => List.unmodifiable(_items);
}
