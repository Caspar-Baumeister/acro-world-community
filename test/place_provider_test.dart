import 'package:flutter_test/flutter_test.dart';
import 'package:acroworld/provider/riverpod_provider/place_provider.dart';
import 'package:acroworld/data/models/places/place.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('PlaceProvider Tests', () {
    test('PlaceNotifier should initialize with null state', () {
      final notifier = PlaceNotifier.test();
      expect(notifier.state, isNull);
    });

    test('PlaceNotifier should update place', () {
      final notifier = PlaceNotifier.test();
      final testPlace = Place(
        id: 'test_id',
        description: 'Test Place',
        latLng: const LatLng(52.5200, 13.4050),
      );

      notifier.updatePlace(testPlace);
      expect(notifier.state, equals(testPlace));
      expect(notifier.currentPlace, equals(testPlace));
    });

    test('PlaceNotifier should update place by coordinates', () {
      final notifier = PlaceNotifier.test();
      const testLatLng = LatLng(52.5200, 13.4050);

      notifier.updatePlaceByLatLng(testLatLng);
      
      expect(notifier.state, isNotNull);
      expect(notifier.state!.id, equals('map_area'));
      expect(notifier.state!.description, equals('Map Area'));
      expect(notifier.state!.latLng, equals(testLatLng));
    });

    test('PlaceNotifier should handle multiple place updates', () {
      final notifier = PlaceNotifier.test();
      
      final place1 = Place(
        id: 'place1',
        description: 'First Place',
        latLng: const LatLng(52.5200, 13.4050),
      );
      
      final place2 = Place(
        id: 'place2',
        description: 'Second Place',
        latLng: const LatLng(48.8566, 2.3522),
      );

      notifier.updatePlace(place1);
      expect(notifier.state, equals(place1));

      notifier.updatePlace(place2);
      expect(notifier.state, equals(place2));
      expect(notifier.state!.id, equals('place2'));
    });

    test('PlaceNotifier should handle coordinate updates after place updates', () {
      final notifier = PlaceNotifier.test();
      
      final testPlace = Place(
        id: 'test_place',
        description: 'Test Place',
        latLng: const LatLng(52.5200, 13.4050),
      );

      notifier.updatePlace(testPlace);
      expect(notifier.state!.id, equals('test_place'));

      const newCoordinates = LatLng(48.8566, 2.3522);
      notifier.updatePlaceByLatLng(newCoordinates);
      
      expect(notifier.state!.id, equals('map_area'));
      expect(notifier.state!.latLng, equals(newCoordinates));
    });
  });
}
