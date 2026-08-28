import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsSource {
  final String name;
  final String url;
  final String description;
  final String level;

  const NewsSource({
    required this.name,
    required this.url,
    required this.description,
    required this.level,
  });
}

class CEView extends StatelessWidget {
  const CEView({super.key});

  static const newsSources = [
    NewsSource(
      name: 'ANSA - Facile',
      url: 'https://www.ansa.it/',
      description: 'Agence de presse italienne - articles courts',
      level: 'A2-B1',
    ),
    NewsSource(
      name: 'La Repubblica',
      url: 'https://www.repubblica.it/',
      description: 'Grand quotidien italien',
      level: 'B2-C1',
    ),
    NewsSource(
      name: 'Corriere della Sera',
      url: 'https://www.corriere.it/',
      description: 'Journal de référence',
      level: 'B2-C1',
    ),
    NewsSource(
      name: 'Il Post',
      url: 'https://www.ilpost.it/',
      description: 'Actualités et analyses',
      level: 'B1-B2',
    ),
    NewsSource(
      name: 'RAI News',
      url: 'https://www.rainews.it/',
      description: 'Actualités de la RAI',
      level: 'B1-B2',
    ),
    NewsSource(
      name: 'Easy Italian News',
      url: 'https://www.newsinslowitalian.com/',
      description: 'Nouvelles en italien facile',
      level: 'A1-A2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CE - Compréhension Écrite')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Lisez des articles en italien pour améliorer votre compréhension écrite',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Conseil', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                      'Commencez par des articles courts. Lisez d\'abord pour comprendre le sens général, puis relisez pour les détails.'),
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
                  subtitle: Text('${source.description}\nNiveau: ${source.level}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
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
}
