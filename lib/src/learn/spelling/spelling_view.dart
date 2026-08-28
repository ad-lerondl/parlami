import 'package:flutter/material.dart';

class SpellingView extends StatelessWidget {
  const SpellingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orthographe')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Module d\'orthographe — à venir.'),
      ),
    );
  }
}
