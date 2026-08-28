import 'vocab_export_service_stub.dart'
    if (dart.library.io) 'vocab_export_service_io.dart'
    if (dart.library.html) 'vocab_export_service_web.dart';

Future<String> exportVocabJson(String fileName, String content) => exportVocabJsonPlatform(fileName, content);
