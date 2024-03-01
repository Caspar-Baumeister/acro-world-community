import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';

class MapEventsProvider extends ChangeNotifier {
  // keeps track of the classevents in the map view
  bool _loading = true;
  final List<ClassEvent> _classeEvents = [];
  ClassEvent? selectedClassEvent;
  final LocationSingleton _locationSingleton = LocationSingleton();

  setPlaceFromPlace(Place place) {
    _locationSingleton.setPlace(place);
    fetchClasseEvents();
  }

  setPlaceToMapArea(LatLng latLng) {
    _locationSingleton.setPlace(
        Place(id: "card area", description: "Card Area", latLng: latLng));
    fetchClasseEvents();
  }

  Place get place => _locationSingleton.place;
  double get radius => _locationSingleton.radius;

  // fetch data init
  MapEventsProvider() {
    fetchClasseEvents();
  }

  setSelectedClassEvent(ClassEvent? classEvent) {
    selectedClassEvent = classEvent;
    notifyListeners();
  }

  // get the classevents
  List<ClassEvent> get classeEvents => _classeEvents;
  bool get loading => _loading;

  // fetch classevents from the backend in a certain radius of the location
  Future<void> fetchClasseEvents() async {
    // set loading
    _loading = true;
    notifyListeners();

    // fetch classevents from the backend
    QueryOptions options = QueryOptions(
      document: Queries.getClassEventsByDistance,
      variables: {
        "distance": _locationSingleton.radius,
        "latitude": _locationSingleton.place.latLng.latitude,
        "longitude": _locationSingleton.place.latLng.longitude,
      },
    );
    try {
      QueryResult<Object?> result =
          await GraphQLClientSingleton().query(options);

      if (result.hasException) {
        print("result.exception: ${result.exception}");
      }

      print(
          "result.data: ${result.data?['class_events_by_location_v1']?.length}");

      if (result.data != null &&
          result.data!['class_events_by_location_v1'] != null) {
        _classeEvents.clear();
        try {
          // Temporary list to hold new events
          var newEvents = List<ClassEvent>.from(
            result.data!['class_events_by_location_v1']
                .where((json) =>
                    json['class']?["location"]?["coordinates"] != null)
                .map((json) => ClassEvent.fromJson(json)),
          );

          // Loop through newEvents and add them if they don't exist in _classeEvents based on classId
          for (var newEvent in newEvents) {
            bool exists = _classeEvents.any(
                (existingEvent) => existingEvent.classId == newEvent.classId);
            if (!exists) {
              _classeEvents.add(newEvent);
            }
          }

          print("_classeEvents.length: ${_classeEvents.length}");
        } catch (e, s) {
          print("Error: $e");
          print("Stacktrace: $s");
        }
      }
    } catch (e) {
      CustomErrorHandler.captureException(e);
    }

    // set classevents
    _loading = false;
    notifyListeners();
  }
}
