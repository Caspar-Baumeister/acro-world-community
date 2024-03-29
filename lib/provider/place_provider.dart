import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:flutter/material.dart';

class PlaceProvider extends ChangeNotifier {
  Place? place;

  PlaceProvider() {
    // get the place from shared preferences
    place = PlacePreferences.getSavedPlace();
  }

  updatePlace(Place? newPlace) {
    place = newPlace;
    // save the place to shared preferences
    PlacePreferences.setSavedPlace(place);
    notifyListeners();
  }
}
