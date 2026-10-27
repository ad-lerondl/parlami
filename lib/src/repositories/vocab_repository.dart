import 'dart:math';

import 'dart:convert';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:sembast/sembast.dart';

import 'package:parlami/src/data/models/vocab_word.dart';

import 'package:parlami/src/services/vocab_database.dart';
import 'package:parlami/src/services/vocab_pack_service.dart';

List<VocabWord> _decodeVocabRecords(List<Map<String, dynamic>> payload) {
  return payload.map((entry) {
    final value = Map<String, dynamic>.from(entry['value'] as Map);
    return VocabWord.fromJson(value, idFallback: entry['key'] as String);
  }).toList(growable: false);
}

class VocabRepository {
  VocabRepository._internal();

  static final VocabRepository _instance = VocabRepository._internal();

  factory VocabRepository() => _instance;

  static const _storeName = 'vocab_words';

  static const _metaStoreName = 'vocab_meta';

  static const _bootstrapVersionKey = 'bootstrap_version';

  static const _schemaVersion = 2;

  final StoreRef<String, Map<String, dynamic>> _store = stringMapStoreFactory.store(_storeName);

  final StoreRef<String, Map<String, dynamic>> _metaStore = stringMapStoreFactory.store(_metaStoreName);

  final StoreRef<String, Map<String, dynamic>> _wordsStore = stringMapStoreFactory.store('words');
  final StoreRef<String, Map<String, dynamic>> _sensesStore = stringMapStoreFactory.store('senses');
  final StoreRef<String, Map<String, dynamic>> _examplesStore = stringMapStoreFactory.store('examples');
  final StoreRef<String, Map<String, dynamic>> _packsStore = stringMapStoreFactory.store('packs');
  final StoreRef<String, Map<String, dynamic>> _packWordsStore = stringMapStoreFactory.store('pack_words');
  final StoreRef<String, Map<String, dynamic>> _cardsStore = stringMapStoreFactory.store('cards');
  final StoreRef<String, Map<String, dynamic>> _reviewLogStore = stringMapStoreFactory.store('review_log');

  final List<VocabWord> _items = [];
  late final List<VocabWord> _allView = UnmodifiableListView<VocabWord>(_items);

  final Map<String, VocabWord> _byId = {};

  final Map<VocabDifficulty, List<VocabWord>> _byDifficulty = {};

  final Map<VocabPartOfSpeech, List<VocabWord>> _byPartOfSpeech = {};

  final Map<String, List<VocabWord>> _byCategory = {};

  bool _initialized = false;
  Future<void>? _initializing;
  Database? _database;
  int revision = 0;

  Future<void> init() {
    if (_initialized) return Future<void>.value();
    return _initializing ??= _initInternal().whenComplete(() {
      if (!_initialized) _initializing = null;
    });
  }

  Future<void> _initInternal() async {
    final totalTimer = Stopwatch()..start();
    final openTimer = Stopwatch()..start();
    _database = await openVocabDatabase();
    final openMs = openTimer.elapsedMilliseconds;
    final bootstrapTimer = Stopwatch()..start();
    final bootstrapVersion = await _readBootstrapVersion();
    if (bootstrapVersion != _schemaVersion) {
      await _bootstrapDatabase();
      await _metaStore.record(_bootstrapVersionKey).put(_database!, {'version': _schemaVersion});
    }
    final bootstrapMs = bootstrapTimer.elapsedMilliseconds;

    final queryTimer = Stopwatch()..start();
    final records = await _store.find(_database!);
    final queryMs = queryTimer.elapsedMilliseconds;
    final payload = records
        .map((record) => <String, dynamic>{
              'key': record.key,
              'value': record.value,
            })
        .toList(growable: false);
    // Large record sets are decoded off the UI isolate on native Flutter.
    // On web compute runs on the current isolate, so avoid its extra overhead.
    final List<VocabWord> loaded = !kIsWeb && payload.length >= 1000
        ? await compute(_decodeVocabRecords, payload, debugLabel: 'decodeVocabRecords')
        : _decodeVocabRecords(payload);

    final indexTimer = Stopwatch()..start();
    _rebuildCache(loaded);
    final indexMs = indexTimer.elapsedMilliseconds;
    revision++;
    _initialized = true;
    if (kDebugMode) {
      debugPrint('[VocabRepository] open=${openMs}ms; bootstrap=${bootstrapMs}ms; '
          'query=${queryMs}ms (${records.length} records); index=${indexMs}ms; '
          'total=${totalTimer.elapsedMilliseconds}ms');
    }
  }

  /// Read-only live view; does not copy the entire vocabulary for every caller.
  List<VocabWord> all() => _allView;

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

  List<VocabWord> userWords() => _items.where((word) => word.source != VocabWordSource.original).toList(growable: false);

