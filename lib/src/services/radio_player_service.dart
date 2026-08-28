import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class RadioPlayerService {
  static final RadioPlayerService _instance = RadioPlayerService._internal();

  late AudioPlayer _audioPlayer;
  StreamSubscription<PlaybackEvent>? _playbackEventSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  final _isPlayingSubject = BehaviorSubject<bool>.seeded(false);
  final _currentStationSubject = BehaviorSubject<String?>.seeded(null);
  final _errorSubject = BehaviorSubject<String?>.seeded(null);

  factory RadioPlayerService() {
    return _instance;
  }

  RadioPlayerService._internal() {
    _audioPlayer = AudioPlayer();
    _configureAudioSession();
    _setupAudioPlayerListeners();
  }

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  void _setupAudioPlayerListeners() {
    _playbackEventSubscription = _audioPlayer.playbackEventStream.listen(
      (event) {
        _isPlayingSubject.add(_audioPlayer.playing);
      },
      onError: (error) {
        String errorMessage = 'Erreur de lecture';
        if (error.toString().contains('Unable to resolve host') || error.toString().contains('UnknownHostException')) {
          errorMessage = 'Impossible de se connecter à cette radio';
        } else if (error.toString().contains('Source error')) {
          errorMessage = 'Cette radio n\'est pas disponible';
        }
        _errorSubject.add(errorMessage);
        _currentStationSubject.add(null);
        _isPlayingSubject.add(false);
      },
    );

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.idle) {
        _isPlayingSubject.add(false);
      }
      // Détecter les erreurs de chargement
      if (playerState.processingState == ProcessingState.idle &&
          playerState.playing == false &&
          _currentStationSubject.value != null) {
        _errorSubject.add('Impossible de charger cette radio');
        _currentStationSubject.add(null);
      }
    });
  }

  Stream<bool> get isPlayingStream => _isPlayingSubject.stream;
  Stream<String?> get currentStationStream => _currentStationSubject.stream;
  Stream<String?> get errorStream => _errorSubject.stream;

  bool get isPlaying => _isPlayingSubject.value;
  String? get currentStation => _currentStationSubject.value;

  Future<void> toggleStation(String stationName, String streamUrl) async {
    final isSameStation = _currentStationSubject.value == stationName;
    if (isSameStation && _audioPlayer.playing) {
      await stop();
      return;
    }

    await _startStation(stationName, streamUrl);
  }

  Future<void> playRadio(String stationName, String streamUrl) async {
    await _startStation(stationName, streamUrl);
  }

  Future<void> _startStation(String stationName, String streamUrl) async {
    try {
      _errorSubject.add(null);
      _currentStationSubject.add(stationName);

      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      final mediaItem = MediaItem(
        id: streamUrl,
        title: stationName,
        artist: 'Parlami Radio',
        album: 'Compréhension orale',
      );

      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: mediaItem,
        ),
      );
      await _audioPlayer.play();
    } catch (e) {
      String errorMessage = 'Erreur de connexion';
      final errorStr = e.toString().toLowerCase();

      if (errorStr.contains('unknownhostexception') ||
          errorStr.contains('socketexception') ||
          errorStr.contains('unable to resolve host')) {
        errorMessage = 'Impossible de se connecter à $stationName. Vérifiez votre connexion Internet.';
      } else if (errorStr.contains('source error') || errorStr.contains('invalid url') || errorStr.contains('404')) {
        errorMessage = '$stationName n\'est pas disponible pour le moment';
      } else if (errorStr.contains('timeout')) {
        errorMessage = 'Délai d\'attente dépassé pour $stationName';
      } else {
        errorMessage = 'Erreur lors de la lecture de $stationName';
      }

      _errorSubject.add(errorMessage);
      _currentStationSubject.add(null);
      _isPlayingSubject.add(false);
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _currentStationSubject.add(null);
      _isPlayingSubject.add(false);
    } catch (e) {
      _errorSubject.add('Erreur lors de l\'arrêt: ${e.toString()}');
    }
  }

  void dispose() {
    _playbackEventSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    _isPlayingSubject.close();
    _currentStationSubject.close();
    _errorSubject.close();
  }
}
