import 'package:sembast/sembast.dart';

import '../data/models/performance_attempt.dart';
import '../services/vocab_database.dart';

class PerformanceRepository {
  PerformanceRepository._internal();

  static final PerformanceRepository _instance = PerformanceRepository._internal();

  factory PerformanceRepository() => _instance;

  static const _storeName = 'performance_attempts';
  final StoreRef<String, Map<String, dynamic>> _store = stringMapStoreFactory.store(_storeName);
  final List<PerformanceAttempt> _items = [];
  Database? _database;
  bool _initialized = false;
  int revision = 0;

  Future<void> init() async {
    if (_initialized) return;
    _database = await openVocabDatabase();
    final records = await _store.find(_database!, finder: Finder(sortOrders: [SortOrder('recordedAt', false)]));
    _items
      ..clear()
      ..addAll(records.map((record) => PerformanceAttempt.fromJson(record.value, idFallback: record.key)));
    revision++;
    _initialized = true;
  }

  List<PerformanceAttempt> all() => List.unmodifiable(_items);

  List<PerformanceAttempt> forSkill(String skill) =>
      _items.where((attempt) => attempt.skill == skill).toList(growable: false);

  Future<void> record(PerformanceAttempt attempt) async {
    if (!_initialized) await init();
    revision++;
    await _store.record(attempt.id).put(_database!, attempt.toJson());
    _items.removeWhere((item) => item.id == attempt.id);
    _items.add(attempt);
    _items.sort((left, right) => right.recordedAt.compareTo(left.recordedAt));
  }
}
