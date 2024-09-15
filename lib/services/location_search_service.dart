import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LocationSearchService {
  final client = GraphQLClientSingleton().client;

  LocationSearchService();

  Future<Map<String, dynamic>?> getPlaceFromId(String id) async {
    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: Queries.getPlace,
          variables: {
            'id': id,
          },
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(result.exception);
        return null;
      }

      return result.data!['place'];
    } catch (e) {
      CustomErrorHandler.captureException(e);
      return null;
    }
  }
}

class OSMPlace {
  final int placeId;
  final String displayName;
  final double latitude;
  final double longitude;
  final String? city;
  final String? town;
  final String? village;
  final String country;

  OSMPlace({
    required this.placeId,
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.city,
    this.town,
    this.village,
    required this.country,
  });

  factory OSMPlace.fromJson(Map<String, dynamic> json) {
    return OSMPlace(
      placeId: json['place_id'],
      displayName: json['display_name'],
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
      city: json['address']['city'],
      town: json['address']['town'],
      village: json['address']['village'],
      country: json['address']['country'],
    );
  }
}
