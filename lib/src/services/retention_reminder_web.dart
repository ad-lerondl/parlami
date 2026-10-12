import 'package:universal_html/html.dart' as html;

Future<void> initializeRetentionReminders() async {}

Future<bool> enableDailyReminder() async {
  if (!html.Notification.supported) return false;
  final permission = await html.Notification.requestPermission();
  if (permission != 'granted') return false;
  html.Notification(
    'Ton italien t’attend',
    body: 'Une courte session suffit pour garder le rythme.',
  );
  return true;
}

Future<void> disableDailyReminder() async {}
