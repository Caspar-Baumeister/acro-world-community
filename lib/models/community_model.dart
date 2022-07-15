import 'package:google_maps_flutter/google_maps_flutter.dart';

class Community {
  String name;
  String id;
  bool confirmed;
  LatLng latLng;

  Community({
    required this.id,
    required this.name,
    required this.confirmed,
    required this.latLng,
  });

  factory Community.fromJson(dynamic json) {
    return Community(
      id: json['id'],
      name: json["name"],
      confirmed: json["confirmed"],
      latLng: LatLng(json['latitude'], json['longitude']),
    );
  }
}
