import 'package:flutter/material.dart';

class EvaluateView extends StatelessWidget {
  const EvaluateView({super.key});

  @override
  Widget build(BuildContext context) {
    final scenarios = [
      const _Scenario(
        title: 'Conversation du quotidien',
        subtitle: 'CO + EO',
        details: 'Ecouter, comprendre puis repondre naturellement.',
        icon: Icons.forum,
      ),
      const _Scenario(
        title: 'Resume d\'article',
        subtitle: 'CE + EE',
        details: 'Lire un texte puis produire un resume clair et structure.',
        icon: Icons.summarize,
      ),
      const _Scenario(
        title: 'Debrief de match',
        subtitle: 'EO + Culture',
        details: 'Parler d\'un match en mobilisant vocabulaire et references culturelles.',
        icon: Icons.sports_soccer,
      ),
      const _Scenario(
        title: 'Discussion rapide',
        subtitle: 'CO + EO + Rapidite',
        details: 'Reagir vite dans un echange dynamique avec contraintes de temps.',
        icon: Icons.speed,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Se tester - Conditions reelles")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Ici, tu combines plusieurs competences en meme temps pour simuler des situations reelles.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          const Text(
            "Apprendre pose les bases. S'entrainer travaille des points isoles. Se tester mesure ta maitrise globale.",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ...scenarios.map((scenario) => _ScenarioCard(scenario: scenario)),
        ],
      ),
    );
  }
}

class _Scenario {
  const _Scenario({
    required this.title,
    required this.subtitle,
    required this.details,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String details;
  final IconData icon;
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final _Scenario scenario;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          child: Icon(scenario.icon),
        ),
        title: Text(scenario.title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('${scenario.subtitle}\n${scenario.details}'),
        ),
        isThreeLine: true,
      ),
    );
  }
}
