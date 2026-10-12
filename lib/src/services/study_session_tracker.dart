import 'dart:async';

import 'package:flutter/widgets.dart';

import '../data/models/performance_attempt.dart';
import '../repositories/performance_repository.dart';

class StudySessionTracker with WidgetsBindingObserver {
  StudySessionTracker._();

  static final StudySessionTracker instance = StudySessionTracker._();

  final PerformanceRepository _repository = PerformanceRepository();
  String? _skill;
  DateTime? _activeStartedAt;
  Duration _activeDuration = Duration.zero;
  String? _sessionId;
  bool _observing = false;

  Future<void> start(String skill) async {
    if (_skill == skill && _sessionId != null) return;
    await stop();
    _skill = skill;
    _sessionId = '${skill}_${DateTime.now().microsecondsSinceEpoch}';
    _activeStartedAt = DateTime.now();
    _activeDuration = Duration.zero;
    if (!_observing) {
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    }
  }

  Future<void> stop() async {
    _commitActiveTime();
    final skill = _skill;
    final sessionId = _sessionId;
    final duration = _activeDuration;
    _skill = null;
    _sessionId = null;
    _activeStartedAt = null;
    _activeDuration = Duration.zero;
    if (skill != null && sessionId != null && duration.inSeconds > 0) {
      await _repository.record(
        PerformanceAttempt(
          id: sessionId,
          sessionId: sessionId,
          skill: skill,
          exerciseType: 'study_session',
          itemId: sessionId,
          recordedAt: DateTime.now(),
          durationMs: duration.inMilliseconds,
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_skill != null && _activeStartedAt == null) _activeStartedAt = DateTime.now();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _commitActiveTime();
      _activeStartedAt = null;
    }
  }

  void _commitActiveTime() {
    final startedAt = _activeStartedAt;
    if (startedAt == null) return;
    _activeDuration += DateTime.now().difference(startedAt);
    _activeStartedAt = null;
  }
}
