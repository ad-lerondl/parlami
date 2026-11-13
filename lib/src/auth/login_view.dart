import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../settings/language_names.dart';
import '../settings/settings_controller.dart';
import 'auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _isSignUp = false;
  bool _busy = false;
  String? _infoMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  String _localizeError(AuthError error, AppLocalizations l10n) {
    switch (error) {
      case AuthError.invalidCredentials:
        return l10n.authErrorInvalidCredentials;
      case AuthError.emailNotConfirmed:
        return l10n.authErrorEmailNotConfirmed;
      case AuthError.emailAlreadyUsed:
        return l10n.authErrorEmailUsed;
      case AuthError.weakPassword:
        return l10n.authErrorWeakPassword;
      case AuthError.rateLimited:
        return l10n.authErrorRateLimited;
      case AuthError.network:
        return l10n.authErrorNetwork;
      case AuthError.unknown:
        return l10n.authErrorGeneric;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _leaveAfterSuccess() {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  Future<void> _submit() async {
    if (_busy || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _infoMessage = null;
    });
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isSignUp) {
      final result = await AuthService.instance.signUp(
        email: email,
        password: password,
        displayName: _displayNameController.text,
      );
      if (!mounted) return;
      setState(() => _busy = false);
      if (result.success) {
        if (result.confirmationRequired) {
          setState(() => _infoMessage = l10n.authConfirmEmailSent);
        } else {
          _leaveAfterSuccess();
        }
        return;
      }
      _showMessage(_localizeError(result.error!, l10n));
      return;
    }

    final error = await AuthService.instance.signIn(email: email, password: password);
    if (!mounted) return;
    setState(() => _busy = false);
    if (error == null) {
      _leaveAfterSuccess();
      return;
    }
    _showMessage(_localizeError(error, l10n));
  }

  Future<void> _sendPasswordReset() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showMessage(l10n.authErrorGeneric);
      return;
    }
    setState(() => _busy = true);
    final error = await AuthService.instance.sendPasswordReset(email: email);
    if (!mounted) return;
    setState(() => _busy = false);
    if (error == null) {
      setState(() => _infoMessage = l10n.authResetEmailSent);
      return;
    }
    _showMessage(_localizeError(error, l10n));
  }

  Future<void> _continueWithoutAccount() async {
    await AuthService.instance.enterGuestMode();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: DropdownButton<Locale>(
                            value: widget.settingsController.locale,
                            underline: const SizedBox.shrink(),
                            items: AppLocalizations.supportedLocales
                                .map((locale) => DropdownMenuItem(
                                      value: locale,
                                      child: Text(
                                        languageNames[locale.languageCode] ??
                                            locale.languageCode,
                                      ),
                                    ))
                                .toList(),
                            onChanged: widget.settingsController.updateLocale,
                          ),
                        ),
                        Text(
                          l10n.authWelcomeTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.authWelcomeSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: l10n.authEmail,
                            prefixIcon: const Icon(Icons.alternate_email),
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty || !email.contains('@')) {
                              return l10n.authErrorInvalidCredentials;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: l10n.authPassword,
                            helperText: _isSignUp ? l10n.authPasswordRule : null,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          validator: (value) {
                            final password = value ?? '';
                            if (password.length < 6) return l10n.authErrorWeakPassword;
                            return null;
                          },
                        ),
                        if (_isSignUp) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _displayNameController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: l10n.authDisplayName,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _busy ? null : _submit,
                          child: _busy
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(_isSignUp ? l10n.authSignUp : l10n.authSignIn),
                        ),
                        if (!_isSignUp)
                          TextButton(
                            onPressed: _busy ? null : _sendPasswordReset,
                            child: Text(l10n.authForgotPassword),
                          ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: _busy ? null : _continueWithoutAccount,
                          child: Text(l10n.authContinueWithoutAccount),
                        ),
                        TextButton(
                          onPressed: _busy
                              ? null
                              : () => setState(() {
                                    _isSignUp = !_isSignUp;
                                    _infoMessage = null;
                                  }),
                          child: Text(
                              _isSignUp ? l10n.authSwitchToSignIn : l10n.authSwitchToSignUp),
                        ),
                        if (_infoMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _infoMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
