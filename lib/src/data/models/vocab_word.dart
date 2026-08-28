import 'dart:math';

enum VocabDifficulty { a1, a2, b1, b2, c1, c2 }

enum VocabPartOfSpeech {
  noun,
  verb,
  adjective,
  adverb,
  pronoun,
  determiner,
  preposition,
  conjunction,
  interjection,
  expression,
  other
}

enum VocabLanguage { italian, french }

enum VocabWordSource { original, user }

extension VocabWordSourceX on VocabWordSource {
  String get label => this == VocabWordSource.original ? 'Original' : 'Utilisateur';
}

extension VocabDifficultyX on VocabDifficulty {
  String get label => switch (this) {
        VocabDifficulty.a1 => 'A1',
        VocabDifficulty.a2 => 'A2',
        VocabDifficulty.b1 => 'B1',
        VocabDifficulty.b2 => 'B2',
        VocabDifficulty.c1 => 'C1',
        VocabDifficulty.c2 => 'C2',
      };

  static VocabDifficulty parse(String? raw, {VocabDifficulty fallback = VocabDifficulty.a1}) {
    switch ((raw ?? '').trim().toUpperCase()) {
      case 'A1':
        return VocabDifficulty.a1;
      case 'A2':
        return VocabDifficulty.a2;
      case 'B1':
        return VocabDifficulty.b1;
      case 'B2':
        return VocabDifficulty.b2;
      case 'C1':
        return VocabDifficulty.c1;
      case 'C2':
        return VocabDifficulty.c2;
      default:
        return fallback;
    }
  }
}

extension VocabPartOfSpeechX on VocabPartOfSpeech {
  String get label => switch (this) {
        VocabPartOfSpeech.noun => 'Nom',
        VocabPartOfSpeech.verb => 'Verbe',
        VocabPartOfSpeech.adjective => 'Adjectif',
        VocabPartOfSpeech.adverb => 'Adverbe',
        VocabPartOfSpeech.pronoun => 'Pronom',
        VocabPartOfSpeech.determiner => 'Déterminant',
        VocabPartOfSpeech.preposition => 'Préposition',
        VocabPartOfSpeech.conjunction => 'Conjonction',
        VocabPartOfSpeech.interjection => 'Interjection',
        VocabPartOfSpeech.expression => 'Expression',
        VocabPartOfSpeech.other => 'Autre',
      };

  static VocabPartOfSpeech parse(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'noun':
      case 'nom':
        return VocabPartOfSpeech.noun;
      case 'verb':
      case 'verbe':
        return VocabPartOfSpeech.verb;
      case 'adjective':
      case 'adjectif':
        return VocabPartOfSpeech.adjective;
      case 'adverb':
      case 'adverbe':
        return VocabPartOfSpeech.adverb;
      case 'pronoun':
      case 'pronom':
        return VocabPartOfSpeech.pronoun;
      case 'determiner':
      case 'déterminant':
      case 'determinant':
        return VocabPartOfSpeech.determiner;
      case 'preposition':
      case 'préposition':
        return VocabPartOfSpeech.preposition;
      case 'conjunction':
      case 'conjonction':
        return VocabPartOfSpeech.conjunction;
      case 'interjection':
        return VocabPartOfSpeech.interjection;
      case 'expression':
        return VocabPartOfSpeech.expression;
      default:
        return VocabPartOfSpeech.other;
    }
  }
}

extension VocabLanguageX on VocabLanguage {
  String get label => this == VocabLanguage.italian ? 'Italien' : 'Français';
}

String normalizeVocabText(String input) {
  const replacements = {
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ä': 'a',
    'ã': 'a',
    'å': 'a',
    'ç': 'c',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ñ': 'n',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'ö': 'o',
    'õ': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    'ý': 'y',
    'ÿ': 'y',
    'À': 'a',
    'Á': 'a',
    'Â': 'a',
    'Ä': 'a',
    'Ã': 'a',
    'Å': 'a',
    'Ç': 'c',
    'È': 'e',
    'É': 'e',
    'Ê': 'e',
    'Ë': 'e',
    'Ì': 'i',
    'Í': 'i',
    'Î': 'i',
    'Ï': 'i',
    'Ñ': 'n',
    'Ò': 'o',
    'Ó': 'o',
    'Ô': 'o',
    'Ö': 'o',
    'Õ': 'o',
    'Ù': 'u',
    'Ú': 'u',
    'Û': 'u',
    'Ü': 'u',
    'Ý': 'y',
  };
  final buffer = StringBuffer();
  for (final codeUnit in input.runes) {
    final char = String.fromCharCode(codeUnit);
    buffer.write(replacements[char] ?? char);
  }
  return buffer.toString().toLowerCase();
}

