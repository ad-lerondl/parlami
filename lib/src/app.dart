import 'package:flutter/material.dart';
import 'localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'learn/learn_view.dart';
import 'train/train_view.dart';
import 'evaluate/evaluate_view.dart';
import 'results/results_view.dart';
import 'profile/profile_view.dart';
import 'settings/settings_controller.dart';
import 'services/radio_player_service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr'),
            Locale('en'),
            Locale('es'),
            Locale('de'),
            Locale('pt'),
            Locale('ar'),
            Locale('ru'),
            Locale('ja'),
            Locale('he'),
            Locale('pl'),
            Locale('ro'),
            Locale('sv'),
            Locale('tr'),
          ],
          locale: settingsController.locale,

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          home: _HomeShell(settingsController: settingsController),
        );
      },
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell({required this.settingsController});
  final SettingsController settingsController;

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 0;
  AppLifecycleListener? _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onDetach: () {
        RadioPlayerService().stop();
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    super.dispose();
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const LearnView();
      case 1:
        return const TrainView();
      case 2:
        return const EvaluateView();
      case 3:
        return const ResultsView();
      case 4:
        return ProfileView(controller: widget.settingsController);
      default:
        return const LearnView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _getPage(_index),
            ),
          ),
          _GlobalRadioControl(service: RadioPlayerService()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.school), label: l10n.navLearn),
          NavigationDestination(icon: const Icon(Icons.fitness_center), label: l10n.navTrain),
          NavigationDestination(icon: const Icon(Icons.verified_user), label: l10n.navEvaluate),
          NavigationDestination(icon: const Icon(Icons.insights), label: l10n.navResults),
          NavigationDestination(icon: const Icon(Icons.person), label: l10n.navProfile),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _GlobalRadioControl extends StatelessWidget {
  const _GlobalRadioControl({required this.service});

  final RadioPlayerService service;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<String?>(
      stream: service.currentStationStream,
      builder: (context, stationSnapshot) {
        final station = stationSnapshot.data;
        if (station == null) return const SizedBox.shrink();

        return Material(
          color: Theme.of(context).colorScheme.inverseSurface,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.radio, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      station,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: service.isPlayingStream,
                    builder: (context, playingSnapshot) {
                      final isPlaying = playingSnapshot.data ?? false;
                      return IconButton(
                        tooltip: isPlaying ? l10n.coPause : l10n.coResume,
                        color: Colors.white,
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: service.togglePlayback,
                      );
                    },
                  ),
                  IconButton(
                    tooltip: l10n.coStop,
                    color: Colors.white,
                    icon: const Icon(Icons.stop),
                    onPressed: service.stop,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
