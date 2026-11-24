import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/repositories/grammar_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('grammar asset loads and every question is coherent', () async {
    final repository = GrammarRepository();
    await repository.init();
    final questions = repository.all();

    expect(questions, isNotEmpty);

    for (final question in questions) {
      expect(question.options.length, greaterThanOrEqualTo(2), reason: question.id);
      expect(
        question.answerIndex,
        inInclusiveRange(0, question.options.length - 1),
        reason: question.id,
      );
      expect(question.options[question.answerIndex].trim(), isNotEmpty,
          reason: question.id);
      expect(question.sentence, isNotEmpty, reason: question.id);
      expect(question.prompt, isNotEmpty, reason: question.id);
      expect(question.explanation, isNotEmpty, reason: question.id);
      expect(
        question.options.map((option) => option.trim().toLowerCase()).toSet().length,
        question.options.length,
        reason: 'duplicate options in ${question.id}',
      );
      expect(
        RegExp(r'[^\x00-\u024F\u0590-\u05FF\u0600-\u06FF\u2192]').allMatches(question.sentence),
        isEmpty,
        reason: 'unexpected script in ${question.id}',
      );
    }

    expect(repository.topics(), isNotEmpty);
    final sample = repository.randomQuestions(count: 5);
    expect(sample.length, 5);
  });
}
