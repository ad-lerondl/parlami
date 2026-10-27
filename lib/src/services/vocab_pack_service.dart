import 'dart:convert';

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
      fromLanguage: json['from']?.toString() ?? '',
      toLanguage: json['to']?.toString() ?? '',
      themeTags: (json['theme_tags'] as List? ?? const []).map((tag) => tag.toString()).toList(growable: false),
      displayLevel: json['display_level']?.toString() ?? '',
      wordCount: (json['word_count'] as num?)?.toInt() ?? 0,
      averageCefr: total == 0 ? 0 : weighted / total,
    );
  }
}

class VocabPack {
  const VocabPack({required this.summary, required this.words});

  final VocabPackSummary summary;
  final List<Map<String, dynamic>> words;
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
    return (json['packs'] as List? ?? const [])
        .map((item) => VocabPackSummary.fromJson(Map<String, dynamic>.from(item as Map)))
        .where((pack) => pack.id.isNotEmpty && pack.path.isNotEmpty)
        .toList(growable: false);
  }

  Future<VocabPack> downloadPack(VocabPackSummary summary) async {
    final response = await (_client ?? http.Client()).get(Uri.parse('$vocabPackBaseUrl${summary.path}'));
    if (response.statusCode != 200) {
      throw Exception('Pack indisponible (${response.statusCode}).');
    }
    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final words = (json['words'] as List? ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
    return VocabPack(summary: summary, words: words);
  }
}
