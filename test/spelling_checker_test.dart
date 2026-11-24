import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/data/models/vocab_word.dart';
import 'package:parlami/src/learn/spelling/spelling_checker.dart';

VocabWord _word(String italian) {
  return VocabWord(
    id: 'test_$italian',
    italian: italian,
    french: 'français',
    difficulty: VocabDifficulty.a1,
    categories: const [],
    partOfSpeech: VocabPartOfSpeech.noun,
    article: null,
    source: VocabWordSource.original,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
    stats: VocabReviewStats.initial(),
  );
}

void main() {
  group('SpellingChecker.check', () {
    test('accepts an exact answer', () {
      final result = SpellingChecker.check(answer: 'Bello', expected: 'bello');
      expect(result.kind, SpellingResultKind.exact);
      expect(result.isCorrect, isTrue);
    });

    test('flags an accent mismatch without counting it as plain wrong', () {
      final result =
          SpellingChecker.check(answer: 'Universita', expected: 'università');
      expect(result.kind, SpellingResultKind.accentOnlyMismatch);
      expect(result.isCorrect, isFalse);
      expect(result.isAlmostCorrect, isTrue);
    });

    test('flags a real mismatch', () {
      final result = SpellingChecker.check(answer: 'belo', expected: 'bello');
      expect(result.kind, SpellingResultKind.mismatch);
      expect(result.isAlmostCorrect, isFalse);
    });

    test('trims whitespace before comparing', () {
      final result = SpellingChecker.check(answer: '  casa  ', expected: 'casa');
      expect(result.kind, SpellingResultKind.exact);
    });
  });

  group('SpellingChecker.isSpellingSensitive', () {
    test('detects accented words', () {
      expect(SpellingChecker.isSpellingSensitive(_word('però')), isTrue);
      expect(SpellingChecker.isSpellingSensitive(_word('città')), isTrue);
    });

    test('detects double consonants', () {
      expect(SpellingChecker.isSpellingSensitive(_word('bello')), isTrue);
    });

    test('detects the c/g + i/e spelling traps', () {
      expect(SpellingChecker.isSpellingSensitive(_word('giorno')), isTrue);
      expect(SpellingChecker.isSpellingSensitive(_word('famiglia')), isTrue);
    });

    test('ignores plain words', () {
      expect(SpellingChecker.isSpellingSensitive(_word('casa')), isFalse);
    });
  });

  group('SpellingChecker.firstLetter', () {
    test('returns the upper-cased first letter', () {
      expect(SpellingChecker.firstLetter('italiano'), 'I');
      expect(SpellingChecker.firstLetter(''), '');
    });
  });
}
