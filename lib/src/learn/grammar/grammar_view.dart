import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';

class GrammarView extends StatelessWidget {
  const GrammarView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.grammarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          l10n.grammarComingSoon,
        ),
      ),
    );
  }
}
