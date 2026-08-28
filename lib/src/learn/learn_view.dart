import 'package:flutter/material.dart';
import 'conjugation/conjugation_view.dart';
import 'vocab/vocab_view.dart';
import 'numdate/numdate_view.dart';
import 'grammar/grammar_view.dart';
import 'spelling/spelling_view.dart';

class LearnView extends StatelessWidget {
  const LearnView({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _ModuleTile(
        title: 'Conjugaison',
        subtitle: "S'entraîner à conjuguer",
        builder: (context) => const ConjugationView(),
        icon: Icons.edit_note,
      ),
      _ModuleTile(
        title: 'Vocabulaire',
        subtitle: 'Par thèmes et niveaux',
        builder: (context) => const VocabView(),
        icon: Icons.language,
      ),
      _ModuleTile(
        title: 'Nombres & Dates',
        subtitle: 'Écrire les nombres et dates',
        builder: (context) => const NumDateView(),
        icon: Icons.calendar_month,
      ),
      _ModuleTile(
        title: 'Grammaire',
        subtitle: 'Fiches de cours',
        builder: (context) => const GrammarView(),
        icon: Icons.menu_book,
      ),
      _ModuleTile(
        title: 'Orthographe',
        subtitle: 'Bientôt disponible',
        builder: (context) => const SpellingView(),
        icon: Icons.spellcheck,
      ),
    ];

    return ListView.separated(
      itemCount: tiles.length,
      itemBuilder: (context, index) => tiles[index],
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.title,
    required this.subtitle,
    required this.builder,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: builder),
      ),
    );
  }
}
