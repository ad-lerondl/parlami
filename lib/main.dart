import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/auth/auth_service.dart';
import 'src/auth/supabase_config.dart';
import 'src/localization/app_localizations.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/services/retention_reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeRetentionReminders();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  await AuthService.instance.loadGuestMode();

  if (!kIsWeb) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.parlami.radio.channel.audio',
      androidNotificationChannelName: 'Parlami Radio',
      androidNotificationOngoing: true,
    );
  }

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Pour un utilisateur connecte, les reglages synchronises (langue, theme)
  // prennent le dessus sur les valeurs locales de l'appareil.
  if (AuthService.instance.currentSession != null) {
    final remoteSettings = await AuthService.instance.fetchRemoteSettings();
    final remoteLocale = remoteSettings?['locale'];
    if (remoteLocale != null && remoteLocale.isNotEmpty) {
      final match = AppLocalizations.supportedLocales
          .where((locale) => locale.languageCode == remoteLocale);
      if (match.isNotEmpty) await settingsController.updateLocale(match.first);
    }
    switch (remoteSettings?['theme_mode']) {
      case 'light':
        await settingsController.updateThemeMode(ThemeMode.light);
      case 'dark':
        await settingsController.updateThemeMode(ThemeMode.dark);
      case 'system':
        await settingsController.updateThemeMode(ThemeMode.system);
    }
  }

  // Toute modification de langue ou de theme est poussee vers le compte
  // Supabase (sans effet en mode invite).
  settingsController.addListener(() {
    AuthService.instance.saveRemoteSettings(
      locale: settingsController.locale.languageCode,
      themeMode: settingsController.themeMode.name,
    );
  });

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
