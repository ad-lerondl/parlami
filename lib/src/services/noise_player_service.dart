import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// Plays a looping background-noise asset (static, crowd murmur, soft music)
/// on top of the live radio used by the noisy-listening exercise.
///
/// The player uses its own [AudioPlayer] instance on purpose: it must mix with
/// [RadioPlayerService] instead of replacing it.
class NoisePlayerService {
  NoisePlayerService._internal();

  static final NoisePlayerService _instance = NoisePlayerService._internal();

  factory NoisePlayerService() => _instance;

  AudioPlayer? _player;
  String? _currentAsset;
  double _volume = 0.4;

  double get volume => _volume;

  Future<void> play(String assetPath) async {
    if (assetPath == _currentAsset) return;
    await stop();
    try {
      final player = _player ?? AudioPlayer();
      _player = player;
      await player.setAsset(
        assetPath,
        tag: const MediaItem(
          id: 'noise',
          album: 'Parlami',
          title: 'Bruit de fond',
        ),
      );
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(_volume);
      await player.play();
      _currentAsset = assetPath;
    } catch (_) {
      _currentAsset = null;
    }
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _player?.setVolume(_volume);
  }

  Future<void> stop() async {
    _currentAsset = null;
    final player = _player;
    if (player != null) {
      try {
        await player.stop();
      } catch (_) {
        // Ignore: stopping must never crash the UI.
      }
    }
  }
}
