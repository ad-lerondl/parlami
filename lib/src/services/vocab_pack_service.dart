import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

const vocabPackBaseUrl = 'https://parlami-data.pages.dev/';

class VocabPackSummary {
  const VocabPackSummary({
    required this.id,
    required this.title,
    required this.path,
    required this.fromLanguage,
    required this.toLanguage,
    required this.themeTags,
    required this.displayLevel,
    required this.wordCount,
    required this.averageCefr,
    required this.registryVersion,
    required this.contentHash,
  });

  final String id;
  final String title;
  final String path;
  final String fromLanguage;
  final String toLanguage;
  final List<String> themeTags;
  final String displayLevel;
  final int wordCount;
  final double averageCefr;
  final String registryVersion;
  final String contentHash;

  VocabPackSummary copyWith({String? fromLanguage, String? toLanguage, int? wordCount}) {
    return VocabPackSummary(
      id: id,
      title: title,
      path: path,
      fromLanguage: fromLanguage ?? this.fromLanguage,
      toLanguage: toLanguage ?? this.toLanguage,
      themeTags: themeTags,
      displayLevel: displayLevel,
      wordCount: wordCount ?? this.wordCount,
      averageCefr: averageCefr,
      registryVersion: registryVersion,
      contentHash: contentHash,
    );
  }

  factory VocabPackSummary.fromJson(Map<String, dynamic> json) {
    final distribution = json['level_distribution'] is Map
        ? Map<String, dynamic>.from(json['level_distribution'] as Map)
        : const <String, dynamic>{};
    const levelValues = {'A1': 1, 'A2': 2, 'B1': 3, 'B2': 4, 'C1': 5, 'C2': 6};
    final total = distribution.values.fold<int>(0, (sum, value) => sum + (value as num).toInt());
    final weighted = distribution.entries
        .fold<double>(0, (sum, entry) => sum + (levelValues[entry.key.toUpperCase()] ?? 0) * (entry.value as num));
    return VocabPackSummary(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['id']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      fromLanguage: (json['from'] ?? json['source_language'] ?? json['from_language'])?.toString() ?? '',
      toLanguage: (json['to'] ?? json['target_language'] ?? json['to_language'])?.toString() ?? '',
      themeTags: (json['theme_tags'] as List? ?? const []).map((tag) => tag.toString()).toList(growable: false),
      displayLevel: json['display_level']?.toString() ?? '',
      wordCount: (json['word_count'] as num?)?.toInt() ?? 0,
      averageCefr: total == 0 ? 0 : weighted / total,
      registryVersion: json['registry_version']?.toString() ?? '',
      contentHash: json['content_hash']?.toString() ?? '',
    );
  }
}

class VocabPack {
  const VocabPack({required this.summary, required this.words, required this.content, required this.registry});

  final VocabPackSummary summary;
  final List<Map<String, dynamic>> words;
  final Map<String, dynamic> content;
  final VocabRegistry registry;
}

class VocabRegistrySense {
  const VocabRegistrySense({
    required this.senseId,
    required this.wordId,
    required this.gloss,
    required this.translations,
    required this.examples,
  });

  final String senseId;
  final String wordId;
  final String gloss;
  final List<String> translations;
  final List<Map<String, dynamic>> examples;
}

class VocabRegistryWord {
  const VocabRegistryWord({
    required this.wordId,
    required this.lemma,
    required this.pos,
    required this.gender,
    required this.ipa,
    required this.cefr,
    required this.freqRank,
    required this.senses,
  });

  final String wordId;
  final String lemma;
  final String pos;
  final String? gender;
  final String? ipa;
  final String? cefr;
  final int? freqRank;
  final List<VocabRegistrySense> senses;
}

class VocabRegistry {
  const VocabRegistry({required this.version, required this.words, required this.senses});

  final String version;
  final Map<String, VocabRegistryWord> words;
  final Map<String, VocabRegistrySense> senses;

