import 'dart:async';

import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';

import '../../services/radio_player_service.dart';

class RadioStation {
  final String name;
  final String streamUrl;
  final String descriptionKey;
  final String region;

  const RadioStation({
    required this.name,
    required this.streamUrl,
    required this.descriptionKey,
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
      descriptionKey: 'coRadioGeneral',
      region: 'National',
    ),
    RadioStation(
      name: 'Radio RAI 2',
      streamUrl: 'https://icestreaming.rai.it/2.mp3',
      descriptionKey: 'coMusicEntertainment',
      region: 'National',
    ),
    RadioStation(
      name: 'Radio RAI 3',
      streamUrl: 'https://icestreaming.rai.it/3.mp3',
      descriptionKey: 'coCultureNews',
      region: 'National',
    ),
    RadioStation(
      name: 'RDS',
      streamUrl: 'https://icstream.rds.radio/rds',
      descriptionKey: 'coPopNews',
      region: 'National',
    ),
    RadioStation(
      name: 'Radio 105',
      streamUrl: 'https://icy.unitedradio.it/Radio105.mp3',
      descriptionKey: 'coMusicEntertainment',
      region: 'National',
    ),
    RadioStation(
      name: 'RTL 102.5',
      streamUrl: 'https://streamingv2.shoutcast.com/rtl-1025',
      descriptionKey: 'coRadioNewsMusic',
      region: 'National',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _radioPlayerService = RadioPlayerService();

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

    final l10n = AppLocalizations.of(context)!;
    final message = (wasPlaying && wasCurrentStation) ? l10n.coStopped(station.name) : l10n.coConnecting(station.name);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.coTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.coIntro,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ...stations.map((station) => _buildStationCard(station)),
              ],
            ),
          ),
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
            subtitle: Text(
              '${_descriptionFor(station, AppLocalizations.of(context)!)}\n${AppLocalizations.of(context)!.coNational}',
            ),
            isThreeLine: true,
            trailing: StreamBuilder<bool>(
              stream: _radioPlayerService.isPlayingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(isCurrentStation && isPlaying ? Icons.pause : Icons.play_arrow),
                  tooltip: isCurrentStation && isPlaying
                      ? AppLocalizations.of(context)!.coPause
                      : AppLocalizations.of(context)!.coResume,
                  onPressed: () => _toggleStation(station),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _descriptionFor(RadioStation station, AppLocalizations l10n) {
    return switch (station.descriptionKey) {
      'coRadioGeneral' => l10n.coRadioGeneral,
      'coMusicEntertainment' => l10n.coMusicEntertainment,
      'coCultureNews' => l10n.coCultureNews,
      'coPopNews' => l10n.coPopNews,
      'coRadioNewsMusic' => l10n.coRadioNewsMusic,
      _ => station.descriptionKey,
    };
  }
}
