import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/data/models/ee_sentence.dart';
import 'package:parlami/src/data/models/eo_question.dart';
import 'package:parlami/src/data/models/grammar_question.dart';
import 'package:parlami/src/data/models/vocab_word.dart';
import 'package:parlami/src/evaluate/evaluate_engine.dart';

List<GrammarQuestion> _grammar() => const [
      GrammarQuestion(
        id: 'g1',
        topic: 'articles',
        level: 'A1',
        prompt: 'prompt',
        sentence: '___ ragazzo',
        options: ['Il', 'Lo', 'La', 'Le'],
        answerIndex: 0,
        explanation: 'exp',
      ),
      GrammarQuestion(
        id: 'g2',
        topic: 'articles',
        level: 'A1',
        prompt: 'prompt',
        sentence: '___ ragazza',
        options: ['Il', 'La', 'Lo', 'Le'],
        answerIndex: 1,
        explanation: 'exp',
      ),
    ];

VocabWord _vocab(String id) => VocabWord(
      id: id,
      italian: 'casa',
      french: 'maison',
      difficulty: VocabDifficulty.a1,
      categories: const [],
      partOfSpeech: VocabPartOfSpeech.noun,
      article: 'la',
      source: VocabWordSource.original,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      stats: VocabReviewStats.initial(),
    );

void main() {
  test('buildSession produces a mixed session for each scenario', () {
    final banks = EvaluateBanks(
      grammarQuestions: _grammar(),
      vocabWords: List.generate(6, (i) => _vocab("v$i")),
      eeSentences: const [
        EESentence(french: 'bonjour', italian: 'salve', level: 'A1'),
      ],
      eoQuestions: const [
        EOQuestion(id: 'eo1', prompt: 'presentati', level: 'A1'),
      ],
    );

    for (final scenario in EvaluateScenario.values) {
      final session = EvaluateEngine.buildSession(
        scenario: scenario,
        banks: banks,
        random: Random(42),
      );
      expect(session, isNotEmpty, reason: 'scenario $scenario');
      final kinds = session.map((question) => question.kind).toSet();
      expect(kinds.length, greaterThan(1), reason: 'scenario $scenario');
    }
  });

  test('buildSession skips missing banks instead of crashing', () {
    final session = EvaluateEngine.buildSession(
      scenario: EvaluateScenario.articleSummary,
      banks: const EvaluateBanks(
        eeSentences: [EESentence(french: 'va', italian: 'vada', level: 'A1')],
      ),
      random: Random(7),
    );
    expect(session, isNotEmpty);
    expect(
      session.every((question) => question.kind == EvaluateQuestionKind.sentence),
      isTrue,
    );
  });

  test('typed answers are compared loosely but honestly', () {
    const question = EvaluateQuestion(
      id: 'v1',
      kind: EvaluateQuestionKind.translation,
      skill: 'vocab',
      prompt: 'maison',
      expectedAnswers: ['casa', 'la casa'],
    );
    expect(question.isTypedAnswerCorrect(' CASA '), isTrue);
    expect(question.isTypedAnswerCorrect('la  casa'), isTrue);
    expect(question.isTypedAnswerCorrect('case'), isFalse);
    expect(question.isTypedAnswerCorrect(''), isFalse);
  });

  test('session result aggregates accuracy and oral self-rating', () {
    const question = EvaluateQuestion(
      id: 'g1',
      kind: EvaluateQuestionKind.multipleChoice,
      skill: 'grammar',
      prompt: 'p',
    );
    const records = [
      EvaluateAnswerRecord(
        question: question,
        correct: true,
        answer: 'a',
        durationMs: 10,
      ),
      EvaluateAnswerRecord(
        question: question,
        correct: false,
        answer: 'b',
        durationMs: 10,
      ),
      EvaluateAnswerRecord(
        question: question,
        correct: null,
        rating: 2,
        answer: '',
        durationMs: 10,
      ),
    ];
    final result = EvaluateSessionResult(
      evaluated: records.where((r) => r.correct != null).length,
      correct: records.where((r) => r.correct == true).length,
      ratings: records.map((r) => r.rating).whereType<int>().toList(),
    );
    expect(result.evaluated, 2);
    expect(result.accuracy, 0.5);
    expect(result.meanRating, 2);
  });
}
