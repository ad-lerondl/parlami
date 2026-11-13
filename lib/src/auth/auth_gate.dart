import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../settings/settings_controller.dart';
import 'auth_service.dart';
import 'login_view.dart';

/// Affiche l'ecran de connexion tant qu'il n'y a ni session ni mode invite,
/// puis l'application. La session Supabase persiste entre les lancements :
/// un utilisateur connecte revient directement dans l'application.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.child, required this.settingsController});

  final Widget child;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AuthService.instance.guestMode,
      builder: (context, isGuest, _) {
        return StreamBuilder<AuthState>(
          stream: AuthService.instance.authStateStream,
          builder: (context, snapshot) {
            if (AuthService.instance.currentSession != null || isGuest) return child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return LoginView(settingsController: settingsController);
          },
        );
      },
    );
  }
}
