import 'package:flutter/material.dart';
import 'eo/eo_view.dart';
import 'co/co_view.dart';
import 'ce/ce_view.dart';
import 'ee/ee_view.dart';
import '../localization/app_localizations.dart';
import '../widgets/module_info_sheet.dart';

class TrainView extends StatelessWidget {
  const TrainView({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modules = [
      _TrainModuleTile(
        title: l10n.trainOralExpression,
        subtitle: l10n.trainOralExpressionDescription,
        why: l10n.trainOralExpressionWhy,
        icon: Icons.mic,
        builder: (context) => const EOView(),
      ),
      _TrainModuleTile(
        title: l10n.trainOralComprehension,
        subtitle: l10n.trainOralComprehensionDescription,
        why: l10n.trainOralComprehensionWhy,
        icon: Icons.radio,
        builder: (context) => const COView(),
      ),
      _TrainModuleTile(
        title: l10n.trainWrittenComprehension,
        subtitle: l10n.trainWrittenComprehensionDescription,
        why: l10n.trainWrittenComprehensionWhy,
        icon: Icons.article,
        builder: (context) => const CEView(),
      ),
      _TrainModuleTile(
        title: l10n.trainWrittenExpression,
        subtitle: l10n.trainWrittenExpressionDescription,
        why: l10n.trainWrittenExpressionWhy,
        icon: Icons.translate,
        builder: (context) => const EEView(),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            l10n.trainSectionIntro,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: modules.length,
            itemBuilder: (context, index) => modules[index],
            separatorBuilder: (_, __) => const Divider(height: 0),
          ),
        ),
      ],
    );
  }
}

class _TrainModuleTile extends StatelessWidget {
  const _TrainModuleTile({
    required this.title,
    required this.subtitle,
    required this.why,
    required this.icon,
    required this.builder,
  });
  final String title;
  final String subtitle;
  final String why;
  final IconData icon;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.info_outline, size: 20),
            color: Theme.of(context).colorScheme.outline,
            tooltip: l10n.moduleWhyTitle,
            onPressed: () => showModuleInfoSheet(
              context,
              icon: icon,
              heading: l10n.moduleWhyTitle,
              title: title,
              message: why,
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: builder),
      ),
    );
  }
}
