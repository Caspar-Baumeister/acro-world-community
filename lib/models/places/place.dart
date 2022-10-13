import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Place {
  late String id;
  late String description;
  late LatLng latLng;

  Place({required this.id, required this.description, required this.latLng});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'latitude': latLng.latitude,
      'longitude': latLng.longitude
    };
  }

  Place.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    latLng = LatLng(json['latitude'], json['longitude']);
  }

  Place.fromGraphQL(QueryResult result) {
    Place.fromJson(result.data?['place']);
  }
}
