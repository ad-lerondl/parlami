import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppLocalizations.of(context)!.resultsComingSoon));
  }
}
