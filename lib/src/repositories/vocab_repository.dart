import 'dart:math';
import 'dart:convert';

import 'package:sembast/sembast.dart';

import 'package:parlami/src/data/models/vocab_word.dart';
import 'package:parlami/src/services/asset_loader.dart';
import 'package:parlami/src/services/vocab_database.dart';

class VocabRepository {
  VocabRepository._internal();

  static final VocabRepository _instance = VocabRepository._internal();

  factory VocabRepository() => _instance;

  static const _storeName = 'vocab_words';
  static const _metaStoreName = 'vocab_meta';
  static const _bootstrapVersionKey = 'bootstrap_version';
  static const _schemaVersion = 2;
  static Future<List<VocabWord>>? _seedCache;
  final StoreRef<String, Map<String, dynamic>> _store = stringMapStoreFactory.store(_storeName);
  final StoreRef<String, Map<String, dynamic>> _metaStore = stringMapStoreFactory.store(_metaStoreName);

  final List<VocabWord> _items = [];
  final Map<String, VocabWord> _byId = {};
  final Map<VocabDifficulty, List<VocabWord>> _byDifficulty = {};
  final Map<VocabPartOfSpeech, List<VocabWord>> _byPartOfSpeech = {};
  final Map<String, List<VocabWord>> _byCategory = {};
  bool _initialized = false;
  Database? _database;

  Future<void> init() async {
    if (_initialized) return;
    _database = await openVocabDatabase();
    final bootstrapVersion = await _readBootstrapVersion();
    if (bootstrapVersion != _schemaVersion) {
      await _bootstrapDatabase();
      await _metaStore.record(_bootstrapVersionKey).put(_database!, {'version': _schemaVersion});
    }

    final records = await _store.find(_database!);
    final loaded =
        records.map((record) => VocabWord.fromJson(record.value, idFallback: record.key)).toList(growable: false);

    _rebuildCache(loaded);
    _initialized = true;
  }

  List<VocabWord> all() => List.unmodifiable(_items);

  List<VocabWord> filter(VocabFilter filter, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    Iterable<VocabWord> candidates = _items;

    if (filter.categories.isNotEmpty) {
      final categoryMatches = <VocabWord>{};
      for (final category in filter.categories) {
        categoryMatches.addAll(_byCategory[normalizeVocabText(category)] ?? const []);
      }
      candidates = categoryMatches;
    }

    if (filter.difficulties.isNotEmpty) {
      final difficultyMatches = <VocabWord>{};
      for (final difficulty in filter.difficulties) {
        difficultyMatches.addAll(_byDifficulty[difficulty] ?? const []);
      }
      candidates = candidates.where(difficultyMatches.contains);
    }

    if (filter.partsOfSpeech.isNotEmpty) {
      final partMatches = <VocabWord>{};
      for (final partOfSpeech in filter.partsOfSpeech) {
        partMatches.addAll(_byPartOfSpeech[partOfSpeech] ?? const []);
      }
      candidates = candidates.where(partMatches.contains);
    }

    candidates = candidates.where(filter.matches);
    final result = candidates.toList(growable: false);
    if (filter.masteryOrder) {
      result.sort((left, right) {
        final masteryCompare = left.masteryScore(reference).compareTo(right.masteryScore(reference));
        if (masteryCompare != 0) return masteryCompare;
        final reviewLeft = left.stats.lastReviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final reviewRight = right.stats.lastReviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return reviewLeft.compareTo(reviewRight);
      });
    } else {
      result.shuffle(Random());
    }
    return result;
  }

  List<String> allCategories() {
    final categories = _byCategory.keys.toList(growable: false)..sort();
    return categories;
  }

  List<VocabDifficulty> allDifficulties() => VocabDifficulty.values;

  List<VocabPartOfSpeech> allPartsOfSpeech() => VocabPartOfSpeech.values;

  VocabWord? byId(String id) => _byId[id];

  List<VocabWord> userWords() => _items.where((word) => word.source == VocabWordSource.user).toList(growable: false);

