import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PlaceProvider extends ChangeNotifier {
  LocationSingleton locationSingelton = LocationSingleton();

  updatePlace(Place newPlace) {
    locationSingelton.setPlace(newPlace);
    notifyListeners();
  }

  updatePlaceByLaTLang(LatLng latLng) {
    locationSingelton.setPlace(
        Place(description: 'Map Area', id: 'maparea', latLng: latLng));
    notifyListeners();
  }
}
