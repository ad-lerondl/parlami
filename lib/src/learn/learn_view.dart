import 'package:flutter/material.dart';
import 'conjugation/conjugation_view.dart';
import 'vocab/vocab_view.dart';
import 'numdate/numdate_view.dart';
import 'grammar/grammar_view.dart';
import 'spelling/spelling_view.dart';
import '../localization/app_localizations.dart';
import '../widgets/module_info_sheet.dart';

class LearnView extends StatelessWidget {
  const LearnView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tiles = [
      _ModuleTile(
        title: l10n.learnConjugation,
        subtitle: l10n.learnConjugationDescription,
        why: l10n.learnConjugationWhy,
        builder: (context) => const ConjugationView(),
        icon: Icons.edit_note,
      ),
      _ModuleTile(
        title: l10n.learnVocabulary,
        subtitle: l10n.learnVocabularyDescription,
        why: l10n.learnVocabularyWhy,
        builder: (context) => const VocabView(),
        icon: Icons.language,
      ),
      _ModuleTile(
        title: l10n.learnNumbersDates,
        subtitle: l10n.learnNumbersDatesDescription,
        why: l10n.learnNumbersDatesWhy,
        builder: (context) => const NumDateView(),
        icon: Icons.calendar_month,
      ),
      _ModuleTile(
        title: l10n.learnGrammar,
        subtitle: l10n.learnGrammarDescription,
        why: l10n.learnGrammarWhy,
        builder: (context) => const GrammarView(),
        icon: Icons.menu_book,
      ),
      _ModuleTile(
        title: l10n.learnSpelling,
        subtitle: l10n.learnSpellingDescription,
        why: l10n.learnSpellingWhy,
        builder: (context) => const SpellingView(),
        icon: Icons.spellcheck,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            l10n.learnSectionIntro,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: tiles.length,
            itemBuilder: (context, index) => tiles[index],
            separatorBuilder: (_, __) => const Divider(height: 0),
          ),
        ),
      ],
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.title,
    required this.subtitle,
    required this.why,
    required this.builder,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final String why;
  final WidgetBuilder builder;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.info_outline, size: 20),
            color: Theme.of(context).colorScheme.outline,
            tooltip: l10n.moduleWhyTitle,
            onPressed: () => showModuleInfoSheet(
              context,
              icon: icon,
              heading: l10n.moduleWhyTitle,
              title: title,
              message: why,
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: builder),
      ),
    );
  }
}
