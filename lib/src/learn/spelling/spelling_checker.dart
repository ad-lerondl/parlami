import 'package:parlami/src/data/models/vocab_word.dart';

enum SpellingResultKind { exact, accentOnlyMismatch, mismatch }

class SpellingCheckResult {
  const SpellingCheckResult({
    required this.kind,
    required this.expected,
    required this.answer,
  });

  final SpellingResultKind kind;
  final String expected;
  final String answer;

  bool get isCorrect => kind == SpellingResultKind.exact;

  bool get isAlmostCorrect => kind == SpellingResultKind.accentOnlyMismatch;
}

/// Pure comparison helpers for the spelling (dictation) exercises.
///
/// The whole point of the module is to catch accent and double-consonant
/// mistakes, so [checkSpelling] compares the raw answer first and only then
/// falls back to the accent-insensitive comparison.
class SpellingChecker {
  const SpellingChecker._();

  static SpellingCheckResult check({
    required String answer,
    required String expected,
  }) {
    final trimmedAnswer = answer.trim().toLowerCase();
    final trimmedExpected = expected.trim().toLowerCase();
    if (trimmedAnswer == trimmedExpected) {
      return SpellingCheckResult(
        kind: SpellingResultKind.exact,
        expected: expected,
        answer: answer,
      );
    }
    final normalizedAnswer = normalizeVocabText(trimmedAnswer);
    final normalizedExpected = normalizeVocabText(trimmedExpected);
    if (normalizedAnswer == normalizedExpected) {
      return SpellingCheckResult(
        kind: SpellingResultKind.accentOnlyMismatch,
        expected: expected,
        answer: answer,
      );
    }
    return SpellingCheckResult(
      kind: SpellingResultKind.mismatch,
      expected: expected,
      answer: answer,
    );
  }

  /// Returns true when the word is interesting for a spelling drill:
  /// accented vowels, double letters or the c/g + i/e spelling traps.
  static bool isSpellingSensitive(VocabWord word) {
    final word2 = word.italian.toLowerCase();
    if (RegExp(r'[àèéêìòóù]').hasMatch(word2)) return true;
    if (RegExp(r'(.)\1').hasMatch(word2)) return true;
    if (RegExp(r'(?:[cq]i|gi|gli)').hasMatch(word2)) return true;
    return false;
  }

  static String firstLetter(String word) {
    final trimmed = word.trim();
    if (trimmed.isEmpty) return '';
    return trimmed[0].toUpperCase();
  }
}
