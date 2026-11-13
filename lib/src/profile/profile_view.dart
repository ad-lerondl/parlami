import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parlami/src/settings/settings_controller.dart';
import 'package:parlami/src/localization/app_localizations.dart';
import 'package:parlami/src/services/retention_reminder_service.dart';
import 'package:parlami/src/auth/auth_service.dart';
import 'package:parlami/src/auth/login_view.dart';
import 'package:parlami/src/settings/language_names.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.controller});
  final SettingsController controller;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _remindersEnabled = false;
  bool _reminderBusy = false;
  bool _signingOut = false;
  String? _displayName;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      if (mounted) setState(() => _remindersEnabled = preferences.getBool('retention_reminders_enabled') ?? false);
    });
    AuthService.instance.fetchDisplayName().then((name) {
      if (mounted) setState(() => _displayName = name);
    });
    _authSubscription = AuthService.instance.authStateStream.listen((_) {
      if (!mounted) return;
      setState(() => _displayName = null);
      AuthService.instance.fetchDisplayName().then((name) {
        if (mounted) setState(() => _displayName = name);
      });
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _signOut() async {
    if (_signingOut) return;
    setState(() => _signingOut = true);
    await AuthService.instance.signOut();
    if (!mounted) return;
    setState(() => _signingOut = false);
  }

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginView(settingsController: widget.controller)),
    );
  }

  String _accountSubtitle(AppLocalizations l10n) {
    final user = AuthService.instance.currentUser;
    if (user == null) return l10n.authNotSignedIn;
    final email = user.email ?? '';
    final name = _displayName;
    if (name != null && name.isNotEmpty) return '$name \u00b7 $email';
    return email;
  }

  Future<void> _toggleReminders(bool enabled) async {
    if (_reminderBusy) return;
    setState(() => _reminderBusy = true);
    final granted = enabled ? await enableDailyReminder() : true;
    if (!enabled) await disableDailyReminder();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('retention_reminders_enabled', enabled && granted);
    if (!mounted) return;
    setState(() {
      _remindersEnabled = enabled && granted;
      _reminderBusy = false;
    });
    if (enabled && !granted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Les notifications sont refusées sur cet appareil.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = AuthService.instance.currentUser;

    return ListView(children: [
      ListTile(
        leading: const Icon(Icons.account_circle_outlined),
        title: Text(l10n.authAccountSection),
        subtitle: Text(_accountSubtitle(l10n)),
      ),
      if (user == null)
        ListTile(
          leading: const Icon(Icons.login),
          title: Text(l10n.authSignIn),
          onTap: _openLogin,
        )
      else
        ListTile(
          leading: _signingOut
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.logout),
          title: Text(l10n.authSignOut),
          onTap: _signingOut ? null : _signOut,
        ),
      ListTile(
        title: Text(l10n.profileLanguage),
        subtitle: Text(languageNames[widget.controller.locale.languageCode] ?? widget.controller.locale.languageCode),
        trailing: DropdownButton<Locale>(
          value: widget.controller.locale,
          onChanged: widget.controller.updateLocale,
          items: AppLocalizations.supportedLocales
              .map((locale) => DropdownMenuItem(
                    value: locale,
                    child: Text(languageNames[locale.languageCode] ?? locale.languageCode),
                  ))
              .toList(),
        ),
      ),
      ListTile(title: Text(l10n.profileUserName), subtitle: Text(l10n.unavailable)),
      ListTile(
        title: Text(l10n.profileTheme),
        subtitle: Text(l10n.profileThemeDescription),
        onTap: () => widget.controller.updateThemeMode(
          widget.controller.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
        ),
      ),
      ListTile(
        leading: Icon(_remindersEnabled ? Icons.notifications_active_outlined : Icons.notifications_none_outlined),
        title: const Text('Rappels quotidiens'),
        subtitle: Text(_remindersEnabled
            ? 'Un rappel est activé pour garder le rythme.'
            : 'Recevoir un rappel doux pour commencer une session.'),
        trailing: _reminderBusy
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : Switch(value: _remindersEnabled, onChanged: _toggleReminders),
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
            'https://learn-parlami.netlify.app/privacy/${widget.controller.locale.languageCode}/',
          ),
        ),
      ),
    ]);
  }
}