  Future<int> importPack(VocabPack pack) async {
    if (!_initialized) await init();
    final now = DateTime.now();
    final imported = <VocabWord>[];
    await _database!.transaction((transaction) async {
      await _upsertRegistry(pack.registry, transaction);
      await _packsStore.record(pack.summary.id).put(transaction, {
        'id': pack.summary.id,
        'json_content': pack.content,
        'registry_version': pack.registry.version,
      });
      for (final item in pack.words) {
        final senseId = item['sense_id']?.toString() ?? '';
        final sense = pack.registry.senses[senseId];
        if (sense == null) {
          throw FormatException('Le sens $senseId est absent du registre.');
        }
        final packWordKey = '${pack.summary.id}:$senseId';
        await _packWordsStore.record(packWordKey).put(transaction, {
          'pack_id': pack.summary.id,
          'sense_id': senseId,
          'hint': item['hint'],
        });
        for (final direction in const ['IT_FR', 'FR_IT', 'LISTEN']) {
          final cardId = '$senseId#$direction';
          await _cardsStore.record(cardId).put(transaction, {
            'id': cardId,
            'sense_id': senseId,
            'direction': direction,
            'fsrs_state': VocabReviewStats.initial().toJson(),
            'due_at': null,
          }, merge: true);
        }
        final word = pack.registry.words[sense.wordId];
        if (word == null) continue;
        imported.add(_wordFromRegistry(pack, item, word, sense, now));
      }
    });
    for (final word in imported) {
      await upsert(word);
    }
    return imported.length;
  }

  Future<void> _upsertRegistry(VocabRegistry registry, Transaction transaction) async {
    for (final word in registry.words.values) {
      await _wordsStore.record(word.wordId).put(transaction, {
        'word_id': word.wordId,
        'lemma': word.lemma,
        'pos': word.pos,
        'gender': word.gender,
        'ipa': word.ipa,
        'cefr': word.cefr,
        'freq_rank': word.freqRank,
      });
    }
    for (final sense in registry.senses.values) {
      await _sensesStore.record(sense.senseId).put(transaction, {
        'sense_id': sense.senseId,
        'word_id': sense.wordId,
        'gloss': sense.gloss,
        'translations': sense.translations,
      });
      for (final example in sense.examples) {
        final exampleId = example['id']?.toString();
        if (exampleId != null && exampleId.isNotEmpty) {
          await _examplesStore.record(exampleId).put(transaction, {
            ...example,
            'sense_id': sense.senseId,
          });
        }
      }
    }
  }

  VocabWord _wordFromRegistry(
    VocabPack pack,
    Map<String, dynamic> item,
    VocabRegistryWord word,
    VocabRegistrySense sense,
    DateTime now,
  ) {
    final existing = _byId[sense.senseId];
    return VocabWord.fromJson({
      'id': sense.senseId,
      'lemma': word.lemma,
      'pos': word.pos,
      'gender': word.gender,
      'ipa': word.ipa,
      'cefr': item['cefr'] ?? word.cefr,
      'translations': {pack.summary.toLanguage: sense.translations},
      'glosses': [sense.gloss],
      'from': pack.summary.fromLanguage,
      'to': pack.summary.toLanguage,
      'categories': pack.summary.themeTags,
      'source': VocabWordSource.remotePack.name,
      'packId': pack.summary.id,
      'createdAt': existing?.createdAt.toIso8601String() ?? now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'stats': existing?.stats.toJson(),
    }).copyWith(
      source: VocabWordSource.remotePack,
      packId: pack.summary.id,
      createdAt: existing?.createdAt,
      stats: existing?.stats,
    );
  }

  bool hasPack(String packId) => _items.any(
        (word) => word.source == VocabWordSource.remotePack &&
            (word.packId == packId || word.id.startsWith('$packId:')),
      );

  Future<int> removePack(String packId) async {
    if (!_initialized) await init();
    final records = await _packWordsStore.find(_database!);
    final senseIds = records
        .where((record) => record.value['pack_id']?.toString() == packId)
        .map((record) => record.value['sense_id']?.toString() ?? '')
        .where((senseId) => senseId.isNotEmpty)
        .toSet();
    var removed = 0;
    await _database!.transaction((transaction) async {
      for (final record in records) {
        if (record.value['pack_id']?.toString() == packId) {
          await _store.record(record.key).delete(transaction);
          await _packWordsStore.record(record.key).delete(transaction);
          removed++;
        }
      }
      await _packsStore.record(packId).delete(transaction);
    });
    if (removed == 0) return 0;
    for (final senseId in senseIds) {
      final remaining = await _packWordsStore.find(
        _database!,
        finder: Finder(filter: Filter.equals('sense_id', senseId)),
      );
      if (remaining.isEmpty) await _store.record(senseId).delete(_database!);
    }
    await _removeLegacyPackFacades(packId);
    await _reloadFromDatabase();
    return removed;
  }

  Future<int> removeAllPacks() async {
    if (!_initialized) await init();
    final records = await _packWordsStore.find(_database!);
    var removed = 0;
    await _database!.transaction((transaction) async {
      for (final record in records) {
        await _packWordsStore.record(record.key).delete(transaction);
        removed++;
      }
      final packs = await _packsStore.find(transaction);
      for (final pack in packs) {
        await _packsStore.record(pack.key).delete(transaction);
      }
    });
    if (removed == 0) return 0;
    final facades = await _store.find(_database!);
    await _database!.transaction((transaction) async {
      for (final record in facades) {
        if (record.value['source']?.toString().trim().toLowerCase() == VocabWordSource.remotePack.name) {
          await _store.record(record.key).delete(transaction);
        }
      }
    });
    await _reloadFromDatabase();
    return removed;
  }

