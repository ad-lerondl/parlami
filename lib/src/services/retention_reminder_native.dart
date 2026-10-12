import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

Future<void> initializeRetentionReminders() async {
  const settings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );
  await _notifications.initialize(settings);
}

Future<bool> enableDailyReminder() async {
  final android = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  final androidGranted = await android?.requestNotificationsPermission() ?? true;
  final ios = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
  final iosGranted = await ios?.requestPermissions(alert: true, badge: true, sound: true) ?? true;
  if (!androidGranted || !iosGranted) return false;

  const details = NotificationDetails(
    android: AndroidNotificationDetails(
      'parlami-retention',
      'Rappels Parlami',
      channelDescription: 'Rappels pour maintenir la régularité d’apprentissage.',
      importance: Importance.defaultImportance,
    ),
    iOS: DarwinNotificationDetails(),
  );
  await _notifications.periodicallyShow(
    1001,
    'Ton italien t’attend',
    'Une courte session suffit pour garder le rythme.',
    RepeatInterval.daily,
    details,
  );
  return true;
}

Future<void> disableDailyReminder() => _notifications.cancel(1001);
