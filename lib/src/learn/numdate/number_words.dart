/// Convertit un nombre entier positif en lettres italiennes.
/// Groupement par tranches de trois chiffres comme en italien :
///
/// 340282 -> "trecentoquarantamila duecentottantadue"
/// 1234567 -> "unmilioneduecentotrentamila quattrocentosessantasette"
String numberToItalian(int n) {
  if (n < 0) throw ArgumentError('Le nombre doit être positif');

  const units = [
    'zero',
    'uno',
    'due',
    'tre',
    'quattro',
    'cinque',
    'sei',
    'sette',
    'otto',
    'nove',
    'dieci',
    'undici',
    'dodici',
    'tredici',
    'quattordici',
    'quindici',
    'sedici',
    'diciassette',
    'diciotto',
    'diciannove'
  ];

  const tens = ['', '', 'venti', 'trenta', 'quaranta', 'cinquanta', 'sessanta', 'settanta', 'ottanta', 'novanta'];

  String convert(int num) {
    if (num < 20) return units[num];
    if (num < 100) {
      final ten = num ~/ 10;
      final unit = num % 10;
      var tenWord = tens[ten];
      if (unit == 1 || unit == 8) tenWord = tenWord.substring(0, tenWord.length - 1);
      if (unit == 3) return '${tenWord}tré';
      return '$tenWord${unit > 0 ? units[unit] : ''}';
    }
    if (num < 200) {
      final rest = convert(num % 100);
      if (rest.startsWith('otto')) return 'cent$rest';
      return 'cento${num % 100 == 0 ? '' : rest}';
    }
    if (num < 1000) {
      final hundreds = num ~/ 100;
      final rest = num % 100;
      final restWord = rest == 0 ? '' : convert(rest);
      var hundredWord = '${convert(hundreds)}cento';
      if (restWord.startsWith('otto')) hundredWord = '${convert(hundreds)}cent';
      return '$hundredWord$restWord';
    }
    if (num < 2000) return 'mille${num % 1000 == 0 ? '' : ' ${convert(num % 1000)}'}';
    if (num < 1000000) {
      final thousands = num ~/ 1000;
      final rest = num % 1000;
      return '${convert(thousands)}mila${rest == 0 ? '' : ' ${convert(rest)}'}';
    }
    if (num < 2000000) return 'un milione${n % 1000000 == 0 ? '' : ' ${convert(n % 1000000)}'}';
    if (num < 1000000000) {
      final millions = num ~/ 1000000;
      final rest = num % 1000000;
      return '${convert(millions)}milioni${rest == 0 ? '' : ' ${convert(rest)}'}';
    }
    if (num < 2000000000) return 'un miliardo${n % 1000000000 == 0 ? '' : ' ${convert(n % 1000000000)}'}';
    final billions = num ~/ 1000000000;
    final rest = num % 1000000000;
    return '${convert(billions)}miliardi${rest == 0 ? '' : ' ${convert(rest)}'}';
  }

  return convert(n);
}

String itNumberToWords(int n) => numberToItalian(n);
