import 'package:flutter/material.dart';

String italianHourWord(int hour) {
  const names = [
    'mezzanotte',
    'una',
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
    'mezzogiorno',
    'una',
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
  ];
  return names[hour % 24];
}

String italianTimeWords(TimeOfDay time) {
  final hour = time.hour;
  final minute = time.minute;

  if (hour == 0 && minute == 0) return 'mezzanotte';
  if (hour == 12 && minute == 0) return 'mezzogiorno';

  final nextHour = italianHourWord((hour + 1) % 24);
  final currentHour = italianHourWord(hour);

  if (minute == 0) {
    return hour == 1 ? 'l\'una' : 'le $currentHour';
  }
  if (minute == 15) return 'un quarto dopo le $currentHour';
  if (minute == 30) return 'le $currentHour e mezza';
  if (minute == 45) return 'un quarto alle $nextHour';

  if (minute < 30) {
    return '$minute minuti dopo le $currentHour';
  }
  final remaining = 60 - minute;
  return '$remaining minuti alle $nextHour';
}
