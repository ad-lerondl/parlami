import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';
import 'login_view.dart';

/// Affiche l'application uniquement si une session existe, sinon l'ecran de
/// connexion. Quand Supabase n'est pas configure (dart-define absents),
/// l'application demarre directement en mode local.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!AuthService.instance.isConfigured) return child;

    return StreamBuilder<AuthState>(
      stream: AuthService.instance.authStateStream,
      builder: (context, snapshot) {
        if (AuthService.instance.currentSession != null) return child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return const LoginView();
      },
    );
  }
}
