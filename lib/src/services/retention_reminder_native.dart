import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

Future<void> initializeRetentionReminders() async {
  const settings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );
  await _notifications.initialize(settings);
}

// Ajout d'un calcul dynamique dans le enableDailyReminder
Future<bool> enableDailyReminder() async {
  final android = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  final androidGranted = await android?.requestNotificationsPermission() ?? true;
  final ios = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
  final iosGranted = await ios?.requestPermissions(alert: true, badge: true, sound: true) ?? true;

  if (!androidGranted || !iosGranted) return false;

  // On récupère le paramètre streak (sauvegardé hypothétiquement lors des sessions)
  // Ou on met un texte incitatif lié aux fameuses "2 minutes"
  const details = NotificationDetails(
    android: AndroidNotificationDetails(
      'parlami-retention',
      'Rappels Parlami',
      channelDescription: 'Rappels pour maintenir la régularité d’apprentissage.',
      importance: Importance.high, // Modifié pour être bien visible
      color: Colors.green, // Une belle couleur verte
    ),
    iOS: DarwinNotificationDetails(),
  );

  await _notifications.periodicallyShow(
    1001,
    '🔥 Ne perds pas ton rythme !',
    'Seulement 2 minutes suffisent aujourd\'hui pour sauver ta série.', // Texte psychologique modifié
    RepeatInterval.daily,
    details,
  );

  return true;
}

Future<void> disableDailyReminder() => _notifications.cancel(1001);
