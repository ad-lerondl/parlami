import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';

import '../data/models/performance_attempt.dart';
import '../services/vocab_database.dart';

List<PerformanceAttempt> _decodePerformanceRecords(
  List<Map<String, dynamic>> payload,
) {
  return payload.map((entry) {
    final value = Map<String, dynamic>.from(entry['value'] as Map);
    return PerformanceAttempt.fromJson(
      value,
      idFallback: entry['key'] as String,
    );
  }).toList(growable: false);
}

class PerformanceRepository {
  PerformanceRepository._internal();

  static final PerformanceRepository _instance =
      PerformanceRepository._internal();

  factory PerformanceRepository() => _instance;

  static const _storeName = 'performance_attempts';

  final StoreRef<String, Map<String, dynamic>> _store =
      stringMapStoreFactory.store(_storeName);
  final List<PerformanceAttempt> _items = <PerformanceAttempt>[];
  late final List<PerformanceAttempt> _allView =
      UnmodifiableListView<PerformanceAttempt>(_items);

  Database? _database;
  bool _initialized = false;
  Future<void>? _initializing;
  int revision = 0;

  Future<void> init() {
    if (_initialized) return Future<void>.value();
    return _initializing ??= _initInternal().whenComplete(() {
      if (!_initialized) _initializing = null;
    });
  }

  Future<void> _initInternal() async {
    final totalTimer = Stopwatch()..start();
    _database = await openVocabDatabase();
    final queryTimer = Stopwatch()..start();
    final records = await _store.find(
      _database!,
      finder: Finder(sortOrders: <SortOrder>[SortOrder('recordedAt', false)]),
    );
    final queryMs = queryTimer.elapsedMilliseconds;
    final decodeTimer = Stopwatch()..start();
    final payload = records.map((record) => <String, dynamic>{
      'key': record.key,
      'value': record.value,
    }).toList(growable: false);

    final List<PerformanceAttempt> loaded = !kIsWeb && payload.length >= 1000
        ? await compute(
            _decodePerformanceRecords,
            payload,
            debugLabel: 'decodePerformanceRecords',
          )
        : _decodePerformanceRecords(payload);

    final decodeMs = decodeTimer.elapsedMilliseconds;
    _items
      ..clear()
      ..addAll(loaded);
    // Defensively preserve the repository's newest-first contract even if older
    // records lack a sortable recordedAt field in Sembast.
    _items.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    revision++;
    _initialized = true;
    if (kDebugMode) {
      debugPrint('[PerformanceRepository] query=${queryMs}ms (${records.length} records); '
          'decode=${decodeMs}ms; total=${totalTimer.elapsedMilliseconds}ms');
    }
  }

  /// Read-only live view that avoids copying the full event history on every read.
  List<PerformanceAttempt> all() => _allView;

  List<PerformanceAttempt> forSkill(String skill) => _items
      .where((attempt) => attempt.skill == skill)
      .toList(growable: false);

  Future<void> record(PerformanceAttempt attempt) async {
    if (!_initialized) await init();

    // Persist first. A failed write must not change the in-memory cache or its
    // revision, otherwise ResultsView can cache a state that was never saved.
    await _store.record(attempt.id).put(_database!, attempt.toJson());

    final existingIndex = _items.indexWhere((item) => item.id == attempt.id);
    if (existingIndex >= 0) _items.removeAt(existingIndex);

    // Insert into the newest-first list in O(n), avoiding an O(n log n) full
    // sort after every recorded answer.
    var low = 0;
    var high = _items.length;
    while (low < high) {
      final middle = (low + high) >> 1;
      if (_items[middle].recordedAt.isAfter(attempt.recordedAt)) {
        low = middle + 1;
      } else {
        high = middle;
      }
    }
    _items.insert(low, attempt);
    revision++;
  }
}
