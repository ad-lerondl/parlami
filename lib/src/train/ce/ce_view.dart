import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../localization/app_localizations.dart';

class NewsSource {
  final String name;
  final String url;
  final String descriptionKey;
  final String level;

  const NewsSource({
    required this.name,
    required this.url,
    required this.descriptionKey,
    required this.level,
  });
}

class CEView extends StatelessWidget {
  const CEView({super.key});

  static const newsSources = [
    NewsSource(
      name: 'ANSA - Facile',
      url: 'https://www.ansa.it/',
      descriptionKey: 'ceAnsaDescription',
      level: 'A2-B1',
    ),
    NewsSource(
      name: 'La Repubblica',
      url: 'https://www.repubblica.it/',
      descriptionKey: 'ceRepubblicaDescription',
      level: 'B2-C1',
    ),
    NewsSource(
      name: 'Corriere della Sera',
      url: 'https://www.corriere.it/',
      descriptionKey: 'ceCorriereDescription',
      level: 'B2-C1',
    ),
    NewsSource(
      name: 'Il Post',
      url: 'https://www.ilpost.it/',
      descriptionKey: 'ceIlPostDescription',
      level: 'B1-B2',
    ),
    NewsSource(
      name: 'RAI News',
      url: 'https://www.rainews.it/',
      descriptionKey: 'ceRaiDescription',
      level: 'B1-B2',
    ),
    NewsSource(
      name: 'Easy Italian News',
      url: 'https://www.newsinslowitalian.com/',
      descriptionKey: 'ceEasyItalianDescription',
      level: 'A1-A2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.ceTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.ceIntro,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.ceAdviceTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(l10n.ceAdvice),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...newsSources.map((source) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      source.level.split('-')[0],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  title: Text(source.name),
                  subtitle: Text('${_descriptionFor(source, l10n)}\n${l10n.ceLevel(source.level)}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    tooltip: AppLocalizations.of(context)!.ceOpenSource,
                    onPressed: () => launchUrl(
                      Uri.parse(source.url),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  String _descriptionFor(NewsSource source, AppLocalizations l10n) {
    return switch (source.descriptionKey) {
      'ceAnsaDescription' => l10n.ceAnsaDescription,
      'ceRepubblicaDescription' => l10n.ceRepubblicaDescription,
      'ceCorriereDescription' => l10n.ceCorriereDescription,
      'ceIlPostDescription' => l10n.ceIlPostDescription,
      'ceRaiDescription' => l10n.ceRaiDescription,
      'ceEasyItalianDescription' => l10n.ceEasyItalianDescription,
      _ => source.descriptionKey,
    };
  }
}
