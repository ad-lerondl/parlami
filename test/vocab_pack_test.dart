import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/data/models/vocab_word.dart';
import 'package:parlami/src/services/vocab_pack_service.dart';

void main() {
  test('parses schema v3 pack words', () {
    final word = VocabWord.fromJson({
      'lemma': 'cibo',
      'cefr': 'A1',
      'pos': 'n',
      'hint': 'ce que l’on mange',
      'sense_id': 'cibo/n/example',
    });

    expect(word.italian, 'cibo');
    expect(word.french, 'ce que l’on mange');
    expect(word.difficulty, VocabDifficulty.a1);
    expect(word.partOfSpeech, VocabPartOfSpeech.noun);
  });

  test('keeps every translation synonym', () {
    final word = VocabWord.fromJson({
      'lemma': 'casa',
      'translations': {
        'fr': ['maison', 'demeure']
      },
    });

    expect(word.translations, ['maison', 'demeure']);
    expect(word.labelFor(VocabLanguage.french), 'maison, demeure');
  });

  test('parses pack summaries from the remote index shape', () {
    final pack = VocabPackSummary.fromJson({
      'id': 'it-ristorante-a1',
      'title': 'Au restaurant',
      'path': 'packs/it-ristorante-a1.json',
      'from': 'it',
      'to': 'fr',
      'theme_tags': ['restaurant'],
      'display_level': 'A2',
      'word_count': 18,
      'level_distribution': {'A1': 3, 'A2': 11, 'B1': 1, 'B2': 2, 'C1': 1},
    });

    expect(pack.id, 'it-ristorante-a1');
    expect(pack.path, 'packs/it-ristorante-a1.json');
    expect(pack.fromLanguage, 'it');
    expect(pack.toLanguage, 'fr');
    expect(pack.averageCefr, closeTo(2.27, 0.01));
    expect(pack.wordCount, 18);
  });
}
