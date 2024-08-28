import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarProvider extends ChangeNotifier {
  // keeps track of the classevents in the map view
  // location singleton
  final LocationSingleton _locationSingleton = LocationSingleton();
  bool _loading = true;
  List<ClassEvent> _weekClassEvents = [];
  late DateTime to;
  late DateTime from;
  DateTime? _focusedDay;

  // get radius from location singleton
  double get radius => _locationSingleton.radius;

  // get place from location singleton
  Place get place => _locationSingleton.place;

  // fetch data init
  CalendarProvider() {
    DateTime now = DateTime.now();
    to = DateTime(now.year, now.month, now.day + (7 - now.weekday), 23);
    from = DateTime(now.year, now.month, now.day);
    _focusedDay = DateTime.now();
    fetchClasseEvents();
  }

  getClassEventsForDay(DateTime day) {
    return weekClassEvents
        .where((event) => isSameDay(event.startDateDT, day))
        .toList();
  }

  // get the classevents
  List<ClassEvent> get weekClassEvents => _weekClassEvents
      .where((clasEvent) =>
          (clasEvent.classModel?.amountActiveFlaggs ?? 0) <
          AppConstants.activeFlaggThreshold)
      .toList();
  bool get loading => _loading;
  List<ClassEvent> get focusedDayClassEvents {
    List<ClassEvent> dayClassEvents = _weekClassEvents
        .where((event) => isSameDay(event.startDateDT, _focusedDay))
        .toList();
    dayClassEvents
        .sort((a, b) => b.startDateDT.isBefore(a.startDateDT) ? 1 : 0);

    return dayClassEvents;
  }

  // get the focused day
  DateTime get focusedDay => _focusedDay ?? DateTime.now();

  // set the focused day
  void setFocusedDay(DateTime newFocusedDay) {
    // if the focusday is previous to the current day, set it to the current day
    if (newFocusedDay.isBefore(DateTime.now())) {
      _focusedDay = DateTime.now();
    } else {
      _focusedDay = newFocusedDay;
    }
    notifyListeners();
  }

  void onPageChanged(newDay) {
    DateTime monday =
        DateTime(newDay.year, newDay.month, newDay.day - newDay.weekday + 1);
    DateTime firstValidDayOfWeek = laterDay(monday, DateTime.now());
    from = DateTime(firstValidDayOfWeek.year, firstValidDayOfWeek.month,
        firstValidDayOfWeek.day - firstValidDayOfWeek.weekday);

    to = DateTime(firstValidDayOfWeek.year, firstValidDayOfWeek.month,
        firstValidDayOfWeek.day + (7 - firstValidDayOfWeek.weekday), 23);

    setFocusedDay(firstValidDayOfWeek);
    fetchClasseEvents();
  }

  // increase radius by two fold and refetch classevents (increase radius)
  Future<void> increaseRadius() async {
    _locationSingleton.setRadius(_locationSingleton.radius * 2);
    await fetchClasseEvents();
  }

  // fetch classevents from the backend in a certain radius of the location
  Future<void> fetchClasseEvents() async {
    // set loading
    _loading = true;
    notifyListeners();

    Place place = _locationSingleton.place;
    double radius = _locationSingleton.radius;

    QueryOptions queryOptions = QueryOptions(
      document: Queries.getClassEventsFromToLocationWithClass,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "from": from.toIso8601String(),
        "to": to.toIso8601String(),
        'latitude': place.latLng.latitude,
        'longitude': place.latLng.longitude,
        'distance': radius, //distance,
      },
    );
    String selector = 'class_events_by_location_v1';
    try {
      // Correct usage
      final graphQLClient = GraphQLClientSingleton().client;

      QueryResult<Object?> result = await graphQLClient.query(queryOptions);

      if (result.hasException) {
        CustomErrorHandler.captureException(result.exception!);
        return;
      }

      if (result.data != null && result.data![selector] != null) {
        _weekClassEvents.clear();
        try {
          // Temporary list to hold new events
          _weekClassEvents = List<ClassEvent>.from(
            result.data!['class_events_by_location_v1']
                .where((json) =>
                    json['class']?["location"]?["coordinates"] != null)
                .map((json) => ClassEvent.fromJson(json)),
          );
        } catch (e, s) {
          CustomErrorHandler.captureException(e, stackTrace: s);
        }
      }
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    // set classevents
    _loading = false;
    notifyListeners();
  }
}
