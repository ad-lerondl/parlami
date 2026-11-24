import 'package:flutter/material.dart';

import '../../data/models/performance_attempt.dart';
import '../../localization/app_localizations.dart';
import '../../repositories/performance_repository.dart';
import '../../services/noise_player_service.dart';
import '../../services/radio_player_service.dart';
import '../../services/radio_stations.dart';
import '../../services/study_session_tracker.dart';

/// Self-evaluation listening scenario: real Italian speech (live radio) mixed
/// with a generated background noise (hiss, crowd, music). The user rates
/// their own comprehension from 0 to 3 after listening.
class NoiseListeningView extends StatefulWidget {
  const NoiseListeningView({super.key});

  @override
  State<NoiseListeningView> createState() => _NoiseListeningViewState();
}

class _NoiseListeningViewState extends State<NoiseListeningView> {
  final RadioPlayerService _radioPlayerService = RadioPlayerService();
  final NoisePlayerService _noisePlayerService = NoisePlayerService();
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  final String _sessionId = DateTime.now().microsecondsSinceEpoch.toString();
  String _stationName = '';

  static const Map<String, String> _noisePaths = {
    'hiss': 'assets/audio/bruit_gresillement.wav',
    'crowd': 'assets/audio/bruit_ambiance.wav',
    'music': 'assets/audio/bruit_musique.wav',
  };

  String _noiseType = 'none';
  double _noiseVolume = 0.4;
  final List<int> _ratings = [];
  DateTime? _lastRatedAt;

  @override
  void initState() {
    super.initState();
    StudySessionTracker.instance.start('noisyListening');
  }

  @override
  void dispose() {
    StudySessionTracker.instance.stop();
    _noisePlayerService.stop();
    super.dispose();
  }

  Future<void> _setNoise(String type) async {
    setState(() => _noiseType = type);
    if (type == 'none') {
      await _noisePlayerService.stop();
      return;
    }
    final path = _noisePaths[type];
    if (path != null) {
      await _noisePlayerService.setVolume(_noiseVolume);
      await _noisePlayerService.play(path);
    }
  }

  Future<void> _setVolume(double value) async {
    setState(() => _noiseVolume = value);
    await _noisePlayerService.setVolume(value);
  }

  void _submitRating(int rating) {
    final now = DateTime.now();
    final sinceLast =
        _lastRatedAt == null ? null : now.difference(_lastRatedAt!).inMilliseconds;
    setState(() {
      _ratings.add(rating);
      _lastRatedAt = now;
    });
    _performanceRepository.record(PerformanceAttempt(
      id: 'noisyListening_${now.millisecondsSinceEpoch}',
      sessionId: _sessionId,
      skill: 'evaluate',
      exerciseType: 'noisyListening',
      itemId: 'noise',
      correct: null,
      rating: rating,
      durationMs: sinceLast,
      recordedAt: now,
      metadata: {
        'station': _stationName,
        'noiseType': _noiseType,
        'noiseVolume': _noiseVolume,
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.noiseTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.noiseIntro),
          const SizedBox(height: 16),

          Text(l10n.noiseStationLabel, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: italianRadioStations.map(_buildStationChip).toList(),
          ),
          const SizedBox(height: 20),

          Text(l10n.noiseTypeLabel, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'none', label: Text(l10n.noiseTypeNone)),
              ButtonSegment(value: 'hiss', label: Text(l10n.noiseTypeHiss)),
              ButtonSegment(value: 'crowd', label: Text(l10n.noiseTypeCrowd)),
              ButtonSegment(value: 'music', label: Text(l10n.noiseTypeMusic)),
            ],
            selected: {_noiseType},
            onSelectionChanged: (selection) => _setNoise(selection.first),
          ),
          const SizedBox(height: 16),
          Text('${l10n.noiseVolumeLabel} : ${(_noiseVolume * 100).round()}%'),
          Slider(
            value: _noiseVolume,
            onChanged: _setVolume,
          ),
          const SizedBox(height: 20),

          Text(l10n.noiseSelfRatePrompt, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (value) {
              return OutlinedButton(
                onPressed: () => _submitRating(value),
                child: Text('$value'),
              );
            }),
          ),
          const SizedBox(height: 16),

          if (_ratings.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.noiseSessionAverage(
                      (_ratings.reduce((a, b) => a + b) / _ratings.length)
                          .toStringAsFixed(1),
                    )),
                    const SizedBox(height: 4),
                    Text(
                      l10n.noiseRatings(_ratings.map((rating) => rating.toString()).join(', ')),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStationChip(RadioStation station) {
    return StreamBuilder<String?>(
      stream: _radioPlayerService.currentStationStream,
      builder: (context, stationSnapshot) {
        final current = stationSnapshot.data;
        return StreamBuilder<bool>(
          stream: _radioPlayerService.isPlayingStream,
          builder: (context, playingSnapshot) {
            final isActive = current == station.name && (playingSnapshot.data ?? false);
            return ChoiceChip(
              label: Text(station.name),
              selected: isActive,
              avatar: Icon(isActive ? Icons.volume_up : Icons.radio, size: 18),
              onSelected: (_) {
              setState(() => _stationName = station.name);
              _radioPlayerService.toggleStation(station.name, station.streamUrl);
            },
            );
          },
        );
      },
    );
  }
}

