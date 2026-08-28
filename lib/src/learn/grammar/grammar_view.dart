import 'package:flutter/material.dart';

class GrammarView extends StatelessWidget {
  const GrammarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammaire')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Fiches de grammaire — contenu à venir.\n\n'
          'Ajoutez des fiches dans ce module sous forme de pages ou de markdown rendu.',
        ),
      ),
    );
  }
}
