import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class EvaluateView extends StatelessWidget {
  const EvaluateView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scenarios = [
      _Scenario(
        title: l10n.scenarioDailyConversation,
        subtitle: l10n.evaluateScenarioOral,
        details: l10n.scenarioDailyConversationDetails,
        icon: Icons.forum,
      ),
      _Scenario(
        title: l10n.scenarioArticleSummary,
        subtitle: l10n.evaluateScenarioWritten,
        details: l10n.scenarioArticleSummaryDetails,
        icon: Icons.summarize,
      ),
      _Scenario(
        title: l10n.scenarioMatchDebrief,
        subtitle: l10n.evaluateScenarioCulture,
        details: l10n.scenarioMatchDebriefDetails,
        icon: Icons.sports_soccer,
      ),
      _Scenario(
        title: l10n.scenarioQuickDiscussion,
        subtitle: l10n.evaluateScenarioSpeed,
        details: l10n.scenarioQuickDiscussionDetails,
        icon: Icons.speed,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.evaluateTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.evaluateIntro,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.evaluateProgression,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
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
