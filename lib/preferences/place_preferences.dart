import 'dart:convert';

import 'package:acroworld/data/models/places/place.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacePreferences {
  static SharedPreferences? _preferences;

  static const _keySavedLocation = 'saved_location';
  static const _keyRadius = 'radius';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setSavedPlace(Place? place) async {
    if (_preferences != null) {
      await _preferences!.setString(_keySavedLocation, jsonEncode(place));
    }
  }

  static Future setRadius(double radius) async {
    if (_preferences != null) {
      await _preferences!.setDouble(_keyRadius, radius);
    }
  }

  static double? getRadius() {
    if (_preferences != null) {
      return _preferences!.getDouble(_keyRadius);
    } else {
      return null;
    }
  }

  static Place? getSavedPlace() {
    String? savedPlaceAsString = _preferences!.getString(_keySavedLocation);

    if (savedPlaceAsString != null &&
        savedPlaceAsString.runtimeType != Null &&
        savedPlaceAsString.isNotEmpty &&
        jsonDecode(savedPlaceAsString).runtimeType != Null) {
      print("savedPlaceAsString: $savedPlaceAsString");
      return Place.fromJson(jsonDecode(savedPlaceAsString));
    } else {
      return null;
    }
  }

  static removeSavedPlace() async {
    if (_preferences != null) _preferences!.remove(_keySavedLocation);
  }
}
