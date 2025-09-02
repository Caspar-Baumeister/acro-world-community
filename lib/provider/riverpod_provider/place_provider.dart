import 'package:acroworld/data/models/places/place.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class PlaceNotifier extends StateNotifier<Place?> {
  PlaceNotifier() : super(null) {
    // Initialize with current place if available
    _initializePlace();
  }

  // Test constructor that doesn't initialize from preferences
  PlaceNotifier.test() : super(null);

  void _initializePlace() {
    try {
      final currentPlace = LocationSingleton().place;
      if (currentPlace != null) {
        state = currentPlace;
        CustomErrorHandler.logDebug('PlaceNotifier: Initialized with current place');
      }
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }
  }

  void updatePlace(Place newPlace) {
    CustomErrorHandler.logDebug('PlaceNotifier: Updating place to ${newPlace.description}');
    try {
      LocationSingleton().setPlace(newPlace);
      state = newPlace;
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      // In test mode, just update the state without calling LocationSingleton
      state = newPlace;
    }
  }

  void updatePlaceByLatLng(LatLng latLng) {
    CustomErrorHandler.logDebug('PlaceNotifier: Updating place by coordinates');
    try {
      final newPlace = Place(
        description: 'Map Area',
        id: 'map_area',
        latLng: latLng,
      );
      LocationSingleton().setPlace(newPlace);
      state = newPlace;
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      // In test mode, just update the state without calling LocationSingleton
      final newPlace = Place(
        description: 'Map Area',
        id: 'map_area',
        latLng: latLng,
      );
      state = newPlace;
    }
  }

  Place? get currentPlace => state;
}

final placeProvider = StateNotifierProvider<PlaceNotifier, Place?>((ref) {
  return PlaceNotifier();
});
