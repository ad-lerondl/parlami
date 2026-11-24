import 'package:flutter_test/flutter_test.dart';
import 'package:parlami/src/repositories/radio_stations_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('radio stations asset loads with playable stream URLs', () async {
    final repository = RadioStationsRepository();
    await repository.init();
    final stations = repository.all();

    expect(stations, isNotEmpty);
    for (final station in stations) {
      expect(station.name, isNotEmpty);
      expect(station.streamUrl, startsWith('http'));
      expect(station.descriptionKey, isNotEmpty);
      expect(station.descriptionKey.length, greaterThan(0));
    }
  });
}
