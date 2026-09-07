import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/learn/numdate/numdate_view.dart';
import 'package:parlami/src/localization/app_localizations.dart';

void main() {
  group('NumDateView', () {
    testWidgets('allows checking a number answer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NumDateView(random: Random(0)),
        ),
      );

      final answerField = find
          .byWidgetPredicate(
            (widget) => widget is TextField && widget.decoration?.labelText == 'Ta réponse en lettres',
          )
          .first;

      await tester.enterText(answerField, '0');
      await tester.drag(find.byType(ListView).first, const Offset(0, -450));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vérifier').first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Réponse incorrecte'), findsOneWidget);
      expect(find.textContaining('Bonne réponse'), findsWidgets);
    });

    testWidgets('switches to the dates tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NumDateView(random: Random(1)),
        ),
      );

      await tester.tap(find.text('Dates'));
      await tester.pumpAndSettle();

      expect(find.text('Choisir la date d’aperçu'), findsOneWidget);
      expect(find.text('Entraînement'), findsOneWidget);
    });
  });
}
