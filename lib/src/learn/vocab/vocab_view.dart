import 'package:flutter/material.dart';

import 'package:parlami/src/data/models/vocab_word.dart';
import 'package:parlami/src/repositories/vocab_repository.dart';
import 'package:parlami/src/services/vocab_export_service.dart';
import 'package:parlami/src/localization/app_localizations.dart';

enum _VocabMenuAction { exportUserWords, resetOriginalWords }

class VocabView extends StatefulWidget {
  const VocabView({super.key});

  @override
  State<VocabView> createState() => _VocabViewState();
}

class _VocabViewState extends State<VocabView> {
  final VocabRepository _repo = VocabRepository();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addItalianController = TextEditingController();
  final TextEditingController _addFrenchController = TextEditingController();
  final TextEditingController _addArticleController = TextEditingController();
  final TextEditingController _trainSearchController = TextEditingController();

  final Set<VocabDifficulty> _libraryDifficulties = {};
  final Set<String> _libraryCategories = {};
  final Set<VocabPartOfSpeech> _libraryParts = {};
  final Set<VocabDifficulty> _trainingDifficulties = {};
  final Set<String> _trainingCategories = {};
  final Set<VocabPartOfSpeech> _trainingParts = {};
  final Set<String> _draftCategories = {};

  bool _repoReady = false;
  bool _regexSearch = false;
  bool _masteryOrder = true;
  bool _showAnswer = false;
  VocabLanguage _baseLanguage = VocabLanguage.italian;
  VocabLanguage _trainingBaseLanguage = VocabLanguage.italian;
  VocabPartOfSpeech _selectedPartOfSpeech = VocabPartOfSpeech.noun;
  VocabDifficulty _selectedDifficulty = VocabDifficulty.a1;
  VocabWord? _activeWord;
  String? _statusMessage;
  List<VocabWord> _trainingPool = const [];

  String _languageLabel(VocabLanguage language, AppLocalizations l10n) =>
      language == VocabLanguage.italian ? l10n.vocabItalian : l10n.vocabFrench;

  String _partLabel(VocabPartOfSpeech part, AppLocalizations l10n) => switch (part) {
        VocabPartOfSpeech.noun => l10n.vocabNoun,
        VocabPartOfSpeech.verb => l10n.vocabVerb,
        VocabPartOfSpeech.adjective => l10n.vocabAdjective,
        VocabPartOfSpeech.adverb => l10n.vocabAdverb,
        VocabPartOfSpeech.pronoun => l10n.vocabPronoun,
        VocabPartOfSpeech.determiner => l10n.vocabDeterminer,
        VocabPartOfSpeech.preposition => l10n.vocabPreposition,
        VocabPartOfSpeech.conjunction => l10n.vocabConjunction,
        VocabPartOfSpeech.interjection => l10n.vocabInterjection,
        VocabPartOfSpeech.expression => l10n.vocabExpression,
        VocabPartOfSpeech.other => l10n.vocabOther,
      };

