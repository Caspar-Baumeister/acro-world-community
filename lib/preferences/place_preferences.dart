import 'dart:convert';

import 'package:acroworld/models/places/place.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacePreferences {
  static SharedPreferences? _preferences;

  static const _keySavedLocation = 'saved_location';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setSavedPlace(Place? place) async {
    if (_preferences != null) {
      await _preferences!.setString(_keySavedLocation, jsonEncode(place));
    }
  }

  static Place? getSavedPlace() {
    String? savedPlaceAsString = _preferences!.getString(_keySavedLocation);

    if (savedPlaceAsString != null &&
        savedPlaceAsString.runtimeType != Null &&
        savedPlaceAsString.isNotEmpty &&
        jsonDecode(savedPlaceAsString).runtimeType != Null) {
      print("savedPlaceAsString");
      print(savedPlaceAsString);
      print(savedPlaceAsString.runtimeType);
      return Place.fromJson(jsonDecode(savedPlaceAsString));
    } else {
      return null;
    }
  }

  static removeSavedPlace() async {
    if (_preferences != null) _preferences!.remove(_keySavedLocation);
  }
}
