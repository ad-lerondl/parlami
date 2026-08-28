import 'package:sembast_web/sembast_web.dart';

Future<Database> openDatabaseForVocab() async {
  return databaseFactoryWeb.openDatabase('parlami_vocabulaire');
}
