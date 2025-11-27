import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/places/place.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';

/// State for map events
class MapEventsState {
  final bool loading;
  final List<ClassEvent> classeEvents;
  final ClassEvent? selectedClassEvent;
  final String? error;

  const MapEventsState({
    this.loading = true,
    this.classeEvents = const [],
    this.selectedClassEvent,
    this.error,
  });

  MapEventsState copyWith({
    bool? loading,
    List<ClassEvent>? classeEvents,
    ClassEvent? selectedClassEvent,
    String? error,
  }) {
    return MapEventsState(
      loading: loading ?? this.loading,
      classeEvents: classeEvents ?? this.classeEvents,
      selectedClassEvent: selectedClassEvent ?? this.selectedClassEvent,
      error: error ?? this.error,
    );
  }
}

/// Notifier for map events
class MapEventsNotifier extends StateNotifier<MapEventsState> {
  final LocationSingleton _locationSingleton = LocationSingleton();

  MapEventsNotifier() : super(const MapEventsState()) {
    fetchClasseEvents();
  }

  /// Test constructor for unit tests
  MapEventsNotifier.test() : super(const MapEventsState());

  /// Set place from Place object
  void setPlaceFromPlace(Place place) {
    _locationSingleton.setPlace(place);
    fetchClasseEvents();
  }

  /// Set place to map area using LatLng
  void setPlaceToMapArea(LatLng latLng) {
    _locationSingleton.setPlace(
      Place(id: "card area", description: "Card Area", latLng: latLng),
    );
    fetchClasseEvents();
  }

  /// Get current place
  Place get place => _locationSingleton.place;

  /// Get current radius
  double get radius => _locationSingleton.radius;

  /// Set selected class event
  void setSelectedClassEvent(ClassEvent? classEvent) {
    state = state.copyWith(selectedClassEvent: classEvent);
  }

  /// Fetch class events from the backend in a certain radius of the location
  Future<void> fetchClasseEvents() async {
    state = state.copyWith(loading: true, error: null);

    try {
      final graphQLClient = GraphQLClientSingleton().client;
      final queryOptions = QueryOptions(
        document: Queries.getClassEventsByDistance,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "distance": _locationSingleton.radius,
          "latitude": _locationSingleton.place.latLng.latitude,
          "longitude": _locationSingleton.place.latLng.longitude,
        },
      );

      final result = await graphQLClient.query(queryOptions);

      if (result.hasException) {
        CustomErrorHandler.logError(
            'Error fetching class events: ${result.exception}');
        state = state.copyWith(
          loading: false,
          error: 'Failed to load class events',
        );
        return;
      }

      if (result.data != null &&
          result.data!["class_events_by_location_v1"] != null) {
        try {
          final classeEvents = List<ClassEvent>.from(
            result.data!["class_events_by_location_v1"]
                .map((json) => ClassEvent.fromJson(json)),
          );

          state = state.copyWith(
            classeEvents: classeEvents,
            loading: false,
          );
        } catch (e) {
          CustomErrorHandler.logError('Error parsing class events: $e');
          state = state.copyWith(
            loading: false,
            error: 'Failed to parse class events',
          );
        }
      } else {
        state = state.copyWith(
          classeEvents: [],
          loading: false,
        );
      }
    } catch (e) {
      CustomErrorHandler.logError('Error fetching class events: $e');
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear all data
  void clear() {
    state = const MapEventsState();
  }
}

/// Provider for map events
final mapEventsProvider =
    StateNotifierProvider<MapEventsNotifier, MapEventsState>(
  (ref) => MapEventsNotifier(),
);
