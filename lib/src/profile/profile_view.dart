import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parlami/src/settings/settings_controller.dart';
import 'package:parlami/src/localization/app_localizations.dart';

const _languageNames = <String, String>{
  'fr': 'Français',
  'en': 'English',
  'es': 'Español',
  'de': 'Deutsch',
  'pt': 'Português',
  'ar': 'العربية',
  'ru': 'Русский',
  'ja': '日本語',
  'he': 'עברית',
  'pl': 'Polski',
  'ro': 'Română',
  'sv': 'Svenska',
  'tr': 'Türkçe',
};

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.controller});
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(children: [
      ListTile(
        title: Text(l10n.profileLanguage),
        subtitle: Text(_languageNames[controller.locale.languageCode] ?? controller.locale.languageCode),
        trailing: DropdownButton<Locale>(
          value: controller.locale,
          onChanged: controller.updateLocale,
          items: AppLocalizations.supportedLocales
              .map((locale) => DropdownMenuItem(
                    value: locale,
                    child: Text(_languageNames[locale.languageCode] ?? locale.languageCode),
                  ))
              .toList(),
        ),
      ),
      ListTile(title: Text(l10n.profileUserName), subtitle: Text(l10n.unavailable)),
      ListTile(
        title: Text(l10n.profileTheme),
        subtitle: Text(l10n.profileThemeDescription),
        onTap: () => controller.updateThemeMode(
          controller.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
        ),
      ),
      ListTile(
        title: Text(l10n.profileDonate),
        subtitle: Text(l10n.profileDonateDescription),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => launchUrl(Uri.parse('https://donate.stripe.com/5kQ6oH5y5bHf58r2VFdMI02')),
      ),
      ListTile(title: Text(l10n.profileAbout), subtitle: const Text("""Parlami
        © 2026 Adam Lérondel
        Licensed under the PolyForm Perimeter License 1.0.1.
        https://polyformproject.org/licenses/perimeter/1.0.1
        Source code:
        https://github.com/ad-lerondl/parlami""")),
      ListTile(
        title: Text(l10n.profilePrivacy),
        subtitle: Text(l10n.profilePrivacyDescription),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => launchUrl(
          Uri.parse(
            'https://learn-parlami.netlify.app/privacy/${controller.locale.languageCode}/',
          ),
        ),
      ),
    ]);
  }
}
