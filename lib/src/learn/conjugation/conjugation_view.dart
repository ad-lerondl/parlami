import 'package:flutter/material.dart';
import 'package:parlami/src/data/models/verb_conjugation.dart';
import 'package:parlami/src/repositories/conjugation_repository.dart';
import 'package:parlami/src/services/quiz_prefs.dart';
import 'package:parlami/src/localization/app_localizations.dart';

class ConjugationView extends StatefulWidget {
  const ConjugationView({super.key});

  @override
  State<ConjugationView> createState() => _ConjugationViewState();
}

class _ConjugationViewState extends State<ConjugationView> {
  final repo = ConjugationRepository();
  String? selectedInfinitive;
  String? selectedMood;
  String? selectedTense;
  final Set<String> selectedPersons = {};
  final Map<String, String> userInputs = {};
  final Map<String, bool?> checkResults = {};
  final Map<String, bool> isPartialMatch = {}; // true if user gave one of multiple accepted forms
  TextEditingController? _verbSearchController;
  bool showBaseVerb = true; // Afficher base verbale dans le champ de vérification
  bool maskBaseVerbInSearch = false; // Masquer base verbale dans l'autocomplete
  bool showAnswers = false; // Afficher réponses attendues
  bool showDetails = true;
  bool hasVerified = false; // Track if verification has been done
  bool? filterRegular;
  bool? filterPronominal;
  final Set<int> filterGroups = {};
  String? filterAuxiliary;
  Set<String> preferredPersons = {}; // Memorize user's person selection

