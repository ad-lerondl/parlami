import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> load(String path) {
    final file = File(path);
    expect(file.existsSync(), isTrue, reason: 'missing asset $path');
    return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  test('geo data is internally consistent', () {
    final data = load('assets/culture/geo_italia.json');
    final regions = (data['regions'] as List).cast<Map<String, dynamic>>();
    final cities = (data['cities'] as List).cast<Map<String, dynamic>>();

    expect(regions.length, 20);
    final regionIds = regions.map((region) => region['id'] as String).toSet();
    for (final city in cities) {
      expect(regionIds.contains(city['region']), isTrue,
          reason: 'city ${city['id']} references unknown region ${city['region']}');
    }
    for (final region in regions) {
      expect(region['name'], isNotEmpty);
      expect(region['fr'], isNotEmpty);
      expect(region['capital'], isNotEmpty);
      expect((region['specialties'] as List), isNotEmpty);
    }
  });

  test('pasta data references known regions', () {
    final geo = load('assets/culture/geo_italia.json');
    final pasta = load('assets/culture/pasta_italia.json');
    final regionIds = (geo['regions'] as List)
        .cast<Map<String, dynamic>>()
        .map((region) => region['id'] as String)
        .toSet();

    final shapes = (pasta['shapes'] as List).cast<Map<String, dynamic>>();
    expect(shapes.length, greaterThan(30));
    for (final shape in shapes) {
      expect(regionIds.contains(shape['region']), isTrue,
          reason: 'pasta ${shape['id']} references unknown region ${shape['region']}');
    }
  });

  test('song data has at least ten iconic songs', () {
    final data = load('assets/culture/canzoni.json');
    final songs = (data['songs'] as List).cast<Map<String, dynamic>>();
    expect(songs.length, greaterThanOrEqualTo(10));
    for (final song in songs) {
      expect(song['title'], isNotEmpty);
      expect(song['artist'], isNotEmpty);
      expect(song['year'], isNotEmpty);
      expect((song['vocab'] as List), isNotEmpty);
    }
  });

  test('history quiz has a valid correct index for every question', () {
    final data = load('assets/culture/storia_italia.json');
    final quiz = (data['quiz'] as List).cast<Map<String, dynamic>>();
    expect(quiz.length, greaterThanOrEqualTo(10));
    for (final item in quiz) {
      final options = item['options'] as List;
      final correct = (item['correct'] as num).toInt();
      expect(correct, inInclusiveRange(0, options.length - 1),
          reason: 'invalid correct index for quiz item ${item['id']}');
    }
  });
}
