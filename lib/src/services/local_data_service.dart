import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/performance_repository.dart';
import '../repositories/vocab_repository.dart';
import 'vocab_database.dart';

/// Supprime les donnees d'apprentissage stockees localement sur l'appareil.
///
/// Conserve volontairement la session d'authentification, la langue et le
/// theme : l'effacement cible la progression (vocabulaire utilisateur, stats,
/// tentatives de performance) et les reglages d'exercices.
class LocalDataService {
  const LocalDataService._();

  static const _performanceStoreName = 'performance_attempts';
  static const _vocabMetaStoreName = 'vocab_meta';

  static const _conjugationPrefsPrefix = 'conj.';
  static const _remindersEnabledKey = 'retention_reminders_enabled';

  static Future<void> clearAllLocalData() async {
    await PerformanceRepository().clearAll();

    final vocabRepository = VocabRepository();
    await vocabRepository.resetOriginalWords();
    for (final word in vocabRepository.userWords().toList(growable: false)) {
      await vocabRepository.remove(word.id);
    }

    final database = await openVocabDatabase();
    for (final storeName in [
      _performanceStoreName,
      _vocabMetaStoreName,
    ]) {
      final store = stringMapStoreFactory.store(storeName);
      await store.delete(database);
    }

    final preferences = await SharedPreferences.getInstance();
    final keys = preferences
        .getKeys()
        .where((key) =>
            key.startsWith(_conjugationPrefsPrefix) ||
            key == _remindersEnabledKey)
        .toList(growable: false);
    for (final key in keys) {
      await preferences.remove(key);
    }
  }
}