  @override
  void initState() {
    super.initState();
    _repo.init().then((_) {
      if (!mounted) return;
      _refreshTrainingPool();
      setState(() => _repoReady = true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addItalianController.dispose();
    _addFrenchController.dispose();
    _addArticleController.dispose();
    _trainSearchController.dispose();
    super.dispose();
  }

  Future<Set<String>?> _openCategoryPicker({
    required String title,
    required Set<String> initialCategories,
  }) async {
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _CategoryPickerSheet(
        title: title,
        availableCategories: _repo.allCategories(),
        initialSelected: initialCategories,
      ),
    );
  }

  void _refreshTrainingPool() {
    final filter = VocabFilter(
      difficulties: _trainingDifficulties,
      categories: _trainingCategories,
      partsOfSpeech: _trainingParts,
      query: _trainSearchController.text,
      regex: _regexSearch,
      baseLanguage: _trainingBaseLanguage,
      masteryOrder: _masteryOrder,
    );
    final pool = _repo.filter(filter);
    _trainingPool = pool;
    _activeWord = pool.isNotEmpty ? pool.first : null;
    _showAnswer = false;
  }

  VocabFilter _libraryFilter() {
    return VocabFilter(
      difficulties: _libraryDifficulties,
      categories: _libraryCategories,
      partsOfSpeech: _libraryParts,
      query: _searchController.text,
      regex: _regexSearch,
      masteryOrder: true,
    );
  }

  VocabFilter _trainingFilter() {
    return VocabFilter(
      difficulties: _trainingDifficulties,
      categories: _trainingCategories,
      partsOfSpeech: _trainingParts,
      query: _trainSearchController.text,
      regex: _regexSearch,
      baseLanguage: _trainingBaseLanguage,
      masteryOrder: _masteryOrder,
    );
  }

  Future<void> _saveWord() async {
    final l10n = AppLocalizations.of(context)!;
    final categories = _draftCategories.toList(growable: false);
    if (_addItalianController.text.trim().isEmpty || _addFrenchController.text.trim().isEmpty) {
      setState(() => _statusMessage = l10n.vocabFrenchTranslation);
      return;
    }

    final now = DateTime.now();
    final draft = VocabWord(
      id: normalizeVocabText('${_addItalianController.text}-${_addFrenchController.text}')
          .replaceAll(RegExp(r'[^a-z0-9]+'), '_'),
      italian: _addItalianController.text.trim(),
      french: _addFrenchController.text.trim(),
      difficulty: _selectedDifficulty,
      categories: categories,
      partOfSpeech: _selectedPartOfSpeech,
      article: _addArticleController.text.trim().isEmpty ? null : _addArticleController.text.trim(),
      source: VocabWordSource.user,
      createdAt: now,
      updatedAt: now,
      stats: VocabReviewStats.initial(),
    );
    await _repo.upsert(draft);
    _addItalianController.clear();
    _addFrenchController.clear();
    _addArticleController.clear();
    _draftCategories.clear();
    _refreshTrainingPool();
    setState(() => _statusMessage = l10n.vocabStatusSaved);
  }

  Future<void> _importWords() async {
    final l10n = AppLocalizations.of(context)!;
    const example = '''[
  {
    "it": "andare",
    "fr": "aller",
    "difficulty": "A1",
    "categories": ["déplacements", "verbes"],
    "partOfSpeech": "verb"
  }
]''';
    final controller = TextEditingController(text: example);
    final imported = await showDialog<List<VocabWord>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.vocabImport),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.vocabPasteJson),
                const SizedBox(height: 8),
                const SelectableText(example),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  minLines: 8,
                  maxLines: 14,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: l10n.vocabImport),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(null),
            child: Text(l10n.vocabCancel),
          ),
          FilledButton(
            onPressed: () async {
              try {
                final result = await _repo.importWordsFromJsonString(controller.text);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(result);
                }
              } catch (error) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.vocabImportError(error.toString()))),
                  );
                }
              }
            },
            child: Text(l10n.vocabImport),
          ),
        ],
      ),
    );
    controller.dispose();
    if (imported == null) return;
    if (!mounted) return;
    setState(() {
      _refreshTrainingPool();
      _statusMessage = l10n.vocabStatusImport(imported.length.toString());
    });
  }

  Future<void> _exportUserWords() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_repoReady) return;
    final userWords = _repo.userWords();
    if (userWords.isEmpty) {
      setState(() => _statusMessage = l10n.vocabStatusNoExport);
      return;
    }

    final json = await _repo.exportUserWordsJson();
    final fileName = 'vocabulaire_utilisateur_${DateTime.now().toIso8601String().replaceAll(':', '-')}.json';
    final exportLocation = await exportVocabJson(fileName, json);
    if (!mounted) return;
    setState(() => _statusMessage = l10n.vocabStatusExport(exportLocation));
  }

  Future<void> _resetOriginalWords() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_repoReady) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.vocabResetQuestion),
        content: Text(l10n.vocabResetDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.vocabCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.vocabResetCatalog),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _repo.resetOriginalWords();
    if (!mounted) return;
    setState(() {
      _refreshTrainingPool();
      _statusMessage = l10n.vocabStatusReset;
    });
  }

  Future<void> _deleteWord(VocabWord word) async {
    final l10n = AppLocalizations.of(context)!;
    if (!_repoReady) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.vocabDeleteQuestion),
        content: Text(l10n.vocabDeleteDescription(word.italian)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.vocabCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.vocabDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _repo.remove(word.id);
    if (!mounted) return;
    setState(() {
      _refreshTrainingPool();
      _statusMessage = l10n.vocabStatusDeleted;
    });
  }

  Future<void> _advanceTrainingPool() async {
    if (!_repoReady) return;
    if (_trainingPool.isEmpty) return;
    final current = _activeWord ?? _trainingPool.first;
    await _repo.markSeen(current.id);
    final updated = _repo.filter(_trainingFilter());
    if (updated.isEmpty) {
      setState(() {
        _trainingPool = const [];
        _activeWord = null;
        _showAnswer = false;
      });
      return;
    }
    final next = updated.firstWhere((word) => word.id != current.id, orElse: () => updated.first);
    setState(() {
      _trainingPool = updated;
      _activeWord = next;
      _showAnswer = false;
    });
  }

  Future<void> _classifyCurrent(bool known) async {
    if (!_repoReady) return;
    if (_activeWord == null) return;
    await _repo.review(_activeWord!.id, known: known);
    final updated = _repo.filter(_trainingFilter());
    final next = updated.where((word) => word.id != _activeWord!.id).toList(growable: false);
    setState(() {
      _statusMessage = known ? 'Bien noté.' : 'À revoir rapidement.';
      _trainingPool = updated;
      _activeWord = next.isNotEmpty
          ? next.first
          : updated.isNotEmpty
              ? updated.first
              : null;
      _showAnswer = false;
    });
  }

  Widget _buildStatsBar(List<VocabWord> items) {
    final l10n = AppLocalizations.of(context)!;
    final total = items.length;
    final averageMastery = total == 0 ? 0.0 : items.map((word) => word.masteryScore()).reduce((a, b) => a + b) / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: _StatTile(label: l10n.vocabWords, value: '$total')),
            Expanded(child: _StatTile(label: l10n.vocabAverageMastery, value: '${averageMastery.toStringAsFixed(0)}%')),
            Expanded(
                child: _StatTile(label: l10n.vocabMode, value: _masteryOrder ? l10n.vocabMastery : l10n.vocabRandom)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips<T>({
    required String title,
    required List<T> options,
    required Set<T> selected,
    required String Function(T value) labelOf,
    required void Function(T value, bool selected) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (value) => FilterChip(
                  label: Text(labelOf(value)),
                  selected: selected.contains(value),
                  onSelected: (checked) => onChanged(value, checked),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }

  Widget _buildSelectedCategorySummary(Set<String> selectedCategories) {
    final l10n = AppLocalizations.of(context)!;
    if (selectedCategories.isEmpty) {
      return Text(l10n.vocabNoCategory);
    }
    final sorted = selectedCategories.toList(growable: false)..sort();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sorted.map((category) => Chip(label: Text(category))).toList(growable: false),
    );
  }

  Widget _buildCatalogTab() {
    final l10n = AppLocalizations.of(context)!;
    if (!_repoReady) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.vocabLoading),
            ],
          ),
        ),
      );
    }
    final items = _repo.filter(_libraryFilter());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatsBar(items),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: l10n.vocabSearchWord,
            suffixIcon: IconButton(
              icon: Icon(_regexSearch ? Icons.code : Icons.search),
              onPressed: () => setState(() => _regexSearch = !_regexSearch),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<VocabLanguage>(
          initialValue: _baseLanguage,
          decoration: InputDecoration(labelText: l10n.vocabBaseLanguageDisplay),
          items: VocabLanguage.values
              .map((language) => DropdownMenuItem(value: language, child: Text(_languageLabel(language, l10n))))
              .toList(growable: false),
          onChanged: (language) => setState(() => _baseLanguage = language ?? VocabLanguage.italian),
        ),
        const SizedBox(height: 12),
        _buildFilterChips<VocabDifficulty>(
          title: l10n.vocabDifficulty,
          options: _repo.allDifficulties(),
          selected: _libraryDifficulties,
          labelOf: (value) => value.label,
          onChanged: (value, checked) => setState(() {
            if (checked) {
              _libraryDifficulties.add(value);
            } else {
              _libraryDifficulties.remove(value);
            }
          }),
        ),
        const SizedBox(height: 12),
        _buildFilterChips<VocabPartOfSpeech>(
          title: l10n.vocabPartOfSpeech,
          options: _repo.allPartsOfSpeech(),
          selected: _libraryParts,
          labelOf: (value) => value.label,
          onChanged: (value, checked) => setState(() {
            if (checked) {
              _libraryParts.add(value);
            } else {
              _libraryParts.remove(value);
            }
          }),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Text(l10n.vocabFields, style: Theme.of(context).textTheme.titleSmall)),
            TextButton(
              onPressed: () async {
                final result = await _openCategoryPicker(
                  title: l10n.vocabChooseFilterCategories,
                  initialCategories: _libraryCategories,
                );
                if (result == null || !mounted) return;
                setState(() {
                  _libraryCategories
                    ..clear()
                    ..addAll(result);
                });
              },
              child: Text(l10n.vocabSelect),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildSelectedCategorySummary(_libraryCategories),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(child: Text(l10n.vocabNoMatch)),
          )
        else
          ...items.map((word) => _VocabWordCard(
              word: word,
              baseLanguage: _baseLanguage,
              onTap: () => setState(() => _statusMessage =
                  '${word.labelFor(_baseLanguage)} • ${word.difficulty.label} • ${_partLabel(word.partOfSpeech, l10n)}'),
              onDelete: () => _deleteWord(word))),
      ],
    );
  }

  Widget _buildTrainingCard() {
    final l10n = AppLocalizations.of(context)!;
    final word = _activeWord;
    if (word == null) {
      return Center(child: Text(l10n.vocabNoTrainingMatch));
    }
    final prompt = _trainingBaseLanguage == VocabLanguage.italian
        ? word.labelFor(VocabLanguage.italian)
        : word.labelFor(VocabLanguage.french);
    final hidden = _trainingBaseLanguage == VocabLanguage.italian
        ? word.labelFor(VocabLanguage.french)
        : word.labelFor(VocabLanguage.italian);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.vocabTrainingWord, style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                Chip(label: Text(l10n.vocabScore(word.masteryScore().toStringAsFixed(0)))),
                const SizedBox(width: 8),
                Chip(label: Text(word.difficulty.label)),
                const SizedBox(width: 8),
                Chip(label: Text(_partLabel(word.partOfSpeech, l10n))),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.vocabBaseLanguage(_languageLabel(_trainingBaseLanguage, l10n)),
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(prompt, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 180),
              crossFadeState: _showAnswer ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: Text(l10n.vocabHiddenAnswer),
              secondChild: Text(hidden, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () => setState(() => _showAnswer = !_showAnswer),
                  child: Text(_showAnswer ? l10n.vocabHideAnswer : l10n.vocabShowAnswer),
                ),
                OutlinedButton(
                  onPressed: () => _classifyCurrent(true),
                  child: Text(l10n.vocabKnown),
                ),
                OutlinedButton(
                  onPressed: () => _classifyCurrent(false),
                  child: Text(l10n.vocabUnknown),
                ),
                FilledButton(
                  onPressed: _advanceTrainingPool,
                  child: Text(l10n.vocabNextWord),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.vocabCategories(word.categories.join(', '))),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingTab() {
    final l10n = AppLocalizations.of(context)!;
    if (!_repoReady) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.vocabPreparing),
            ],
          ),
        ),
      );
    }

    final items = _repo.filter(_trainingFilter());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatsBar(items),
        const SizedBox(height: 12),
        DropdownButtonFormField<VocabLanguage>(
          initialValue: _trainingBaseLanguage,
          decoration: InputDecoration(
            labelText: l10n.vocabTrainingBaseLanguage,
            border: const OutlineInputBorder(),
          ),
          items: VocabLanguage.values
              .map(
                (language) => DropdownMenuItem(
                  value: language,
                  child: Text(_languageLabel(language, l10n)),
                ),
              )
              .toList(growable: false),
          onChanged: (language) {
            setState(() {
              _trainingBaseLanguage = language ?? VocabLanguage.italian;
              _refreshTrainingPool();
            });
          },
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _masteryOrder,
          onChanged: (value) => setState(() {
            _masteryOrder = value;
            _refreshTrainingPool();
          }),
          title: Text(l10n.vocabPriority),
          subtitle: Text(l10n.vocabPriorityDescription),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filtres",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _trainSearchController,
                  decoration: InputDecoration(
                    labelText: l10n.vocabSearchTrainingWord,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _regexSearch ? Icons.code : Icons.search,
                      ),
                      onPressed: () => setState(() {
                        _regexSearch = !_regexSearch;
                        _refreshTrainingPool();
                      }),
                    ),
                  ),
                  onChanged: (_) => setState(_refreshTrainingPool),
                ),
                const SizedBox(height: 20),
                _buildHorizontalFilterChips<VocabDifficulty>(
                  title: l10n.vocabDifficulty,
                  options: _repo.allDifficulties(),
                  selected: _trainingDifficulties,
                  labelOf: (value) => value.label,
                  onChanged: (value, checked) => setState(() {
                    if (checked) {
                      _trainingDifficulties.add(value);
                    } else {
                      _trainingDifficulties.remove(value);
                    }
                    _refreshTrainingPool();
                  }),
                ),
                const SizedBox(height: 20),
                _buildHorizontalFilterChips<VocabPartOfSpeech>(
                  title: l10n.vocabPartOfSpeech,
                  options: _repo.allPartsOfSpeech(),
                  selected: _trainingParts,
                  labelOf: (value) => _partLabel(value, l10n),
                  onChanged: (value, checked) => setState(() {
                    if (checked) {
                      _trainingParts.add(value);
                    } else {
                      _trainingParts.remove(value);
                    }
                    _refreshTrainingPool();
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.vocabFields,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final result = await _openCategoryPicker(
                          title: l10n.vocabChooseTrainingCategories,
                          initialCategories: _trainingCategories,
                        );

                        if (result == null || !mounted) return;

                        setState(() {
                          _trainingCategories
                            ..clear()
                            ..addAll(result);
                          _refreshTrainingPool();
                        });
                      },
                      child: Text(l10n.vocabSelect),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSelectedCategorySummary(_trainingCategories),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildTrainingCard(),
        const SizedBox(height: 16),
        if (_statusMessage != null)
          Text(
            _statusMessage!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        const SizedBox(height: 8),
        Text(l10n.vocabSelectedCount(items.length.toString())),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...items.take(8).map(
                (word) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    word.labelFor(_trainingBaseLanguage),
                  ),
                  subtitle: Text(
                    '${word.labelFor(_trainingBaseLanguage == VocabLanguage.italian ? VocabLanguage.french : VocabLanguage.italian)} • ${word.masteryScore().toStringAsFixed(0)}%',
                  ),
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildHorizontalFilterChips<T>({
    required String title,
    required Iterable<T> options,
    required Set<T> selected,
    required String Function(T) labelOf,
    required void Function(T value, bool checked) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((value) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(labelOf(value)),
                  selected: selected.contains(value),
                  onSelected: (checked) => onChanged(value, checked),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAddTab() {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(controller: _addItalianController, decoration: InputDecoration(labelText: l10n.vocabItalianWord)),
        const SizedBox(height: 12),
        TextField(
            controller: _addFrenchController, decoration: InputDecoration(labelText: l10n.vocabFrenchTranslation)),
        const SizedBox(height: 12),
        TextField(controller: _addArticleController, decoration: InputDecoration(labelText: l10n.vocabOptionalArticle)),
        const SizedBox(height: 12),
        DropdownButtonFormField<VocabDifficulty>(
          initialValue: _selectedDifficulty,
          decoration: InputDecoration(labelText: l10n.vocabDifficulty),
          items: VocabDifficulty.values
              .map((difficulty) => DropdownMenuItem(value: difficulty, child: Text(difficulty.label)))
              .toList(growable: false),
          onChanged: (difficulty) => setState(() => _selectedDifficulty = difficulty ?? VocabDifficulty.a1),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<VocabPartOfSpeech>(
          initialValue: _selectedPartOfSpeech,
          decoration: InputDecoration(labelText: l10n.vocabPartOfSpeech),
          items: VocabPartOfSpeech.values
              .map((part) => DropdownMenuItem(value: part, child: Text(_partLabel(part, l10n))))
              .toList(growable: false),
          onChanged: (part) => setState(() => _selectedPartOfSpeech = part ?? VocabPartOfSpeech.other),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Text(l10n.vocabCategoriesTitle, style: Theme.of(context).textTheme.titleSmall)),
            TextButton(
              onPressed: () async {
                final result = await _openCategoryPicker(
                  title: l10n.vocabChooseCategories,
                  initialCategories: _draftCategories,
                );
                if (result == null || !mounted) return;
                setState(() {
                  _draftCategories
                    ..clear()
                    ..addAll(result);
                });
              },
              child: Text(l10n.vocabSelect),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildSelectedCategorySummary(_draftCategories),
        const SizedBox(height: 16),
        FilledButton(onPressed: _repoReady ? _saveWord : null, child: Text(l10n.vocabSave)),
        if (_statusMessage != null) ...[
          const SizedBox(height: 12),
          Text(_statusMessage!),
        ],
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
          title: Text(l10n.vocabTitle),
          actions: [
            PopupMenuButton<_VocabMenuAction>(
              enabled: _repoReady,
              onSelected: (action) async {
                switch (action) {
                  case _VocabMenuAction.exportUserWords:
                    await _exportUserWords();
                    break;
                  case _VocabMenuAction.resetOriginalWords:
                    await _resetOriginalWords();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _VocabMenuAction.exportUserWords,
                  child: Text(l10n.vocabExport),
                ),
                PopupMenuItem(
                  value: _VocabMenuAction.resetOriginalWords,
                  child: Text(l10n.vocabResetCatalog),
                ),
              ],
            ),
            IconButton(
              tooltip: l10n.vocabImport,
              onPressed: _repoReady ? _importWords : null,
              icon: const Icon(Icons.file_upload_outlined),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.vocabReview),
              Tab(text: l10n.vocabCatalog),
              Tab(text: l10n.vocabAdd),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTrainingTab(),
            _buildCatalogTab(),
            _buildAddTab(),
          ],
        ),
      ),
    );
  }
}

class _CategoryPickerSheet extends StatefulWidget {
  const _CategoryPickerSheet({
    required this.title,
    required this.availableCategories,
    required this.initialSelected,
  });

  final String title;
  final List<String> availableCategories;
  final Set<String> initialSelected;

  @override
  State<_CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<_CategoryPickerSheet> {
  late final TextEditingController _searchController;
  late final Set<String> _selected;
  late final List<String> _available;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selected =
        widget.initialSelected.map((item) => item.trim().toLowerCase()).where((item) => item.isNotEmpty).toSet();
    _available = widget.availableCategories
        .map((item) => item.trim().toLowerCase())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList(growable: false)
      ..sort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggle(String category) {
    setState(() {
      if (_selected.contains(category)) {
        _selected.remove(category);
      } else {
        _selected.add(category);
      }
    });
  }

  void _addCustomCategory() {
    final value = normalizeVocabText(_searchController.text).trim();
    if (value.isEmpty) return;
    setState(() {
      _selected.add(value);
      if (!_available.contains(value)) {
        _available.add(value);
        _available.sort();
      }
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = normalizeVocabText(_searchController.text);
    final results = _available
        .where((category) => query.isEmpty || normalizeVocabText(category).contains(query))
        .toList(growable: false);
    final canCreate = query.isNotEmpty && !results.contains(query);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.vocabSearchCategory,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() {}),
                ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _addCustomCategory(),
            ),
            const SizedBox(height: 12),
            if (canCreate)
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _addCustomCategory,
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.vocabAddCategory(_searchController.text.trim())),
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selected.map((category) => Chip(label: Text(category))).toList(growable: false),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final category = results[index];
                  return CheckboxListTile(
                    value: _selected.contains(category),
                    title: Text(category),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (_) => _toggle(category),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(<String>{}),
                  child: Text(AppLocalizations.of(context)!.vocabClearAll),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(AppLocalizations.of(context)!.vocabCancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: Text(AppLocalizations.of(context)!.vocabConfirm),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _VocabWordCard extends StatelessWidget {
  const _VocabWordCard({required this.word, required this.baseLanguage, required this.onTap, required this.onDelete});

  final VocabWord word;
  final VocabLanguage baseLanguage;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mastery = word.masteryScore();
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(word.labelFor(baseLanguage)),
        subtitle: Text(
            '${word.labelFor(baseLanguage == VocabLanguage.italian ? VocabLanguage.french : VocabLanguage.italian)} • ${word.categories.join(', ')} • ${word.source == VocabWordSource.original ? l10n.vocabSourceOriginal : l10n.vocabSourceUser}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(word.difficulty.label),
                Text('${mastery.toStringAsFixed(0)}%'),
              ],
            ),
            IconButton(
              tooltip: AppLocalizations.of(context)!.vocabDeleteFromCatalog,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
