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

  String _accountTitle(AppLocalizations l10n) {
    final user = AuthService.instance.currentUser;
    final name = _displayName;
    if (name != null && name.isNotEmpty) return name;
    final email = user?.email ?? '';
    if (email.isNotEmpty) return email.characters.first.toUpperCase();
    return l10n.navProfile;
  }

  String _headerInitials() {
    final user = AuthService.instance.currentUser;
    final source = _displayName ?? user?.email ?? '?';
    final trimmed = source.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.characters.first.toUpperCase();
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
          .showSnackBar(const SnackBar(content: Text('Les notifications sont refus\u00e9es sur cet appareil.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = AuthService.instance.currentUser;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(context, l10n, colorScheme),
        _SectionCard(
          title: l10n.authAccountSection,
          children: [
            if (user == null)
              ListTile(
                leading: const Icon(Icons.login),
                title: Text(l10n.authSignIn),
                trailing: const Icon(Icons.chevron_right),
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
          ],
        ),
        _SectionCard(
          title: l10n.profileSectionPreferences,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.profileLanguage),
              subtitle: Text(languageNames[widget.controller.locale.languageCode] ??
                  widget.controller.locale.languageCode),
              trailing: DropdownButton<Locale>(
                value: widget.controller.locale,
                onChanged: widget.controller.updateLocale,
                underline: const SizedBox.shrink(),
                items: AppLocalizations.supportedLocales
                    .map((locale) => DropdownMenuItem(
                          value: locale,
                          child: Text(languageNames[locale.languageCode] ?? locale.languageCode),
                        ))
                    .toList(),
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: Text(l10n.profileTheme),
              subtitle: Text(l10n.profileThemeDescription),
              value: widget.controller.themeMode == ThemeMode.dark,
              onChanged: (dark) => widget.controller
                  .updateThemeMode(dark ? ThemeMode.dark : ThemeMode.light),
            ),
            ListTile(
              leading: Icon(_remindersEnabled
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_none_outlined),
              title: const Text('Rappels quotidiens'),
              subtitle: Text(_remindersEnabled
                  ? 'Un rappel est activ\u00e9 pour garder le rythme.'
                  : 'Recevoir un rappel doux pour commencer une session.'),
              trailing: _reminderBusy
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : Switch(value: _remindersEnabled, onChanged: _toggleReminders),
            ),
          ],
        ),
        _SectionCard(
          title: l10n.profileSectionSupport,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: Text(l10n.profileDonate),
              subtitle: Text(l10n.profileDonateDescription),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => launchUrl(Uri.parse('https://donate.stripe.com/5kQ6oH5y5bHf58r2VFdMI02')),
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: Text(l10n.profilePrivacy),
              subtitle: Text(l10n.profilePrivacyDescription),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => launchUrl(
                Uri.parse(
                  'https://learn-parlami.netlify.app/privacy/${widget.controller.locale.languageCode}/',
                ),
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.profileAbout),
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Parlami\n\u00a9 2026 Adam L\u00e9rondel\nLicensed under the PolyForm Perimeter License 1.0.1.\nhttps://polyformproject.org/licenses/perimeter/1.0.1\nSource code:\nhttps://github.com/ad-lerondl/parlami',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                _headerInitials(),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _accountTitle(l10n),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _accountSubtitle(l10n),
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ...children,
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