  @override
  void initState() {
    super.initState();
    repo.init().then((_) async {
      final prefs = await QuizPrefs.loadState();
      setState(() {
        showBaseVerb = prefs.showBaseVerb;
        showAnswers = prefs.showAnswers;
        showDetails = prefs.showDetails;
        filterRegular = switch (prefs.filterRegularity) {
          'regular' => true,
          'irregular' => false,
          _ => null,
        };
        filterPronominal = switch (prefs.filterPronominal) {
          'pronominal' => true,
          'non-pronominal' => false,
          _ => null,
        };
        filterGroups
          ..clear()
          ..addAll(prefs.filterGroups.map(int.tryParse).whereType<int>());
        filterAuxiliary = prefs.filterAuxiliary;
        preferredPersons = prefs.persons.toSet();
      });
      if (prefs.infinitive != null) {
        _selectVerb(prefs.infinitive!, preserveMoodTense: true);
      }
    }).catchError((error) {
      // Show error in UI if repository fails to load
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.conjugationLoadingError(error.toString()))),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showFrenchTranslation = Localizations.localeOf(context).languageCode == 'fr';
    final isRepoReady = repo.all().isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.conjugationTitle)),
      body: !isRepoReady
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Barre de contrôle: filtres, sélection verbe, nouveau verbe
                // Filtres
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: Text(l10n.conjugationRegular),
                            selected: filterRegular == true,
                            onSelected: (v) {
                              setState(() => filterRegular = v ? true : null);
                              if (v) {
                                QuizPrefs.saveState(filterRegular: true);
                              } else {
                                QuizPrefs.clearRegularityFilter();
                              }
                            },
                          ),
                          FilterChip(
                            label: Text(l10n.conjugationIrregular),
                            selected: filterRegular == false,
                            onSelected: (v) {
                              setState(() => filterRegular = v ? false : null);
                              if (v) {
                                QuizPrefs.saveState(filterRegular: false);
                              } else {
                                QuizPrefs.clearRegularityFilter();
                              }
                            },
                          ),
                          FilterChip(
                            label: Text(l10n.conjugationPronominal),
                            selected: filterPronominal == true,
                            onSelected: (v) {
                              setState(() => filterPronominal = v ? true : null);
                              if (v) {
                                QuizPrefs.saveState(filterPronominal: true);
                              } else {
                                QuizPrefs.clearPronominalFilter();
                              }
                            },
                          ),
                          ...[1, 2, 3].map((g) => FilterChip(
                                label: Text(l10n.conjugationGroup(g)),
                                selected: filterGroups.contains(g),
                                onSelected: (v) {
                                  setState(() {
                                    if (v) {
                                      filterGroups.add(g);
                                    } else {
                                      filterGroups.remove(g);
                                    }
                                  });
                                  QuizPrefs.saveState(filterGroups: filterGroups.map((g) => '$g'));
                                },
                              )),
                          ...['avere', 'essere'].map((a) => FilterChip(
                                label: Text(l10n.conjugationAuxiliary(a)),
                                selected: filterAuxiliary == a,
                                onSelected: (v) {
                                  setState(() => filterAuxiliary = v ? a : null);
                                  if (v) {
                                    QuizPrefs.saveState(filterAuxiliary: a);
                                  } else {
                                    QuizPrefs.clearAuxiliaryFilter();
                                  }
                                },
                              )),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_all),
                      tooltip: l10n.conjugationClearFilters,
                      onPressed: () {
                        setState(() {
                          filterRegular = null;
                          filterPronominal = null;
                          filterGroups.clear();
                          filterAuxiliary = null;
                        });
                        QuizPrefs.clearConjugationFilters();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Sélection verbe + Nouveau verbe
                Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        key: ValueKey(
                            'autocomplete_${filterRegular}_${filterPronominal}_${filterAuxiliary}_${filterGroups.join('_')}'),
                        optionsBuilder: (text) {
                          final filtered = repo.search(
                            text.text,
                            regular: filterRegular,
                            pronominal: filterPronominal,
                            auxiliary: filterAuxiliary,
                            groups: filterGroups.isEmpty ? null : filterGroups,
                          );
                          return filtered.map((v) => v.infinitive);
                        },
                        displayStringForOption: (infinitive) {
                          if (maskBaseVerbInSearch) {
                            final v = repo.byInfinitive(infinitive);
                            return showFrenchTranslation ? v?.translationFor('fr') ?? infinitive : infinitive;
                          }
                          final v = repo.byInfinitive(infinitive);
                          final translation = v?.translationFor('fr');
                          return !showFrenchTranslation || translation == null
                              ? infinitive
                              : '$infinitive ($translation)';
                        },
                        onSelected: (value) {
                          _verbSearchController?.clear();
                          _selectVerb(value);
                          QuizPrefs.saveState(infinitive: value);
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          _verbSearchController = controller;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: l10n.conjugationChooseVerb,
                              isDense: true,
                              border: const OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          final random = repo.random(
                            regular: filterRegular,
                            pronominal: filterPronominal,
                            auxiliary: filterAuxiliary,
                            groups: filterGroups.isEmpty ? null : filterGroups,
                          );
                          if (random != null) {
                            _verbSearchController?.clear();
                            _selectVerb(random.infinitive, preserveMoodTense: true);
                            QuizPrefs.saveState(infinitive: random.infinitive);
                          }
                        },
                        child: Text(l10n.conjugationRandomVerb, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Masquer base verbale (dans recherche ET vérification)
                Row(
                  children: [
                    Expanded(child: Text(l10n.conjugationHideBaseVerb)),
                    Switch(
                      value: !showBaseVerb,
                      onChanged: (v) {
                        setState(() {
                          showBaseVerb = !v;
                          maskBaseVerbInSearch = v;
                        });
                        QuizPrefs.saveState(showBaseVerb: showBaseVerb);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text(l10n.conjugationDetailsVisibility)),
                    Switch(
                      value: showDetails,
                      onChanged: (value) {
                        setState(() => showDetails = value);
                        QuizPrefs.saveState(showDetails: value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedMood,
                        hint: Text(l10n.conjugationChooseMood),
                        isExpanded: true,
                        items: (selectedInfinitive != null
                                ? repo.moods(selectedInfinitive!)
                                : const Iterable<String>.empty())
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (v) => setState(() {
                          selectedMood = v;
                          selectedTense = null;
                          _resetPersons();
                          QuizPrefs.saveState(mood: selectedMood);
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedTense,
                        hint: Text(l10n.conjugationChooseTense),
                        isExpanded: true,
                        items: (selectedInfinitive != null && selectedMood != null
                                ? repo.tenses(selectedInfinitive!, selectedMood!)
                                : const Iterable<String>.empty())
                            .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(t, overflow: TextOverflow.ellipsis)),
                                      const SizedBox(width: 6),
                                      if (_isCommonTense(t)) const Icon(Icons.star, size: 16, color: Colors.amber),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedTense = v;
                            final forms = selectedInfinitive != null && selectedMood != null && v != null
                                ? repo.forms(selectedInfinitive!, selectedMood!, v)
                                : null;
                            final availablePersons = forms?.keys.toList() ?? <String>[];
                            _resetPersons(availablePersons: availablePersons);
                            QuizPrefs.saveState(tense: selectedTense);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (selectedInfinitive != null && selectedMood != null && selectedTense != null)
                  Builder(
                      key: ValueKey('card_${selectedInfinitive}_${selectedMood}_$selectedTense'),
                      builder: (context) {
                        final v = repo.byInfinitive(selectedInfinitive!);
                        final forms = repo.forms(selectedInfinitive!, selectedMood!, selectedTense!);
                        final persons = forms?.keys.toList() ?? const <String>[];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _verbLabel(l10n, v, showBaseVerb, showFrenchTranslation),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (showDetails) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Chip(
                                          label: Text(v?.regular == true
                                              ? l10n.conjugationRegular
                                              : l10n.conjugationIrregular)),
                                      Chip(
                                          label: Text(v?.pronominal == true
                                              ? l10n.conjugationPronominal
                                              : l10n.conjugationNonPronominal)),
                                      if (v != null) Chip(label: Text(l10n.conjugationGroup(v.group))),
                                      if (v?.auxiliary != null)
                                        Chip(label: Text(l10n.conjugationAuxiliary(v!.auxiliary!))),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    Text(l10n.conjugationMood(selectedMood!)),
                                    Text(l10n.conjugationTense(selectedTense!)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: persons
                                      .map((p) => FilterChip(
                                            label: Text(p),
                                            selected: selectedPersons.contains(p),
                                            onSelected: (sel) {
                                              setState(() {
                                                if (sel) {
                                                  selectedPersons.add(p);
                                                } else {
                                                  selectedPersons.remove(p);
                                                  userInputs.remove(p);
                                                  checkResults.remove(p);
                                                }
                                                // Update preferred persons
                                                preferredPersons = selectedPersons.toSet();
                                              });
                                              QuizPrefs.saveState(persons: selectedPersons);
                                            },
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: selectedPersons.map((p) {
                                    final value = userInputs[p] ?? '';
                                    final result = checkResults[p];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: Text(p, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              key: ValueKey('input_$p'),
                                              initialValue: value,
                                              decoration: InputDecoration(
                                                labelText: l10n.conjugationAnswerLabel,
                                                border: const OutlineInputBorder(),
                                              ),
                                              onChanged: (v) {
                                                userInputs[p] = v;
                                                checkResults[p] = null; // reset indicator until next check
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          if (result != null)
                                            Icon(
                                              result ? Icons.check_circle : Icons.cancel,
                                              color: result
                                                  ? (isPartialMatch[p] == true ? Colors.blue : Colors.green)
                                                  : Colors.red,
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          hasVerified = true;
                                          for (final p in selectedPersons) {
                                            final expected = forms?[p]?.trim();
                                            final input = (userInputs[p] ?? '').trim();
                                            if (expected != null) {
                                              final variants = expected
                                                  .split(RegExp(r'[,/]'))
                                                  .map((s) => s.trim().toLowerCase())
                                                  .where((s) => s.isNotEmpty)
                                                  .toSet();
                                              final entered = input
                                                  .split(RegExp(r'[,/]'))
                                                  .map((s) => s.trim().toLowerCase())
                                                  .where((s) => s.isNotEmpty)
                                                  .toSet();
                                              final isCorrect = matchesConjugationAnswer(input, expected);
                                              checkResults[p] = isCorrect;
                                              isPartialMatch[p] = isCorrect && entered.length < variants.length;
                                            } else {
                                              checkResults[p] = false;
                                              isPartialMatch[p] = false;
                                            }
                                          }
                                        });
                                      },
                                      child: Text(l10n.conjugationCheck),
                                    ),
                                    if (hasVerified)
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() => showAnswers = !showAnswers);
                                        },
                                        child: Text(
                                            showAnswers ? l10n.conjugationHideAnswers : l10n.conjugationShowAnswers),
                                      ),
                                    if (hasVerified)
                                      ElevatedButton(
                                        onPressed: () {
                                          final random = repo.random(
                                            regular: filterRegular,
                                            pronominal: filterPronominal,
                                            auxiliary: filterAuxiliary,
                                            groups: filterGroups.isEmpty ? null : filterGroups,
                                          );
                                          if (random != null) {
                                            _selectVerb(random.infinitive, preserveMoodTense: true);
                                            QuizPrefs.saveState(infinitive: random.infinitive);
                                          }
                                        },
                                        child: Text(l10n.conjugationNextVerb),
                                      ),
                                  ],
                                ),
                                if (showAnswers)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: selectedPersons.map((p) {
                                        final expected = forms?[p]?.trim();
                                        return Text(
                                          expected == null ? p : '$p: $expected',
                                          style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
              ],
            ),
    );
  }

  void _resetPersons({List<String>? availablePersons}) {
    // Clear all user inputs and verification state
    userInputs.clear();
    checkResults.clear();
    isPartialMatch.clear();
    hasVerified = false;
    showAnswers = false;
    // If we have preferred persons, try to restore them if available
    if (preferredPersons.isNotEmpty && availablePersons != null) {
      selectedPersons.clear();
      for (final p in preferredPersons) {
        if (availablePersons.contains(p)) {
          selectedPersons.add(p);
        }
      }
      // If none matched, select all
      if (selectedPersons.isEmpty && availablePersons.isNotEmpty) {
        selectedPersons.addAll(availablePersons);
      }
    } else if (availablePersons != null) {
      // Default: select all persons
      selectedPersons.clear();
      selectedPersons.addAll(availablePersons);
    } else {
      selectedPersons.clear();
    }
  }

  void _selectVerb(String infinitive, {bool preserveMoodTense = false}) {
    _verbSearchController?.clear();
    final moods = repo.moods(infinitive).toList();
    String? newMood = selectedMood;
    if (!preserveMoodTense || newMood == null || !moods.contains(newMood)) {
      newMood = moods.isNotEmpty ? moods.first : null;
    }
    final tenses = newMood != null ? repo.tenses(infinitive, newMood).toList() : <String>[];
    String? newTense = selectedTense;
    if (!preserveMoodTense || newTense == null || !tenses.contains(newTense)) {
      newTense = tenses.isNotEmpty ? tenses.first : null;
    }
    final forms = newMood != null && newTense != null ? repo.forms(infinitive, newMood, newTense) : null;
    final availablePersons = forms?.keys.toList() ?? <String>[];
    setState(() {
      selectedInfinitive = infinitive;
      selectedMood = newMood;
      selectedTense = newTense;
      _resetPersons(availablePersons: availablePersons);
    });
  }

  bool _isCommonTense(String tense) {
    const common = {
      'presente',
      'imperfetto',
      'passato prossimo',
      'futuro semplice',
    };
    return common.contains(tense.toLowerCase());
  }

  String _verbLabel(AppLocalizations l10n, VerbConjugation? verb, bool showBaseVerb, bool showFrenchTranslation) {
    final infinitive = verb?.infinitive ?? selectedInfinitive ?? '';
    final translation = verb?.translationFor('fr');
    if (showBaseVerb || !showFrenchTranslation || translation == null) {
      return l10n
          .conjugationVerb(showFrenchTranslation && translation != null ? '$infinitive ($translation)' : infinitive);
    }
    return l10n.conjugationTranslation(translation);
  }
}
