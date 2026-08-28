import 'number_words.dart';

String italianWeekday(int weekday) {
  // DateTime.weekday: Monday=1..Sunday=7
  const names = {
    1: 'lunedì',
    2: 'martedì',
    3: 'mercoledì',
    4: 'giovedì',
    5: 'venerdì',
    6: 'sabato',
    7: 'domenica',
  };
  return names[weekday] ?? '';
}

String frenchWeekday(int weekday) {
  // DateTime.weekday: Monday=1..Sunday=7
  const names = {
    1: 'lundi',
    2: 'mardi',
    3: 'mercredi',
    4: 'jeudi',
    5: 'vendredi',
    6: 'samedi',
    7: 'dimanche',
  };
  return names[weekday] ?? '';
}

String italianMonth(int month) {
  const names = {
    1: 'gennaio',
    2: 'febbraio',
    3: 'marzo',
    4: 'aprile',
    5: 'maggio',
    6: 'giugno',
    7: 'luglio',
    8: 'agosto',
    9: 'settembre',
    10: 'ottobre',
    11: 'novembre',
    12: 'dicembre',
  };
  return names[month] ?? '';
}

String italianDateWords(DateTime dt) {
  final wd = italianWeekday(dt.weekday);
  final m = italianMonth(dt.month);
  return '$wd ${numberToItalian(dt.day)} $m ${numberToItalian(dt.year)}';
}

String italianYearWords(int year) => numberToItalian(year);
