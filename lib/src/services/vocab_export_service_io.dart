import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<String> exportVocabJsonPlatform(String fileName, String content) async {
  final directory = await getTemporaryDirectory();
  final exportDirectory = Directory('${directory.path}${Platform.pathSeparator}parlami_exports');
  if (!await exportDirectory.exists()) {
    await exportDirectory.create(recursive: true);
  }
  final file = File('${exportDirectory.path}${Platform.pathSeparator}$fileName');
  await file.writeAsString(content);
  await Share.shareXFiles([XFile(file.path)], subject: 'Export vocabulaire Parlami');
  return file.path;
}
