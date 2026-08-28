import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/data/models/verb_conjugation.dart';

void main() {
  test('VerbConjugation parses regular person-form maps', () {
    final json = {
      'infinitive': 'test',
      'conjugations': {
        'Indicativo': {
          'Presente': {
            'io': 'testo',
            'tu': 'testi',
          }
        }
      }
    };

    final verb = VerbConjugation.fromJson(json);
    expect(verb.infinitive, 'test');
    expect(verb.conjugations['Indicativo']!['Presente']!['io'], 'testo');
  });

  test('VerbConjugation parses nested string values (Forme Impersonali)', () {
    final json = {
      'infinitive': 'fare',
      'conjugations': {
        'Forme Impersonali': {
          'Infinito': {'Presente': 'fare', 'Passato': 'avere fatto'}
        }
      }
    };

    final verb = VerbConjugation.fromJson(json);
    expect(verb.infinitive, 'fare');
    // Infinito is stored as a tense with Presente/Passato as persons
    expect(verb.conjugations['Forme Impersonali']!['Infinito']!['Presente'], 'fare');
    expect(verb.conjugations['Forme Impersonali']!['Infinito']!['Passato'], 'avere fatto');
  });
}
