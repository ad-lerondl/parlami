import 'dart:math';

import 'package:flutter/material.dart';
import '../../data/models/performance_attempt.dart';
import '../../localization/app_localizations.dart';
import '../../repositories/performance_repository.dart';
import '../../services/study_session_tracker.dart';

import 'date_words.dart';
import 'number_words.dart';
import 'time_words.dart';

class NumDateView extends StatefulWidget {
  const NumDateView({super.key, this.random});

  final Random? random;

  @override
  State<NumDateView> createState() => _NumDateViewState();
}

enum _AnswerState { idle, correct, incorrect }

class _NumDateViewState extends State<NumDateView> {
  late final Random _random = widget.random ?? Random();
  final PerformanceRepository _performanceRepository = PerformanceRepository();
  final String _sessionId = DateTime.now().microsecondsSinceEpoch.toString();
  DateTime _exerciseStartedAt = DateTime.now();

  final TextEditingController _numberPreviewController = TextEditingController();
  final TextEditingController _numberTargetController = TextEditingController();
  final TextEditingController _numberAnswerController = TextEditingController();
  final TextEditingController _dateAnswerController = TextEditingController();
  final TextEditingController _timeAnswerController = TextEditingController();

  DateTime _previewDate = DateTime.now();
  DateTime _exerciseDate = DateTime.now();
  TimeOfDay _previewTime = const TimeOfDay(hour: 8, minute: 15);
  TimeOfDay _exerciseTime = const TimeOfDay(hour: 8, minute: 15);

  _AnswerState _numberState = _AnswerState.idle;
  _AnswerState _dateState = _AnswerState.idle;
  _AnswerState _timeState = _AnswerState.idle;
  String? _numberAttempt;
  String? _dateAttempt;
  String? _timeAttempt;

  @override
  void initState() {
    super.initState();
    StudySessionTracker.instance.start('numdate');
    _numberPreviewController.text = _initialNumberTarget().toString();
    _numberTargetController.text = _initialNumberTarget().toString();
    _previewDate = _initialDateTarget();
    _exerciseDate = _initialDateTarget();
    _previewTime = _initialTimeTarget();
    _exerciseTime = _initialTimeTarget();
  }

  @override
  void dispose() {
    StudySessionTracker.instance.stop();
    _numberPreviewController.dispose();
    _numberTargetController.dispose();
    _numberAnswerController.dispose();
    _dateAnswerController.dispose();
    _timeAnswerController.dispose();
    super.dispose();
  }

  int _initialNumberTarget() => _random.nextInt(1000000);

  DateTime _initialDateTarget() {
    final year = 1950 + _random.nextInt(151);
    final month = 1 + _random.nextInt(12);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final day = 1 + _random.nextInt(daysInMonth);
    return DateTime(year, month, day);
  }

  TimeOfDay _initialTimeTarget() {
    final hour = _random.nextInt(24);
    const minuteChoices = [0, 15, 30, 45];
    final minute = minuteChoices[_random.nextInt(minuteChoices.length)];
    return TimeOfDay(hour: hour, minute: minute);
  }

  int? _parseNumberTarget() => int.tryParse(_numberTargetController.text.trim());