class VocabReviewStats {
  final int attempts;
  final int correctAttempts;
  final int wrongAttempts;
  final int instabilityCount;
  final int seenCount;
  final double successMomentum;
  final double errorMomentum;
  final double reviewMomentum;
  final DateTime? lastSeenAt;
  final DateTime? lastReviewedAt;
  final bool? lastKnown;
  final bool? previousKnown;

  const VocabReviewStats({
    required this.attempts,
    required this.correctAttempts,
    required this.wrongAttempts,
    required this.instabilityCount,
    required this.seenCount,
    required this.successMomentum,
    required this.errorMomentum,
    required this.reviewMomentum,
    required this.lastSeenAt,
    required this.lastReviewedAt,
    required this.lastKnown,
    required this.previousKnown,
  });

  factory VocabReviewStats.initial() => const VocabReviewStats(
        attempts: 0,
        correctAttempts: 0,
        wrongAttempts: 0,
        instabilityCount: 0,
        seenCount: 0,
        successMomentum: 0,
        errorMomentum: 0,
        reviewMomentum: 0,
        lastSeenAt: null,
        lastReviewedAt: null,
        lastKnown: null,
        previousKnown: null,
      );

  factory VocabReviewStats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VocabReviewStats.initial();
    DateTime? parseDate(dynamic value) {
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return VocabReviewStats(
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      correctAttempts: (json['correctAttempts'] as num?)?.toInt() ?? 0,
      wrongAttempts: (json['wrongAttempts'] as num?)?.toInt() ?? 0,
      instabilityCount: (json['instabilityCount'] as num?)?.toInt() ?? 0,
      seenCount: (json['seenCount'] as num?)?.toInt() ?? 0,
      successMomentum: (json['successMomentum'] as num?)?.toDouble() ?? 0,
      errorMomentum: (json['errorMomentum'] as num?)?.toDouble() ?? 0,
      reviewMomentum: (json['reviewMomentum'] as num?)?.toDouble() ?? 0,
      lastSeenAt: parseDate(json['lastSeenAt']),
      lastReviewedAt: parseDate(json['lastReviewedAt']),
      lastKnown: json['lastKnown'] as bool?,
      previousKnown: json['previousKnown'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'attempts': attempts,
        'correctAttempts': correctAttempts,
        'wrongAttempts': wrongAttempts,
        'instabilityCount': instabilityCount,
        'seenCount': seenCount,
        'successMomentum': successMomentum,
        'errorMomentum': errorMomentum,
        'reviewMomentum': reviewMomentum,
        'lastSeenAt': lastSeenAt?.toIso8601String(),
        'lastReviewedAt': lastReviewedAt?.toIso8601String(),
        'lastKnown': lastKnown,
        'previousKnown': previousKnown,
      };

  VocabReviewStats seen(DateTime now) {
    final gapHours = lastSeenAt == null ? 0.0 : now.difference(lastSeenAt!).inMinutes / 60.0;
    final decay = exp(-gapHours / 72.0);
    return VocabReviewStats(
      attempts: attempts,
      correctAttempts: correctAttempts,
      wrongAttempts: wrongAttempts,
      instabilityCount: instabilityCount,
      seenCount: seenCount + 1,
      successMomentum: successMomentum * decay,
      errorMomentum: errorMomentum * decay,
      reviewMomentum: reviewMomentum * decay + 1,
      lastSeenAt: now,
      lastReviewedAt: lastReviewedAt,
      lastKnown: lastKnown,
      previousKnown: previousKnown,
    );
  }

  VocabReviewStats recordReview(bool known, DateTime now) {
    final gapHours = lastReviewedAt == null ? 0.0 : now.difference(lastReviewedAt!).inMinutes / 60.0;
    final decay = exp(-gapHours / 72.0);
    final instability = lastKnown != null && lastKnown != known ? instabilityCount + 1 : instabilityCount;
    return VocabReviewStats(
      attempts: attempts + 1,
      correctAttempts: correctAttempts + (known ? 1 : 0),
      wrongAttempts: wrongAttempts + (known ? 0 : 1),
      instabilityCount: instability,
      seenCount: seenCount + 1,
      successMomentum: successMomentum * decay + (known ? 1.0 : 0.0),
      errorMomentum: errorMomentum * decay + (known ? 0.0 : 1.0),
      reviewMomentum: reviewMomentum * decay + 1.0,
      lastSeenAt: now,
      lastReviewedAt: now,
      lastKnown: known,
      previousKnown: lastKnown,
    );
  }

  double get successRate {
    if (attempts == 0) return 0;
    return correctAttempts / attempts;
  }

  double get instabilityRate {
    if (attempts <= 1) return 0;
    return instabilityCount / max(1, attempts - 1);
  }
}

class VocabWord {
  final String id;
  final String italian;
  final String french;
  final VocabDifficulty difficulty;
  final List<String> categories;
  final VocabPartOfSpeech partOfSpeech;
  final String? article;
  final VocabWordSource source;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VocabReviewStats stats;

  const VocabWord({
    required this.id,
    required this.italian,
    required this.french,
    required this.difficulty,
    required this.categories,
    required this.partOfSpeech,
    required this.article,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  factory VocabWord.fromJson(Map<String, dynamic> json, {String? idFallback}) {
    final categories = <String>{
      ..._normalizeCategories(json['categories']),
      ..._normalizeCategories(json['themes']),
    }.toList(growable: false);
    final italian = (json['it'] ?? json['italian'] ?? '') as String;
    final french = (json['fr'] ?? json['french'] ?? '') as String;
    final difficulty = VocabDifficultyX.parse(json['difficulty']?.toString(),
        fallback: VocabDifficultyX.parse(json['level']?.toString()));
    final partOfSpeech = VocabPartOfSpeechX.parse(
        json['partOfSpeech']?.toString() ?? json['genre']?.toString() ?? json['type']?.toString());
    final now = DateTime.now();
    final createdAt = DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? now;
    final updatedAt = DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? createdAt;
    final article = json['article']?.toString().trim();
    final source = switch ((json['source'] ?? json['origin'])?.toString().trim().toLowerCase()) {
      'user' => VocabWordSource.user,
      'original' => VocabWordSource.original,
      _ => VocabWordSource.original,
    };
    return VocabWord(
      id: (json['id']?.toString().trim().isNotEmpty ?? false)
          ? json['id'].toString()
          : (idFallback ?? _slugify('$italian-$french')),
      italian: italian,
      french: french,
      difficulty: difficulty,
      categories: categories,
      partOfSpeech: partOfSpeech,
      article: article == null || article.isEmpty ? null : article,
      source: source,
      createdAt: createdAt,
      updatedAt: updatedAt,
      stats: VocabReviewStats.fromJson(json['stats'] is Map ? Map<String, dynamic>.from(json['stats'] as Map) : null),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'it': italian,
        'fr': french,
        'difficulty': difficulty.label,
        'level': difficulty.label,
        'categories': categories,
        'partOfSpeech': partOfSpeech.name,
        'article': article,
        'source': source.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'stats': stats.toJson(),
      };

  VocabWord copyWith({
    String? id,
    String? italian,
    String? french,
    VocabDifficulty? difficulty,
    List<String>? categories,
    VocabPartOfSpeech? partOfSpeech,
    String? article,
    VocabWordSource? source,
    DateTime? createdAt,
    DateTime? updatedAt,
    VocabReviewStats? stats,
  }) {
    return VocabWord(
      id: id ?? this.id,
      italian: italian ?? this.italian,
      french: french ?? this.french,
      difficulty: difficulty ?? this.difficulty,
      categories: categories ?? this.categories,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      article: article ?? this.article,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }

  String labelFor(VocabLanguage language) {
    final word = language == VocabLanguage.italian ? italian : french;
    if (language == VocabLanguage.italian &&
        article != null &&
        article!.trim().isNotEmpty &&
        partOfSpeech == VocabPartOfSpeech.noun) {
      return '$article $word';
    }
    return word;
  }

  String get searchText => normalizeVocabText([
        id,
        italian,
        french,
        difficulty.label,
        partOfSpeech.label,
        article ?? '',
        ...categories,
      ].join(' '));

  bool matchesQuery(String query, {required bool regex}) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return true;
    if (regex) {
      try {
        final pattern = RegExp(trimmed, caseSensitive: false);
        return pattern.hasMatch(italian) ||
            pattern.hasMatch(french) ||
            categories.any(pattern.hasMatch) ||
            pattern.hasMatch(partOfSpeech.label) ||
            pattern.hasMatch(difficulty.label) ||
            (article != null && pattern.hasMatch(article!));
      } catch (_) {
        final normalized = normalizeVocabText(trimmed);
        return searchText.contains(normalized);
      }
    }
    final normalized = normalizeVocabText(trimmed);
    return searchText.contains(normalized);
  }

  double masteryScore([DateTime? now]) {
    final reference = now ?? DateTime.now();
    if (stats.attempts == 0) return 0;

    final daysSinceReview = stats.lastReviewedAt == null
        ? 365.0
        : max(0, reference.difference(stats.lastReviewedAt!).inMinutes / (60.0 * 24.0));
    final timeDecay = 1 / (1 + (daysSinceReview / 21.0));
    final reviewGapPenalty = min(daysSinceReview / 30.0, 1.0);
    final recentMemory = stats.successMomentum + stats.errorMomentum;
    final recentError = recentMemory == 0 ? 0.0 : stats.errorMomentum / recentMemory;
    final weakness = (1 - stats.successRate) * 0.30 +
        (1 - timeDecay) * 0.20 +
        recentError * 0.20 +
        stats.instabilityRate * 0.15 +
        reviewGapPenalty * 0.15;
    return (100 * (1 - weakness)).clamp(0, 100).toDouble();
  }

  Map<String, double> masteryBreakdown([DateTime? now]) {
    final reference = now ?? DateTime.now();
    final daysSinceReview = stats.lastReviewedAt == null
        ? 365.0
        : max(0, reference.difference(stats.lastReviewedAt!).inMinutes / (60.0 * 24.0));
    final timeDecay = 1 / (1 + (daysSinceReview / 21.0));
    final reviewGapPenalty = min(daysSinceReview / 30.0, 1.0);
    final recentMemory = stats.successMomentum + stats.errorMomentum;
    final recentError = recentMemory == 0 ? 0.0 : stats.errorMomentum / recentMemory;
    return {
      'successRate': stats.successRate,
      'timeDecay': timeDecay,
      'instability': stats.instabilityRate,
      'reviewGap': reviewGapPenalty,
      'recentError': recentError,
      'mastery': masteryScore(reference),
    };
  }

  static List<String> _normalizeCategories(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Object>()
        .map((item) => item.toString().trim().toLowerCase())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  static String _slugify(String value) {
    return normalizeVocabText(value)
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}

class VocabFilter {
  final Set<VocabDifficulty> difficulties;
  final Set<String> categories;
  final Set<VocabPartOfSpeech> partsOfSpeech;
  final String query;
  final bool regex;
  final VocabLanguage baseLanguage;
  final bool masteryOrder;

  const VocabFilter({
    this.difficulties = const {},
    this.categories = const {},
    this.partsOfSpeech = const {},
    this.query = '',
    this.regex = false,
    this.baseLanguage = VocabLanguage.italian,
    this.masteryOrder = false,
  });

  VocabFilter copyWith({
    Set<VocabDifficulty>? difficulties,
    Set<String>? categories,
    Set<VocabPartOfSpeech>? partsOfSpeech,
    String? query,
    bool? regex,
    VocabLanguage? baseLanguage,
    bool? masteryOrder,
  }) {
    return VocabFilter(
      difficulties: difficulties ?? this.difficulties,
      categories: categories ?? this.categories,
      partsOfSpeech: partsOfSpeech ?? this.partsOfSpeech,
      query: query ?? this.query,
      regex: regex ?? this.regex,
      baseLanguage: baseLanguage ?? this.baseLanguage,
      masteryOrder: masteryOrder ?? this.masteryOrder,
    );
  }

  bool matches(VocabWord word) {
    if (difficulties.isNotEmpty && !difficulties.contains(word.difficulty)) return false;
    if (partsOfSpeech.isNotEmpty && !partsOfSpeech.contains(word.partOfSpeech)) return false;
    if (categories.isNotEmpty && !word.categories.any(categories.contains)) return false;
    if (query.trim().isNotEmpty && !word.matchesQuery(query, regex: regex)) return false;
    return true;
  }
}
