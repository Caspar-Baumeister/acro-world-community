import 'dart:async';

import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/create_jam_event.dart';
import 'package:acroworld/events/jams/participate_to_jam_event.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/activity_calender_widget.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ActivitiesQuery extends StatefulWidget {
  const ActivitiesQuery({Key? key, required this.activityType})
      : super(key: key);
  // gets the input from classes/jams tabbar -> decides on selector and query
  final String activityType;

  @override
  State<ActivitiesQuery> createState() => _ActivitiesQueryState();
}

class _ActivitiesQueryState extends State<ActivitiesQuery> {
  String from = DateTime.now().toIso8601String();
  late String to;
  DateTime focusedDay = DateTime.now();
  DateTime initialSelectedDate = DateTime.now();
  List<StreamSubscription> eventListeners = [];

  @override
  void dispose() {
    super.dispose();
    for (final eventListener in eventListeners) {
      eventListener.cancel();
    }
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    to = DateTime(now.year, now.month, now.day + (7 - now.weekday))
        .toIso8601String();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = Provider.of<PlaceProvider>(context);
    // gets the input from location
    // locationprovider listening

    Place? place = placeProvider.place;
    QueryOptions queryOptions;
    String selector;

    onPageChanged(focusDay) {
      setState(() {
        from = DateTime(
                focusDay.year, focusDay.month, focusDay.day - focusDay.weekday)
            .toIso8601String();
        to = DateTime(focusDay.year, focusDay.month,
                focusDay.day + (7 - focusDay.weekday))
            .toIso8601String();
      });
    }

    // 4 cases
    // 1. jams without place
    // 2. jams with place
    // 3. classevents without place
    // 4. classevents with place

    if (widget.activityType == "jams") {
      if (place == null) {
        queryOptions = QueryOptions(
          document: Queries.jamsFromTo,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {"from": from, "to": to},
        );
        selector = 'jams';
      } else {
        queryOptions = QueryOptions(
          document: Queries.jamsFromToWithDistance,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {
            "from": from,
            "to": to,
            'latitude': place.latLng.latitude,
            'longitude': place.latLng.longitude,
            'distance': 100
          },
        );
        selector = 'jams_by_location_v1';
      }
    } else {
      if (place == null) {
        queryOptions = QueryOptions(
          document: Queries.getClassEventsFromToWithClass,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {"from": from, "to": to},
        );
        selector = 'class_events';
      } else {
        queryOptions = QueryOptions(
          document: Queries.getClassEventsFromToLocationWithClass,
          variables: {
            'latitude': place.latLng.latitude,
            'longitude': place.latLng.longitude,
            "from": from,
            "to": to,
            'distance': 100
          },
          fetchPolicy: FetchPolicy.networkOnly,
        );
        selector = 'class_events_by_location_v1';
      }
    }
    // choose queryoption based on activityType
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context, listen: false);
    final EventBus eventBus = eventBusProvider.eventBus;
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);

    return Query(
        options: queryOptions,
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return IgnorePointer(
              ignoring: true,
              child: Stack(
                children: [
                  ActivityCalenderWidget(
                      activiyType: widget.activityType,
                      onPageChanged: onPageChanged,
                      classWeekEvents: const [],
                      jamWeekEvents: const [],
                      focusedDay: focusedDay,
                      setFocusedDay: (newFocusedDay) => setState(() {
                            focusedDay = newFocusedDay;
                          }),
                      setInitialSelectedDate: (newInitialSelectedDate) =>
                          setState(() {
                            initialSelectedDate = newInitialSelectedDate;
                          }),
                      initialSelectedDate: initialSelectedDate),
                  const Positioned.fill(
                      child: Center(child: CircularProgressIndicator()))
                ],
              ),
            );
          }
          Future<void> runRefetch() async {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
            }
          }

          // if jams are viewed, refetch when participate to jam and created jam
          if (widget.activityType == "jams") {
            eventListeners
                .add(eventBus.on<ParticipateToJamEvent>().listen((event) {
              runRefetch();
            }));

            eventListeners.add(eventBus.on<CrudJamEvent>().listen((event) {
              runRefetch();
            }));
          }

          List<NewClassEventsModel> classWeekEvents = [];
          List<Jam> jamWeekEvents = [];

          if (widget.activityType == "jams") {
            try {
              jamWeekEvents = List<Jam>.from(
                  result.data![selector].map((json) => Jam.fromJson(json)));
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                activityProvider.setActiveJams(jamWeekEvents
                    .where((jam) => isSameDate(jam.dateAsDateTime!, focusedDay))
                    .toList());
              });
            } catch (e) {
              print(e.toString());
            }
          } else {
            try {
              classWeekEvents = List<NewClassEventsModel>.from(result
                  .data![selector]
                  .map((json) => NewClassEventsModel.fromJson(json)));
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                activityProvider.setActiveClasses(classWeekEvents
                    .where((NewClassEventsModel classEvent) =>
                        isSameDate(classEvent.date!, focusedDay))
                    .toList());
              });
            } catch (e) {
              print(e.toString());
            }

            try {
              classWeekEvents.sort((a, b) => DateTime.parse(b.startDate!)
                      .isBefore(DateTime.parse(a.startDate!))
                  ? 1
                  : 0);
            } catch (e) {
              print(e.toString());
            }
          }
          return ActivityCalenderWidget(
              activiyType: widget.activityType,
              onPageChanged: onPageChanged,
              jamWeekEvents: jamWeekEvents,
              classWeekEvents: classWeekEvents,
              focusedDay: focusedDay,
              setInitialSelectedDate: (newInitialSelectedDate) => setState(() {
                    initialSelectedDate = newInitialSelectedDate;
                  }),
              setFocusedDay: (newFocusedDay) => setState(() {
                    focusedDay = newFocusedDay;
                  }),
              initialSelectedDate: initialSelectedDate);
        });
  }
}
