import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/radio_player_service.dart';

class RadioStation {
  final String name;
  final String streamUrl;
  final String description;
  final String region;

  const RadioStation({
    required this.name,
    required this.streamUrl,
    required this.description,
    required this.region,
  });
}

class COView extends StatefulWidget {
  const COView({super.key});

  @override
  State<COView> createState() => _COViewState();
}

class _COViewState extends State<COView> {
  late final RadioPlayerService _radioPlayerService;
  StreamSubscription<String?>? _errorSubscription;

  static const stations = [
    RadioStation(
      name: 'Radio RAI 1',
      streamUrl: 'https://icestreaming.rai.it/1.mp3',
      description: 'Radio généraliste italienne',
      region: 'National',
    ),
    RadioStation(
      name: 'Radio RAI 2',
      streamUrl: 'https://icestreaming.rai.it/2.mp3',
      description: 'Musique et divertissement',
      region: 'National',
    ),
    RadioStation(
      name: 'Radio RAI 3',
      streamUrl: 'https://icestreaming.rai.it/3.mp3',
      description: 'Culture et actualités',
      region: 'National',
    ),
    RadioStation(
      name: 'RDS',
      streamUrl: 'https://icstream.rds.radio/rds',
      description: 'Musique pop et actualités',
      region: 'National',
    ),
    RadioStation(
      name: 'Radio 105',
      streamUrl: 'https://icy.unitedradio.it/Radio105.mp3',
      description: 'Musique et divertissement',
      region: 'National',
    ),
    RadioStation(
      name: 'RTL 102.5',
      streamUrl: 'https://streamingv2.shoutcast.com/rtl-1025',
      description: 'Actualités et musique',
      region: 'National',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _radioPlayerService = RadioPlayerService();

    // Écouter les erreurs
    _errorSubscription = _radioPlayerService.errorStream.listen((error) {
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _errorSubscription?.cancel();
    super.dispose();
  }

  void _toggleStation(RadioStation station) {
    final wasPlaying = _radioPlayerService.isPlaying;
    final wasCurrentStation = _radioPlayerService.currentStation == station.name;

    _radioPlayerService.toggleStation(station.name, station.streamUrl);

    final message = (wasPlaying && wasCurrentStation) ? '${station.name} arrêtée' : 'Connexion à ${station.name}...';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CO - Compréhension Orale')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Écoutez des radios italiennes pour améliorer votre compréhension orale',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ...stations.map((station) => _buildStationCard(station)),
              ],
            ),
          ),
          _buildPlayerBar(),
        ],
      ),
    );
  }

  Widget _buildStationCard(RadioStation station) {
    return StreamBuilder<String?>(
      stream: _radioPlayerService.currentStationStream,
      builder: (context, snapshot) {
        final isCurrentStation = snapshot.data == station.name;
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isCurrentStation ? Colors.red : Colors.grey[300],
              child: Icon(
                Icons.radio,
                color: isCurrentStation ? Colors.white : Colors.black,
              ),
            ),
            title: Text(station.name),
            subtitle: Text('${station.description}\n${station.region}'),
            isThreeLine: true,
            trailing: StreamBuilder<bool>(
              stream: _radioPlayerService.isPlayingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(
                    isCurrentStation && isPlaying ? Icons.radio_button_checked : Icons.play_arrow,
                  ),
                  onPressed: () => _toggleStation(station),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerBar() {
    return StreamBuilder<String?>(
      stream: _radioPlayerService.currentStationStream,
      builder: (context, snapshot) {
        final stationName = snapshot.data;
        if (stationName == null) return const SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(
            color: Colors.red[600],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'En direct:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      stationName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              StreamBuilder<bool>(
                stream: _radioPlayerService.isPlayingStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      isPlaying ? Icons.stop_circle : Icons.play_circle,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      final selected = stations.firstWhere(
                        (station) => station.name == stationName,
                        orElse: () => stations.first,
                      );
                      _toggleStation(selected);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
