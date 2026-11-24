import 'dart:math';

import 'package:parlami/src/data/models/ee_sentence.dart';
import 'package:parlami/src/data/models/eo_question.dart';
import 'package:parlami/src/data/models/grammar_question.dart';
import 'package:parlami/src/data/models/vocab_word.dart';

enum EvaluateQuestionKind { multipleChoice, translation, sentence, oral }

enum EvaluateScenario { dailyConversation, articleSummary, matchDebrief, quickDiscussion }

class EvaluateQuestion {
  const EvaluateQuestion({
    required this.id,
    required this.kind,
    required this.skill,
    required this.prompt,
    this.sentence,
    this.options = const [],
    this.answerIndex,
    this.expectedAnswers = const [],
    this.level,
    this.tip,
  });

  final String id;
  final EvaluateQuestionKind kind;

  /// Skill bucket used when recording the attempt (`grammar`, `vocab`,
  /// `ee`, `eo`).
  final String skill;

  /// Main instruction shown to the learner (already localized or coming from
  /// pedagogical assets).
  final String prompt;

  /// Optional Italian sentence to complete, for multiple-choice questions.
  final String? sentence;

  final List<String> options;
  final int? answerIndex;

  /// Accepted answers for typed questions. Comparison is done on a trimmed,
  /// lower-cased value.
  final List<String> expectedAnswers;

  final String? level;
  final String? tip;

  bool isMultipleChoiceCorrect(int? selectedIndex) =>
      selectedIndex != null && selectedIndex == answerIndex;

  bool isTypedAnswerCorrect(String answer) {
    final normalized = _normalizeTyped(answer);
    if (normalized.isEmpty) return false;
    return expectedAnswers.any((expected) => _normalizeTyped(expected) == normalized);
  }

  static String _normalizeTyped(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}

class EvaluateSessionResult {
  const EvaluateSessionResult({
    required this.evaluated,
    required this.correct,
    required this.ratings,
  });

  final int evaluated;
  final int correct;
  final List<int> ratings;

  double? get accuracy => evaluated == 0 ? null : correct / evaluated;

  /// Mean oral self-rating normalised to [0, 3]; null when no oral step was
  /// completed.
  double? get meanRating =>
      ratings.isEmpty ? null : ratings.reduce((a, b) => a + b) / ratings.length;
}

class EvaluateAnswerRecord {
  const EvaluateAnswerRecord({
    required this.question,
    this.correct,
    this.rating,
    required this.answer,
    required this.durationMs,
  });

  final EvaluateQuestion question;
  final bool? correct;
  final int? rating;
  final String answer;
  final int durationMs;

  EvaluateSessionResult get result => EvaluateSessionResult(
        evaluated: correct == null ? 0 : 1,
        correct: correct == true ? 1 : 0,
        ratings: rating == null ? const [] : [rating!],
      );
}

class EvaluateBanks {
  const EvaluateBanks({
    this.grammarQuestions = const [],
    this.vocabWords = const [],
    this.eeSentences = const [],
    this.eoQuestions = const [],
  });

  final List<GrammarQuestion> grammarQuestions;
  final List<VocabWord> vocabWords;
  final List<EESentence> eeSentences;
  final List<EOQuestion> eoQuestions;
}

/// Builds mixed-skill test sessions for the "Se tester" tab.
///
/// Pure and deterministic given the same [Random] seed, so it can be unit
/// tested without Flutter bindings.
class EvaluateEngine {
  const EvaluateEngine._();

  static const Map<EvaluateScenario, Map<EvaluateQuestionKind, int>> _mixes = {
    EvaluateScenario.dailyConversation: {
      EvaluateQuestionKind.oral: 2,
      EvaluateQuestionKind.multipleChoice: 2,
      EvaluateQuestionKind.translation: 1,
    },
    EvaluateScenario.articleSummary: {
      EvaluateQuestionKind.sentence: 3,
      EvaluateQuestionKind.multipleChoice: 2,
    },
    EvaluateScenario.matchDebrief: {
      EvaluateQuestionKind.multipleChoice: 2,
      EvaluateQuestionKind.oral: 2,
      EvaluateQuestionKind.translation: 1,
    },
    EvaluateScenario.quickDiscussion: {
      EvaluateQuestionKind.translation: 3,
      EvaluateQuestionKind.multipleChoice: 2,
      EvaluateQuestionKind.oral: 1,
    },
  };

  /// Builds a shuffled, mixed session. If a bank is too small, the missing
  /// question kinds are silently skipped instead of crashing the session.
  static List<EvaluateQuestion> buildSession({
    required EvaluateScenario scenario,
    required EvaluateBanks banks,
    Random? random,
  }) {
    final rng = random ?? Random();
    final mix = _mixes[scenario] ?? const {};

    final pools = {
      EvaluateQuestionKind.multipleChoice:
          List.of(_multipleChoiceQuestions(banks.grammarQuestions))..shuffle(rng),
      EvaluateQuestionKind.translation:
          List.of(_translationQuestions(banks.vocabWords))..shuffle(rng),
      EvaluateQuestionKind.sentence:
          List.of(_sentenceQuestions(banks.eeSentences))..shuffle(rng),
      EvaluateQuestionKind.oral:
          List.of(_oralQuestions(banks.eoQuestions))..shuffle(rng),
    };

    final questions = <EvaluateQuestion>[];
    for (final kind in EvaluateQuestionKind.values) {
      final wanted = mix[kind] ?? 0;
      questions.addAll(pools[kind]!.take(wanted));
    }
    questions.shuffle(rng);
    return questions;
  }

  static Iterable<EvaluateQuestion> _multipleChoiceQuestions(
    List<GrammarQuestion> questions,
  ) sync* {
    for (final question in questions) {
      yield EvaluateQuestion(
        id: question.id,
        kind: EvaluateQuestionKind.multipleChoice,
        skill: 'grammar',
        prompt: question.prompt,
        sentence: question.sentence,
        options: question.options,
        answerIndex: question.answerIndex,
        level: question.level,
      );
    }
  }

  static Iterable<EvaluateQuestion> _translationQuestions(
    List<VocabWord> words,
  ) sync* {
    for (final word in words) {
      final expected = <String>{
        word.italian,
        word.labelFor(VocabLanguage.italian),
      }.where((answer) => answer.trim().isNotEmpty).toList(growable: false);
      if (expected.isEmpty) continue;
      yield EvaluateQuestion(
        id: word.id,
        kind: EvaluateQuestionKind.translation,
        skill: 'vocab',
        prompt: word.french,
        expectedAnswers: expected,
        level: word.difficulty.label,
      );
    }
  }

  static Iterable<EvaluateQuestion> _sentenceQuestions(
    List<EESentence> sentences,
  ) sync* {
    for (final sentence in sentences) {
      yield EvaluateQuestion(
        id: sentence.french,
        kind: EvaluateQuestionKind.sentence,
        skill: 'ee',
        prompt: sentence.french,
        expectedAnswers: [sentence.italian],
        level: sentence.level,
      );
    }
  }

  static Iterable<EvaluateQuestion> _oralQuestions(
    List<EOQuestion> questions,
  ) sync* {
    for (final question in questions) {
      yield EvaluateQuestion(
        id: question.id,
        kind: EvaluateQuestionKind.oral,
        skill: 'eo',
        prompt: question.prompt,
        expectedAnswers: const [],
        level: question.level,
        tip: question.expectedAnswer,
      );
    }
  }
}
