import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/places/place.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:acroworld/utils/app_constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

/// State for calendar management
class CalendarState {
  final bool loading;
  final List<ClassEvent> weekClassEvents;
  final DateTime? focusedDay;
  final DateTime to;
  final DateTime from;

  const CalendarState({
    this.loading = true,
    this.weekClassEvents = const [],
    this.focusedDay,
    required this.to,
    required this.from,
  });

  CalendarState copyWith({
    bool? loading,
    List<ClassEvent>? weekClassEvents,
    DateTime? focusedDay,
    DateTime? to,
    DateTime? from,
  }) {
    return CalendarState(
      loading: loading ?? this.loading,
      weekClassEvents: weekClassEvents ?? this.weekClassEvents,
      focusedDay: focusedDay ?? this.focusedDay,
      to: to ?? this.to,
      from: from ?? this.from,
    );
  }
}

/// Notifier for calendar state management
class CalendarNotifier extends StateNotifier<CalendarState> {
  final LocationSingleton _locationSingleton = LocationSingleton();

  CalendarNotifier() : super(CalendarState(
    to: DateTime.now().add(const Duration(days: 7)),
    from: DateTime.now().subtract(const Duration(days: 7)),
  )) {
    _initializeCalendar();
  }

  /// Get radius from location singleton
  double get radius => _locationSingleton.radius;

  /// Get place from location singleton
  Place get place => _locationSingleton.place;

  /// Initialize calendar data
  Future<void> _initializeCalendar() async {
    await fetchWeekClassEvents();
  }

  /// Fetch week class events
  Future<void> fetchWeekClassEvents() async {
    try {
      state = state.copyWith(loading: true);
      
      final client = GraphQLClientSingleton().client;
      final result = await client.query(QueryOptions(
        document: Queries.getClassEventsFromToLocationWithClass,
        variables: {
          'from': state.from.toIso8601String(),
          'to': state.to.toIso8601String(),
          'latitude': place.latLng.latitude,
          'longitude': place.latLng.longitude,
          'distance': radius,
        },
      ));

      if (result.hasException) {
        CustomErrorHandler.logError('Error fetching week class events: ${result.exception}');
        state = state.copyWith(loading: false);
        return;
      }

      final List<dynamic> eventsData = result.data?['class_events_by_location_v1'] ?? [];
      final List<ClassEvent> events = eventsData
          .map((eventData) => ClassEvent.fromJson(eventData))
          .toList();

      state = state.copyWith(
        weekClassEvents: events,
        loading: false,
      );

      CustomErrorHandler.logDebug('Fetched ${events.length} week class events');
    } catch (e) {
      CustomErrorHandler.logError('Error in fetchWeekClassEvents: $e');
      state = state.copyWith(loading: false);
    }
  }

  /// Set focused day
  void setFocusedDay(DateTime day) {
    state = state.copyWith(focusedDay: day);
  }

  /// Update date range
  void updateDateRange(DateTime from, DateTime to) {
    state = state.copyWith(from: from, to: to);
    fetchWeekClassEvents();
  }

  /// Test constructor for unit tests
  CalendarNotifier.test() : super(CalendarState(
    to: DateTime.now().add(const Duration(days: 7)),
    from: DateTime.now().subtract(const Duration(days: 7)),
  ));
}

/// Provider for calendar state
final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  return CalendarNotifier();
});