  String _normalize(String value) {
    final lower = value.toLowerCase().trim();
    const replacements = {
      'à': 'a',
      'á': 'a',
      'â': 'a',
      'ä': 'a',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'ö': 'o',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      '’': ' ',
      '-': ' ',
      ',': ' ',
      '.': ' ',
      '/': ' ',
    };

    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(replacements[char] ?? char);
    }
    return buffer.toString().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  String _timeLabel(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _checkNumberAnswer() async {
    final target = _parseNumberTarget();
    final expected = target == null ? '' : numberToItalian(target);
    final attempt = _numberAnswerController.text.trim();
    final correct = target != null && _normalize(attempt) == _normalize(expected);
    setState(() {
      _numberAttempt = attempt;
      _numberState = correct ? _AnswerState.correct : _AnswerState.incorrect;
    });
    await _recordAttempt('number', target?.toString() ?? 'invalid', attempt, correct);
  }

  Future<void> _checkDateAnswer() async {
    final expected = italianDateWords(_exerciseDate);
    final attempt = _dateAnswerController.text.trim();
    final correct = _normalize(attempt) == _normalize(expected);
    setState(() {
      _dateAttempt = attempt;
      _dateState = correct ? _AnswerState.correct : _AnswerState.incorrect;
    });
    await _recordAttempt('date', _exerciseDate.toIso8601String(), attempt, correct);
  }

  Future<void> _checkTimeAnswer() async {
    final expected = italianTimeWords(_exerciseTime);
    final attempt = _timeAnswerController.text.trim();
    final correct = _normalize(attempt) == _normalize(expected);
    setState(() {
      _timeAttempt = attempt;
      _timeState = correct ? _AnswerState.correct : _AnswerState.incorrect;
    });
    await _recordAttempt('time', _timeLabel(_exerciseTime), attempt, correct);
  }

  Future<void> _recordAttempt(String exerciseType, String itemId, String answer, bool correct) async {
    final targetValue = exerciseType == 'number' ? int.tryParse(itemId) : null;
    final now = DateTime.now();
    await _performanceRepository.record(
      PerformanceAttempt(
        id: '${_sessionId}_${now.microsecondsSinceEpoch}',
        sessionId: _sessionId,
        skill: 'numdate',
        exerciseType: exerciseType,
        itemId: itemId,
        recordedAt: now,
        correct: correct,
        durationMs: now.difference(_exerciseStartedAt).inMilliseconds,
        metadata: {
          'answer': answer,
          if (targetValue != null) ...{
            'targetValue': targetValue,
            'magnitude': targetValue.abs().toString().length,
            'difficultyBand': _numberDifficultyBand(targetValue),
          },
        },
      ),
    );
    _exerciseStartedAt = now;
  }

  String _numberDifficultyBand(int value) {
    final magnitude = value.abs();
    if (magnitude < 100) return '0–99';
    if (magnitude < 1000) return '100–999';
    if (magnitude < 10000) return '1 000–9 999';
    if (magnitude < 1000000) return '10 000–999 999';
    return '1 000 000+';
  }

  Future<void> _pickPreviewDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: _previewDate,
    );
    if (picked != null) {
      setState(() => _previewDate = picked);
    }
  }

  Future<void> _pickExerciseDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: _exerciseDate,
    );
    if (picked != null) {
      setState(() {
        _exerciseDate = picked;
        _dateState = _AnswerState.idle;
        _dateAttempt = null;
        _dateAnswerController.clear();
      });
    }
  }

  Future<void> _pickPreviewTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _previewTime,
    );
    if (picked != null) {
      setState(() => _previewTime = picked);
    }
  }

  Future<void> _pickExerciseTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _exerciseTime,
    );
    if (picked != null) {
      setState(() {
        _exerciseTime = picked;
        _timeState = _AnswerState.idle;
        _timeAttempt = null;
        _timeAnswerController.clear();
      });
    }
  }

  void _setPreviewDate(DateTime date) {
    setState(() => _previewDate = date);
  }

  void _setExerciseDate(DateTime date) {
    setState(() {
      _exerciseDate = date;
      _dateState = _AnswerState.idle;
      _dateAttempt = null;
      _dateAnswerController.clear();
    });
  }

  void _setPreviewTime(TimeOfDay time) {
    setState(() => _previewTime = time);
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required _AnswerState state,
    required String expected,
    required String? attempt,
  }) {
    if (state == _AnswerState.idle) {
      return const SizedBox.shrink();
    }

    final isCorrect = state == _AnswerState.correct;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final background = isCorrect ? colors.primaryContainer : colors.errorContainer;
    final foreground = isCorrect ? colors.onPrimaryContainer : colors.onErrorContainer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? l10n.answerCorrect : l10n.answerIncorrect,
            style: theme.textTheme.titleMedium?.copyWith(color: foreground),
          ),
          if (attempt != null && attempt.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(l10n.answerYourAnswer(attempt), style: theme.textTheme.bodyMedium?.copyWith(color: foreground)),
          ],
          const SizedBox(height: 8),
          Text(l10n.answerExpected(expected), style: theme.textTheme.bodyMedium?.copyWith(color: foreground)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildNumberTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final previewTarget = int.tryParse(_numberPreviewController.text.trim());
    final target = _parseNumberTarget();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard(
          context: context,
          title: l10n.numDatePreviewNumberTitle,
          subtitle: l10n.numDatePreviewNumberSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _numberPreviewController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.numDatePreviewNumberLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              SelectableText(
                previewTarget == null ? l10n.numDatePositiveInteger : numberToItalian(previewTarget),
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          context: context,
          title: l10n.numDateTraining,
          subtitle: l10n.numDateTrainingNumberSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _numberTargetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.numDateTrainingNumberLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {
                  _numberState = _AnswerState.idle;
                  _numberAttempt = null;
                  _numberAnswerController.clear();
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _numberAnswerController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.numDateAnswerInWords,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _checkNumberAnswer(),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: target == null ? null : _checkNumberAnswer,
                    icon: const Icon(Icons.check),
                    label: Text(l10n.numDateCheck),
                  ),
                  OutlinedButton.icon(
                    onPressed: target == null
                        ? null
                        : () => setState(() {
                              _numberState = _AnswerState.idle;
                              _numberAttempt = null;
                              _numberAnswerController.clear();
                              _numberTargetController.text = _initialNumberTarget().toString();
                            }),
                    icon: const Icon(Icons.clear),
                    label: Text(l10n.numDateClear),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildStatusCard(
                context: context,
                state: _numberState,
                attempt: _numberAttempt,
                expected: target == null ? '' : numberToItalian(target),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard(
          context: context,
          title: l10n.numDatePreviewDateTitle,
          subtitle: l10n.numDatePreviewDateSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(italianDateWords(_previewDate)),
                subtitle: Text(
                  '${_previewDate.day.toString().padLeft(2, '0')}/${_previewDate.month.toString().padLeft(2, '0')}/${_previewDate.year}',
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickPreviewDate,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () => _setPreviewDate(DateTime.now()),
                    child: Text(l10n.numDateToday),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          context: context,
          title: l10n.numDateTraining,
          subtitle: l10n.numDateTrainingDateSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                    '${_exerciseDate.day.toString().padLeft(2, '0')}/${_exerciseDate.month.toString().padLeft(2, '0')}/${_exerciseDate.year}'),
                subtitle: Text(l10n.numDateExpectedDay(frenchWeekday(_exerciseDate.weekday))),
                trailing: const Icon(Icons.event_available),
                onTap: _pickExerciseDate,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () => _setExerciseDate(DateTime.now()),
                    child: Text(l10n.numDateToday),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dateAnswerController,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.numDateAnswerInWords,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _checkDateAnswer(),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: _checkDateAnswer,
                    icon: const Icon(Icons.check),
                    label: Text(l10n.numDateCheck),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      _dateState = _AnswerState.idle;
                      _dateAttempt = null;
                      _dateAnswerController.clear();
                    }),
                    icon: const Icon(Icons.clear),
                    label: Text(l10n.numDateClear),
                  ),
                ],
              ),
              _buildStatusCard(
                context: context,
                state: _dateState,
                attempt: _dateAttempt,
                expected: italianDateWords(_exerciseDate),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard(
          context: context,
          title: l10n.numDatePreviewTimeTitle,
          subtitle: l10n.numDatePreviewTimeSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(italianTimeWords(_previewTime)),
                subtitle: Text(_timeLabel(_previewTime)),
                trailing: const Icon(Icons.schedule),
                onTap: _pickPreviewTime,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                      label: const Text(':00'),
                      onPressed: () => _setPreviewTime(TimeOfDay(hour: _previewTime.hour, minute: 0))),
                  ActionChip(
                      label: const Text(':15'),
                      onPressed: () => _setPreviewTime(TimeOfDay(hour: _previewTime.hour, minute: 15))),
                  ActionChip(
                      label: const Text(':30'),
                      onPressed: () => _setPreviewTime(TimeOfDay(hour: _previewTime.hour, minute: 30))),
                  ActionChip(
                      label: const Text(':45'),
                      onPressed: () => _setPreviewTime(TimeOfDay(hour: _previewTime.hour, minute: 45))),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          context: context,
          title: l10n.numDateTraining,
          subtitle: l10n.numDateTrainingTimeSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.numDateDefinedTime),
                subtitle: Text(_timeLabel(_exerciseTime)),
                trailing: const Icon(Icons.edit),
                onTap: _pickExerciseTime,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                      label: const Text(':00'),
                      onPressed: () => _setPreviewTime(TimeOfDay(hour: _previewTime.hour, minute: 0))),
                  ActionChip(
                      label: const Text(':15'),
                      onPressed: () => _setPreviewTime(TimeOfDay(hour: _previewTime.hour, minute: 15))),
                  ActionChip(
                      label: const Text(':30'),
                      onPressed: () => _setPreviewTime(TimeOfDay(hour: _previewTime.hour, minute: 30))),
                  ActionChip(
                      label: const Text(':45'),
                      onPressed: () => _setPreviewTime(TimeOfDay(hour: _previewTime.hour, minute: 45))),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _timeAnswerController,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.numDateAnswerInWords,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _checkTimeAnswer(),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: _checkTimeAnswer,
                    icon: const Icon(Icons.check),
                    label: Text(l10n.numDateCheck),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      _timeState = _AnswerState.idle;
                      _timeAttempt = null;
                      _timeAnswerController.clear();
                    }),
                    icon: const Icon(Icons.clear),
                    label: Text(l10n.numDateClear),
                  ),
                ],
              ),
              _buildStatusCard(
                context: context,
                state: _timeState,
                attempt: _timeAttempt,
                expected: italianTimeWords(_exerciseTime),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.numDateTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.numDateNumbersTab, icon: const Icon(Icons.tag)),
              Tab(text: l10n.numDateDatesTab, icon: const Icon(Icons.event)),
              Tab(text: l10n.numDateTimeTab, icon: const Icon(Icons.schedule)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNumberTab(context),
            _buildDateTab(context),
            _buildTimeTab(context),
          ],
        ),
      ),
    );
  }
}
