import 'package:flutter/material.dart';
import 'eo/eo_view.dart';
import 'co/co_view.dart';
import 'ce/ce_view.dart';
import 'ee/ee_view.dart';

class TrainView extends StatelessWidget {
  const TrainView({super.key});
  @override
  Widget build(BuildContext context) {
    final modules = [
      _TrainModuleTile(
        title: 'EO - Expression Orale',
        subtitle: 'Répondre à voix haute',
        icon: Icons.mic,
        builder: (context) => const EOView(),
      ),
      _TrainModuleTile(
        title: 'CO - Compréhension Orale',
        subtitle: 'Écouter des stations radio',
        icon: Icons.radio,
        builder: (context) => const COView(),
      ),
      _TrainModuleTile(
        title: 'CE - Compréhension Écrite',
        subtitle: 'Lire des news italiennes',
        icon: Icons.article,
        builder: (context) => const CEView(),
      ),
      _TrainModuleTile(
        title: 'EE - Expression Écrite',
        subtitle: 'Traduire des phrases',
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
