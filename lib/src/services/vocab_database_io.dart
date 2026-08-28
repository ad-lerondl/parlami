import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

Future<Database> openDatabaseForVocab() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}${Platform.pathSeparator}parlami_vocabulaire.db';
  return databaseFactoryIo.openDatabase(path);
}
