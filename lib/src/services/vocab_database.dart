import 'package:sembast/sembast.dart';

import 'vocab_database_stub.dart'
    if (dart.library.io) 'vocab_database_io.dart'
    if (dart.library.html) 'vocab_database_web.dart';

Future<Database> openVocabDatabase() => openDatabaseForVocab();
