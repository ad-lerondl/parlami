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
/// management supplementaire.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  SupabaseClient get _client => Supabase.instance.client;

  bool get isConfigured => isSupabaseConfigured;

  Session? get currentSession => isConfigured ? _client.auth.currentSession : null;

  User? get currentUser => currentSession?.user;

  Stream<AuthState> get authStateStream =>
      isConfigured ? _client.auth.onAuthStateChange : const Stream<AuthState>.empty();

  Future<AuthError?> signIn({required String email, required String password}) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
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
    if (!isConfigured) return;
    try {
      await _client.auth.signOut();
    } catch (_) {
      // La deconnexion ne doit jamais bloquer l'interface.
    }
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
