import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parlami/src/settings/settings_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.controller});
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      SwitchListTile(
        title: const Text('Langue (actuellement Français uniquement)'),
        value: false,
        onChanged: (_) {},
      ),
      const ListTile(
        title: Text("Nom de l'utilisateur"),
        subtitle: Text('Fonctionnalité encore indisponible.'),
      ),
      const ListTile(
        title: Text("À propos de l'application"),
        subtitle: Text('Parlami aide à apprendre l\'italien.'),
      ),
      ListTile(
        title: const Text('Thème'),
        subtitle: const Text('Changer clair/sombre'),
        onTap: () => controller.updateThemeMode(
          controller.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
        ),
      ),
      ListTile(
        title: const Text('Faire un don'),
        subtitle: const Text('Merci pour votre soutien'),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => launchUrl(Uri.parse('https://donate.stripe.com/5kQ6oH5y5bHf58r2VFdMI02')),
      ),
    ]);
  }
}
