import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

enum AuthError {
  invalidCredentials,
  emailNotConfirmed,
  emailAlreadyUsed,
  weakPassword,
  rateLimited,
  network,
  unknown,
}

class SignUpResult {
  const SignUpResult({required this.confirmationRequired, this.error});

  final bool confirmationRequired;
  final AuthError? error;

  bool get success => error == null;
}

/// Point d'acces unique a l'authentification Supabase.
///
/// Suit le meme patron de singleton que [RadioPlayerService] : un etat global
/// simple, expose sous forme de methodes et de streams, sans couche de state
/// management supplementaire. Gere aussi le mode invite (acces sans compte).
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const String _guestPrefKey = 'auth_guest_mode';

  SupabaseClient get _client => Supabase.instance.client;

  /// Vrai tant que l'utilisateur a choisi d'utiliser l'application sans compte.
  final ValueNotifier<bool> guestMode = ValueNotifier<bool>(false);

  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => currentSession?.user;

  Stream<AuthState> get authStateStream => _client.auth.onAuthStateChange;

  Future<void> loadGuestMode() async {
    final preferences = await SharedPreferences.getInstance();
    guestMode.value = preferences.getBool(_guestPrefKey) ?? false;
  }

  Future<void> enterGuestMode() async {
    guestMode.value = true;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_guestPrefKey, true);
  }

  Future<void> _exitGuestMode() async {
    guestMode.value = false;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_guestPrefKey, false);
  }

  Future<AuthError?> signIn({required String email, required String password}) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      await _exitGuestMode();
      return null;
    } on AuthException catch (error) {
      return _mapError(error);
    } catch (_) {
      return AuthError.network;
    }
  }

  Future<SignUpResult> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final name = displayName?.trim();
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {if (name != null && name.isNotEmpty) 'display_name': name},
      );
      if (response.session != null) await _exitGuestMode();
      return SignUpResult(confirmationRequired: response.session == null);
    } on AuthException catch (error) {
      return SignUpResult(confirmationRequired: false, error: _mapError(error));
    } catch (_) {
      return const SignUpResult(confirmationRequired: false, error: AuthError.network);
    }
  }

  Future<AuthError?> sendPasswordReset({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return null;
    } on AuthException catch (error) {
      return _mapError(error);
    } catch (_) {
      return AuthError.network;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {
      // La deconnexion ne doit jamais bloquer l'interface.
    }
    await _exitGuestMode();
  }

  /// Renvoie le nom affiche, depuis les metadonnees du compte puis la table
  /// `profiles`. Renvoie null si indisponible (jamais d'erreur bloquante).
  Future<String?> fetchDisplayName() async {
    final user = currentUser;
    if (user == null) return null;
    final metadata = user.userMetadata?['display_name'];
    if (metadata is String && metadata.trim().isNotEmpty) return metadata.trim();
    try {
      final row = await _client
          .from('profiles')
          .select('display_name')
          .eq('id', user.id)
          .maybeSingle();
      final name = row?['display_name'];
      if (name is String && name.trim().isNotEmpty) return name.trim();
    } catch (_) {
      // Le profil est optionnel : on retombe sur l'e-mail.
    }
    return null;
  }

  /// Reglages synchronises (langue, theme) stockes dans la table `profiles`.
  Future<Map<String, String?>?> fetchRemoteSettings() async {
    final user = currentUser;
    if (user == null) return null;
    try {
      final row = await _client
          .from('profiles')
          .select('locale, theme_mode')
          .eq('id', user.id)
          .maybeSingle();
      return {
        'locale': row?['locale'] as String?,
        'theme_mode': row?['theme_mode'] as String?,
      };
    } catch (_) {
      return null;
    }
  }

  Future<void> saveRemoteSettings({String? locale, String? themeMode}) async {
    final user = currentUser;
    if (user == null) return;
    try {
      await _client.from('profiles').update({
        if (locale != null) 'locale': locale,
        if (themeMode != null) 'theme_mode': themeMode,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', user.id);
    } catch (_) {
      // La synchronisation ne doit jamais bloquer l'application.
    }
  }

  AuthError _mapError(AuthException error) {
    final message = error.message.toLowerCase();
    if (message.contains('invalid login credentials')) return AuthError.invalidCredentials;
    if (message.contains('email not confirmed')) return AuthError.emailNotConfirmed;
    if (message.contains('already registered') || message.contains('already been registered')) {
      return AuthError.emailAlreadyUsed;
    }
    if (message.contains('password should')) return AuthError.weakPassword;
    if (message.contains('rate limit') || message.contains('too many')) return AuthError.rateLimited;
    return AuthError.unknown;
  }
}
