import 'package:flutter_test/flutter_test.dart';

import 'package:parlami/src/learn/numdate/date_words.dart';
import 'package:parlami/src/learn/numdate/number_words.dart';

void main() {
  group('numberToItalian', () {
    test('handles values above 99', () {
      expect(numberToItalian(340282), 'trecentoquarantamila duecentoottantadue');
      expect(numberToItalian(1234567), 'un milione duecentotrentaquattromila cinquecentosessantasette');
    });

    test('handles elision and hundreds', () {
      expect(numberToItalian(21), 'ventuno');
      expect(numberToItalian(28), 'ventotto');
      expect(numberToItalian(108), 'centotto');
    });
  });

  group('italianDateWords', () {
    test('writes the year in letters', () {
      final date = DateTime(2026, 7, 16);
      final words = italianDateWords(date);

      expect(words, contains('duemila ventisei'));
      expect(words, isNot(contains('2026')));
      expect(words.startsWith('${italianWeekday(date.weekday)} sedici luglio'), isTrue);
    });
  });
}
