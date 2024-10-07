import 'package:acroworld/core/exceptions/error_handler.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/places/place.dart';
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

    print(_locationSingleton.place.description);
    print(_locationSingleton.radius);

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

          for (var newEvent in newEvents) {
            int index = _classeEvents.indexWhere(
                (existingEvent) => existingEvent.classId == newEvent.classId);

            if (index != -1) {
              // Event exists, check if the new event's start date is earlier
              if (newEvent.startDateDT
                  .isBefore(_classeEvents[index].startDateDT)) {
                _classeEvents[index] = newEvent; // Update the existing event
              }
            } else {
              _classeEvents.add(newEvent); // Add new event as it does not exist
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
