import 'dart:async';

import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/create_jam_event.dart';
import 'package:acroworld/events/jams/participate_to_jam_event.dart';

import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/home_screens/activities/activity_calender_widget.dart';
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
    to = DateTime(now.year, now.month, now.day + (7 - now.weekday), 23)
        .toIso8601String();

    super.initState();
  }

  onPageChanged(focusDay) {
    setState(() {
      from = DateTime(
              focusDay.year, focusDay.month, focusDay.day - focusDay.weekday)
          .toIso8601String();
      to = DateTime(focusDay.year, focusDay.month,
              focusDay.day + (7 - focusDay.weekday), 23)
          .toIso8601String();
    });
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = Provider.of<PlaceProvider>(context);
    // gets the input from location
    // locationprovider listening

    Place? place = placeProvider.place;
    QueryOptions queryOptions;
    String selector;

    if (place == null) {
      queryOptions = QueryOptions(
        document: Queries.getClassEventsFromToWithClass,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "from": from,
          "to": to,
          "is_classe": widget.activityType != "jams"
        },
      );
      selector = 'class_events';
    } else {
      queryOptions = QueryOptions(
        document: Queries.getClassEventsFromToLocationWithClass,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "from": from,
          "to": to,
          'latitude': place.latLng.latitude,
          'longitude': place.latLng.longitude,
          'distance': 100,
          "is_classe": widget.activityType != "jams"
        },
      );
      selector = 'class_events_by_location_v1';
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
            // ignore: avoid_print
            print(result.exception.toString());
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return IgnorePointer(
              ignoring: true,
              child: ActivityCalenderWidget(
                activiyType: widget.activityType,
                onPageChanged: (_) => {},
                classWeekEvents: const [],
                focusedDay: focusedDay,
                setFocusedDay: (_) => {},
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

          List<ClassEvent> classWeekEvents = [];

          try {
            if (result.data![selector] != null) {
              print(result.data![selector].length);
              classWeekEvents =
                  List<ClassEvent>.from(result.data![selector].map((json) {
                if (widget.activityType == "jams") {
                  print("json");
                  print(json["class"]["name"]);
                }

                return ClassEvent.fromJson(json);
              }));
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                activityProvider.setActiveClasses(classWeekEvents
                    .where((ClassEvent classEvent) =>
                        isSameDate(classEvent.date!, focusedDay))
                    .toList());
              });
            }
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

          return ActivityCalenderWidget(
            activiyType: widget.activityType,
            onPageChanged: onPageChanged,
            classWeekEvents: classWeekEvents,
            focusedDay: focusedDay,
            setFocusedDay: (newFocusedDay) => setState(() {
              focusedDay = newFocusedDay;
            }),
          );
        });
  }
}
