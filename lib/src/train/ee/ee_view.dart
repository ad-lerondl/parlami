import 'package:flutter/material.dart';
import 'package:parlami/src/repositories/ee_repository.dart';

class EEView extends StatefulWidget {
  const EEView({super.key});

  @override
  State<EEView> createState() => _EEViewState();
}

class _EEViewState extends State<EEView> {
  final repo = EERepository();
  final answerController = TextEditingController();
  String? currentFrench;
  String? correctItalian;
  bool showCorrection = false;
  int correct = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    repo.init().then((_) => _loadSentence());
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void _loadSentence() {
    final s = repo.randomSentence();
    if (s != null) {
      setState(() {
        currentFrench = s.french;
        correctItalian = s.italian;
        showCorrection = false;
        answerController.clear();
      });
    }
  }

  void _checkAnswer() {
    setState(() {
      showCorrection = true;
      total++;
      final userAnswer = answerController.text.trim().toLowerCase();
      final correct = correctItalian!.toLowerCase();
      // Simple comparison - could be enhanced with fuzzy matching
      if (userAnswer == correct) {
        this.correct++;
      }
    });
  }

  double get accuracy => total == 0 ? 0 : (correct / total * 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EE - Expression Écrite'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${accuracy.toStringAsFixed(0)}% ($correct/$total)',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Traduisez la phrase suivante en italien',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (currentFrench != null) ...[
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentFrench!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Votre traduction en italien',
                border: OutlineInputBorder(),
                hintText: 'Écrivez votre traduction ici...',
              ),
              maxLines: 3,
              enabled: !showCorrection,
            ),
            const SizedBox(height: 16),
            if (!showCorrection)
              FilledButton.icon(
                onPressed: answerController.text.trim().isEmpty ? null : _checkAnswer,
                icon: const Icon(Icons.check),
                label: const Text('Vérifier'),
              )
            else ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Correction',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        correctItalian!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Votre réponse: ${answerController.text}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadSentence,
                icon: const Icon(Icons.skip_next),
                label: const Text('Phrase suivante'),
              ),
            ],
          ] else
            const Center(child: Text('Aucune phrase disponible')),
        ],
      ),
    );
  }
}
