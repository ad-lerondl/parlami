import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';

class SpellingView extends StatelessWidget {
  const SpellingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.spellingTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.spellingComingSoon),
      ),
    );
  }
}
