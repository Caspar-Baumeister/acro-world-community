import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationSingleton extends ChangeNotifier {
  Place? _place;
  double? _radius;
  static final LocationSingleton _instance = LocationSingleton._internal();

  // Private constructor
  LocationSingleton._internal() {
    // get the place from shared preferences
    _place = PlacePreferences.getSavedPlace();
    _radius = PlacePreferences.getRadius();
  }

  // Public factory constructor
  factory LocationSingleton() => _instance;

  // Getter for place
  Place get place =>
      _place ??
      Place(
        id: 'berlin',
        description: 'Berlin, Germany',
        latLng: const LatLng(52.5200, 13.4050),
      );
  double get radius => _radius ?? 70;

  void setRadius(double newRadius) {
    _radius = newRadius;
  }

  void setPlace(Place? newPlace) {
    _place = newPlace;
    // save the place to shared preferences
    PlacePreferences.setSavedPlace(_place);
  }
}