  factory VocabRegistry.fromJson(Map<String, dynamic> json) {
    final words = <String, VocabRegistryWord>{};
    final senses = <String, VocabRegistrySense>{};
    for (final rawWord in json['words'] as List? ?? const []) {
      final wordJson = Map<String, dynamic>.from(rawWord as Map);
      final wordId = wordJson['word_id']?.toString() ?? '';
      final wordSenses = <VocabRegistrySense>[];
      for (final rawSense in wordJson['senses'] as List? ?? const []) {
        final senseJson = Map<String, dynamic>.from(rawSense as Map);
        final sense = VocabRegistrySense(
          senseId: senseJson['sense_id']?.toString() ?? '',
          wordId: wordId,
          gloss: senseJson['gloss']?.toString() ?? '',
          translations: _stringList(senseJson['translations']),
          examples: (senseJson['examples'] as List? ?? const [])
              .map((example) => Map<String, dynamic>.from(example as Map))
              .toList(growable: false),
        );
        if (sense.senseId.isNotEmpty) {
          wordSenses.add(sense);
          senses[sense.senseId] = sense;
        }
      }
      if (wordId.isNotEmpty) {
        words[wordId] = VocabRegistryWord(
          wordId: wordId,
          lemma: wordJson['lemma']?.toString() ?? '',
          pos: wordJson['pos']?.toString() ?? '',
          gender: wordJson['gender']?.toString(),
          ipa: wordJson['ipa']?.toString(),
          cefr: wordJson['cefr']?.toString(),
          freqRank: (wordJson['freq_rank'] as num?)?.toInt(),
          senses: wordSenses,
        );
      }
    }
    return VocabRegistry(
      version: json['version']?.toString() ?? '',
      words: words,
      senses: senses,
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) return value.map((item) => item.toString()).toList(growable: false);
    if (value is String && value.isNotEmpty) return [value];
    return const [];
  }
}

class VocabPackService {
  const VocabPackService({http.Client? client}) : _client = client;

  final http.Client? _client;

  Future<List<VocabPackSummary>> listPacks() async {
    final response = await (_client ?? http.Client()).get(Uri.parse('${vocabPackBaseUrl}index.json'));
    if (response.statusCode != 200) {
      throw Exception('Catalogue des packs indisponible (${response.statusCode}).');
    }
    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final registryVersion = json['registry_version']?.toString() ?? '';
    return (json['packs'] as List? ?? const [])
        .map((item) => VocabPackSummary.fromJson({
              ...Map<String, dynamic>.from(item as Map),
              'registry_version': registryVersion,
            }))
        .where((pack) => pack.id.isNotEmpty && pack.path.isNotEmpty)
        .toList(growable: false);
  }

  Future<VocabRegistry> downloadRegistry(String version) async {
    final response = await (_client ?? http.Client()).get(Uri.parse('${vocabPackBaseUrl}registry-$version.json'));
    if (response.statusCode != 200) {
      throw Exception('Mise à jour du registre requise ($version).');
    }
    return VocabRegistry.fromJson(jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  }

  Future<VocabPack> downloadPack(VocabPackSummary summary, VocabRegistry registry) async {
    if (summary.registryVersion.isNotEmpty && summary.registryVersion != registry.version) {
      throw Exception('Mise à jour du registre requise.');
    }
    final response = await (_client ?? http.Client()).get(Uri.parse('$vocabPackBaseUrl${summary.path}'));
    if (response.statusCode != 200) {
      throw Exception('Pack indisponible (${response.statusCode}).');
    }
    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final expectedHash = json['content_hash']?.toString();
    if (expectedHash != null && expectedHash.isNotEmpty && _hashWithoutContentHash(json) != expectedHash) {
      throw Exception('Pack corrompu: hash invalide.');
    }
    final words = (json['words'] as List? ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
    final downloadedSummary = VocabPackSummary.fromJson({
      'id': summary.id,
      'title': summary.title,
      'path': summary.path,
      'from': summary.fromLanguage,
      'to': summary.toLanguage,
      'theme_tags': summary.themeTags,
      'display_level': summary.displayLevel,
      'word_count': words.length,
      'level_distribution': json['level_distribution'] ?? {},
      'registry_version': summary.registryVersion,
      'content_hash': summary.contentHash,
      ...json,
    });
    return VocabPack(summary: downloadedSummary, words: words, content: json, registry: registry);
  }

  static String _hashWithoutContentHash(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json)..remove('content_hash');
    return sha256.convert(utf8.encode(jsonEncode(_canonicalize(copy)))).toString();
  }

  static dynamic _canonicalize(dynamic value) {
    if (value is Map) {
      final keys = value.keys.map((key) => key.toString()).toList()..sort();
      return <String, dynamic>{for (final key in keys) key: _canonicalize(value[key])};
    }
    if (value is List) return value.map(_canonicalize).toList(growable: false);
    return value;
  }
}
