import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> _decodeJsonList(String raw) async {
  final list = json.decode(raw) as List<dynamic>;
  return list.cast<Map<String, dynamic>>();
}

class AssetLoader {
  static final Map<String, dynamic> _cache = {};

  static Future<dynamic> loadJson(String path) async {
    if (_cache.containsKey(path)) return _cache[path];
    final raw = await rootBundle.loadString(path);
    final decoded = json.decode(raw);
    _cache[path] = decoded;
    return decoded;
  }

  static Future<List<Map<String, dynamic>>> loadJsonListFast(String path) async {
    if (_cache.containsKey(path)) return _cache[path] as List<Map<String, dynamic>>;
    final raw = await rootBundle.loadString(path);
    final decoded = await compute(_decodeJsonList, raw);
    _cache[path] = decoded;
    return decoded;
  }
}
