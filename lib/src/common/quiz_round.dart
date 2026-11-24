import 'package:flutter/material.dart';

/// A single multiple-choice round shared by the culture quizzes
/// (geography, pasta, history).
class QuizRound extends StatefulWidget {
  const QuizRound({
    super.key,
    required this.question,
    required this.explanation,
    required this.options,
    required this.correctIndex,
    required this.goodLabel,
    required this.wrongLabel,
    required this.nextLabel,
    required this.onAnswered,
    required this.onNext,
  });

  final String question;
  final String explanation;
  final List<String> options;
  final int correctIndex;
  final String goodLabel;
  final String wrongLabel;
  final String nextLabel;
  final ValueChanged<bool> onAnswered;
  final VoidCallback onNext;

  @override
  State<QuizRound> createState() => _QuizRoundState();
}

class _QuizRoundState extends State<QuizRound> {
  int? _picked;

  @override
  void didUpdateWidget(covariant QuizRound oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question ||
        oldWidget.correctIndex != widget.correctIndex) {
      _picked = null;
    }
  }

  void _pick(int index) {
    if (_picked != null) return;
    setState(() => _picked = index);
    widget.onAnswered(index == widget.correctIndex);
  }

  @override
  Widget build(BuildContext context) {
    final answered = _picked != null;
    final isCorrect = _picked == widget.correctIndex;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...List.generate(widget.options.length, (index) {
              Color tileColor = colorScheme.surface;
              IconData? trailing;
              if (answered) {
                if (index == widget.correctIndex) {
                  tileColor = Colors.green.shade100;
                  trailing = Icons.check_circle;
                } else if (index == _picked) {
                  tileColor = Colors.red.shade100;
                  trailing = Icons.cancel;
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: answered ? null : () => _pick(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(widget.options[index])),
                          if (trailing != null) Icon(trailing),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (answered) ...[
              const SizedBox(height: 8),
              Text(
                isCorrect ? widget.goodLabel : widget.wrongLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
              if (widget.explanation.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(widget.explanation),
              ],
              const SizedBox(height: 12),
              FilledButton(
                onPressed: widget.onNext,
                child: Text(widget.nextLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