  Future<void> _removeLegacyPackFacades(String packId) async {
    final facades = await _store.find(_database!);
    for (final record in facades) {
      if (record.key.startsWith('$packId:')) await _store.record(record.key).delete(_database!);
    }
  }

  Future<String> exportUserWordsJson() async {
    final payload = userWords().map((word) => word.toJson()).toList(growable: false);

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<void> _reloadFromDatabase() async {
    final refreshed = await _store.find(_database!);
    _rebuildCache(
      refreshed.map((record) => VocabWord.fromJson(record.value, idFallback: record.key)).toList(growable: false),
    );
    revision++;
  }

  Future<VocabWord> upsert(VocabWord word) async {
    if (!_initialized) await init();

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
    if (!_initialized) await init();

    await _store.record(id).delete(_database!);

    _removeFromCache(id);
  }

  Future<VocabWord?> markSeen(String id, {DateTime? now}) async {
    if (!_initialized) await init();

    final word = _byId[id];

    if (word == null) return null;

    final updated = word.copyWith(stats: word.stats.seen(now ?? DateTime.now()), updatedAt: now ?? DateTime.now());

    await _store.record(updated.id).put(_database!, _recordFor(updated));

    _replaceInCache(updated);

    return updated;
  }

  Future<VocabWord?> review(String id, {required bool known, DateTime? now}) async {
    if (!_initialized) await init();

    final word = _byId[id];

    if (word == null) return null;

    final updated =
        word.copyWith(stats: word.stats.recordReview(known, now ?? DateTime.now()), updatedAt: now ?? DateTime.now());

    await _store.record(updated.id).put(_database!, _recordFor(updated));
    final reviewedAt = now ?? DateTime.now();
    final cardId = '${updated.id}#IT_FR';
    await _cardsStore.record(cardId).put(_database!, {
      'id': cardId,
      'sense_id': updated.id,
      'direction': 'IT_FR',
      'fsrs_state': updated.stats.toJson(),
      'due_at': null,
    });
    await _reviewLogStore.record('${updated.id}:$reviewedAt').put(_database!, {
      'sense_id': updated.id,
      'direction': 'IT_FR',
      'known': known,
      'reviewed_at': reviewedAt.toIso8601String(),
    });

    _replaceInCache(updated);

    return updated;
  }

  Future<int?> _readBootstrapVersion() async {
    final metadata = await _metaStore.record(_bootstrapVersionKey).get(_database!);

    if (metadata is! Map<String, dynamic>) return null;

    return (metadata['version'] as num?)?.toInt();
  }

  Future<void> _bootstrapDatabase() async {
    final records = await _store.find(_database!);

    await _database!.transaction((transaction) async {
      for (final record in records) {
        final value = Map<String, dynamic>.from(record.value);
        if (!value.containsKey('source')) {
          value['source'] = VocabWordSource.user.name;
          value['schemaVersion'] = _schemaVersion;
          await _store.record(record.key).put(transaction, value);
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

  void _replaceInCache(VocabWord word) {
    final previous = _byId[word.id];
    if (previous != null) {
      _removeFromIndexes(previous);
      final index = _items.indexWhere((item) => item.id == word.id);
      if (index >= 0) {
        _items[index] = word;
      } else {
        _items.add(word);
      }
    } else {
      _items.add(word);
    }
    _addToIndexes(word);
    revision++;
  }

  void _removeFromCache(String id) {
    final previous = _byId[id];
    if (previous == null) return;
    _removeFromIndexes(previous);
    _items.removeWhere((item) => item.id == id);
    revision++;
  }

  void _addToIndexes(VocabWord word) {
    _byId[word.id] = word;
    (_byDifficulty[word.difficulty] ??= <VocabWord>[]).add(word);
    (_byPartOfSpeech[word.partOfSpeech] ??= <VocabWord>[]).add(word);
    for (final category in word.categories) {
      (_byCategory[normalizeVocabText(category)] ??= <VocabWord>[]).add(word);
    }
  }

  void _removeFromIndexes(VocabWord word) {
    _byId.remove(word.id);
    final difficultyList = _byDifficulty[word.difficulty];
    difficultyList?.remove(word);
    if (difficultyList != null && difficultyList.isEmpty) {
      _byDifficulty.remove(word.difficulty);
    }
    final partList = _byPartOfSpeech[word.partOfSpeech];
    partList?.remove(word);
    if (partList != null && partList.isEmpty) {
      _byPartOfSpeech.remove(word.partOfSpeech);
    }
    for (final category in word.categories) {
      final key = normalizeVocabText(category);
      final categoryList = _byCategory[key];
      categoryList?.remove(word);
      if (categoryList != null && categoryList.isEmpty) {
        _byCategory.remove(key);
      }
    }
  }
}