  Future<String> exportUserWordsJson() async {
    final payload = userWords().map((word) => word.toJson()).toList(growable: false);
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<List<VocabWord>> importWordsFromJsonString(String sourceJson) async {
    final decoded = jsonDecode(sourceJson);
    final rawItems = switch (decoded) {
      List<dynamic> list => list,
      Map<String, dynamic> map when map['words'] is List => map['words'] as List<dynamic>,
      _ => throw const FormatException('Le JSON doit être une liste de mots ou un objet contenant la clé "words".'),
    };

    final imported = rawItems.map((item) {
      if (item is! Map) {
        throw const FormatException('Chaque mot importé doit être un objet JSON.');
      }
      return VocabWord.fromJson(Map<String, dynamic>.from(item), idFallback: null)
          .copyWith(source: VocabWordSource.user);
    }).toList(growable: false);

    for (final word in imported) {
      await upsert(word);
    }
    return imported;
  }

  Future<void> resetOriginalWords() async {
    final seeded = await _seedFromAsset();
    final records = await _store.find(_database!);
    await _database!.transaction((transaction) async {
      for (final record in records) {
        final source = record.value['source']?.toString().trim().toLowerCase();
        if (source == VocabWordSource.original.name) {
          await _store.record(record.key).delete(transaction);
        }
      }

      for (final seed in seeded) {
        await _store.record(seed.id).put(
              transaction,
              _recordFor(seed.copyWith(
                source: VocabWordSource.original,
                stats: VocabReviewStats.initial(),
                updatedAt: DateTime.now(),
              )),
            );
      }
    });

    final refreshed = await _store.find(_database!);
    final reloaded =
        refreshed.map((record) => VocabWord.fromJson(record.value, idFallback: record.key)).toList(growable: false);
    _rebuildCache(reloaded);
  }

  Future<VocabWord> upsert(VocabWord word) async {
    final cleaned = word.copyWith(
      categories: word.categories
          .map((category) => category.trim().toLowerCase())
          .where((category) => category.isNotEmpty)
          .toSet()
          .toList(growable: false),
      updatedAt: DateTime.now(),
      source: word.source,
    );
    await _store.record(cleaned.id).put(_database!, _recordFor(cleaned));
    _replaceInCache(cleaned);
    return cleaned;
  }

  Future<void> remove(String id) async {
    await _store.record(id).delete(_database!);
    _removeFromCache(id);
  }

  Future<VocabWord?> markSeen(String id, {DateTime? now}) async {
    final word = _byId[id];
    if (word == null) return null;
    final updated = word.copyWith(stats: word.stats.seen(now ?? DateTime.now()), updatedAt: now ?? DateTime.now());
    await _store.record(updated.id).put(_database!, _recordFor(updated));
    _replaceInCache(updated);
    return updated;
  }

  Future<VocabWord?> review(String id, {required bool known, DateTime? now}) async {
    final word = _byId[id];
    if (word == null) return null;
    final updated =
        word.copyWith(stats: word.stats.recordReview(known, now ?? DateTime.now()), updatedAt: now ?? DateTime.now());
    await _store.record(updated.id).put(_database!, _recordFor(updated));
    _replaceInCache(updated);
    return updated;
  }

  Future<List<VocabWord>> _seedFromAsset() async {
    _seedCache ??= _loadSeedFromAsset();
    return _seedCache!;
  }

  Future<List<VocabWord>> _loadSeedFromAsset() async {
    const files = [
      'assets/vocabulaire/vocab_apprendreitalien-vocabulaire.json',
      'assets/vocabulaire/vocab_apprendreitalien-expressions.json',
      'assets/vocabulaire/vocab_mistral-slang.json',
    ];

    final allItems = <Map<String, dynamic>>[];

    for (final file in files) {
      allItems.addAll(await AssetLoader.loadJsonListFast(file));
    }

    return allItems
        .map((item) => VocabWord.fromJson(item).copyWith(
              source: VocabWordSource.original,
            ))
        .toList(growable: false);
  }

  Future<int?> _readBootstrapVersion() async {
    final metadata = await _metaStore.record(_bootstrapVersionKey).get(_database!);
    if (metadata is! Map<String, dynamic>) return null;
    return (metadata['version'] as num?)?.toInt();
  }

  Future<void> _bootstrapDatabase() async {
    final seeded = await _seedFromAsset();
    final records = await _store.find(_database!);
    if (records.isEmpty) {
      await _database!.transaction((transaction) async {
        for (final seed in seeded) {
          await _store.record(seed.id).put(transaction, _recordFor(seed));
        }
      });
      return;
    }

    final seededById = {for (final word in seeded) word.id: word};
    final loadedById = <String>{};
    await _database!.transaction((transaction) async {
      for (final record in records) {
        final word = VocabWord.fromJson(record.value, idFallback: record.key);
        loadedById.add(word.id);
        if (!record.value.containsKey('source')) {
          final normalizedSource = seededById.containsKey(word.id) ? VocabWordSource.original : VocabWordSource.user;
          await _store.record(record.key).put(transaction, _recordFor(word.copyWith(source: normalizedSource)));
        }
      }

      for (final seed in seeded) {
        if (!loadedById.contains(seed.id)) {
          await _store.record(seed.id).put(transaction, _recordFor(seed));
        }
      }
    });
  }

  Map<String, dynamic> _recordFor(VocabWord word) {
    final record = word.toJson();
    record['schemaVersion'] = _schemaVersion;
    return record;
  }

  void _rebuildCache(List<VocabWord> items) {
    final snapshot = List<VocabWord>.from(items, growable: false);
    _items
      ..clear()
      ..addAll(snapshot);
    _byId.clear();
    _byDifficulty.clear();
    _byPartOfSpeech.clear();
    _byCategory.clear();
    for (final word in snapshot) {
      _byId[word.id] = word;
      (_byDifficulty[word.difficulty] ??= []).add(word);
      (_byPartOfSpeech[word.partOfSpeech] ??= []).add(word);
      for (final category in word.categories) {
        (_byCategory[normalizeVocabText(category)] ??= []).add(word);
      }
    }
  }

  Future<void> replaceWithOriginalSeed() async {
    await resetOriginalWords();
  }

  void _replaceInCache(VocabWord word) {
    _byId[word.id] = word;
    _items.removeWhere((item) => item.id == word.id);
    _items.add(word);
    _rebuildCache(_items);
  }

  void _removeFromCache(String id) {
    _items.removeWhere((item) => item.id == id);
    _rebuildCache(_items);
  }
}
