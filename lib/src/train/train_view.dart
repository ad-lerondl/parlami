import 'package:flutter/material.dart';
import 'eo/eo_view.dart';
import 'co/co_view.dart';
import 'ce/ce_view.dart';
import 'ee/ee_view.dart';
import '../localization/app_localizations.dart';

class TrainView extends StatelessWidget {
  const TrainView({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modules = [
      _TrainModuleTile(
        title: l10n.trainOralExpression,
        subtitle: l10n.trainOralExpressionDescription,
        icon: Icons.mic,
        builder: (context) => const EOView(),
      ),
      _TrainModuleTile(
        title: l10n.trainOralComprehension,
        subtitle: l10n.trainOralComprehensionDescription,
        icon: Icons.radio,
        builder: (context) => const COView(),
      ),
      _TrainModuleTile(
        title: l10n.trainWrittenComprehension,
        subtitle: l10n.trainWrittenComprehensionDescription,
        icon: Icons.article,
        builder: (context) => const CEView(),
      ),
      _TrainModuleTile(
        title: l10n.trainWrittenExpression,
        subtitle: l10n.trainWrittenExpressionDescription,
        icon: Icons.translate,
        builder: (context) => const EEView(),
      ),
    ];

    return ListView.separated(
      itemCount: modules.length,
      itemBuilder: (context, index) => modules[index],
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }
}

class _TrainModuleTile extends StatelessWidget {
  const _TrainModuleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: builder),
      ),
    );
  }
}
