import 'dart:async';

import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/home_screens/activities/activity_calender_widget.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ActivitiesQuery extends StatefulWidget {
  const ActivitiesQuery({Key? key}) : super(key: key);
  // gets the input from classes/jams tabbar -> decides on selector and query

  @override
  State<ActivitiesQuery> createState() => _ActivitiesQueryState();
}

class _ActivitiesQueryState extends State<ActivitiesQuery> {
  late String from;
  late String to;
  DateTime focusedDay = DateTime.now();
  DateTime initialSelectedDate = DateTime.now();

  @override
  void initState() {
    DateTime now = DateTime.now();
    to = DateTime(now.year, now.month, now.day + (7 - now.weekday), 23)
        .toIso8601String();
    from = DateTime(now.year, now.month, now.day).toIso8601String();

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
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        variables: {
          "from": from,
          "to": to,
        },
      );
      selector = 'class_events';
    } else {
      queryOptions = QueryOptions(
        document: Queries.getClassEventsFromToLocationWithClass,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        variables: {
          "from": from,
          "to": to,
          'latitude': place.latLng.latitude,
          'longitude': place.latLng.longitude,
          'distance': 100,
        },
      );
      selector = 'class_events_by_location_v1';
    }

    // choose queryoption based on activityType

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

          List<ClassEvent> classWeekEvents = [];

          try {
            if (result.data![selector] != null) {
              print(result.data![selector].length);
              classWeekEvents =
                  List<ClassEvent>.from(result.data![selector].map((json) {
                return ClassEvent.fromJson(json);
              }));
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                activityProvider.setActiveClasses(classWeekEvents
                    .where((ClassEvent classEvent) =>
                        isSameDate(classEvent.startDateDT!, focusedDay))
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
