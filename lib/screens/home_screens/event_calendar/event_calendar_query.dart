import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/event/event_instance.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/home_screens/event_calendar/week_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class EventCalendarQuery extends StatefulWidget {
  const EventCalendarQuery({Key? key, required this.setFocusDayEvents})
      : super(key: key);
  // gets the input from classes/jams tabbar -> decides on "event_instance" and query

  final Function(List<EventInstance>) setFocusDayEvents;
  @override
  State<EventCalendarQuery> createState() => _EventCalendarQueryState();
}

class _EventCalendarQueryState extends State<EventCalendarQuery> {
  String from = DateTime.now().toIso8601String();
  late String to;
  DateTime focusedDay = DateTime.now();
  DateTime initialSelectedDate = DateTime.now();

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
    // QueryOptions queryOptions;
    // String selector;

    // TODO choose between place == null / not and call the with location and distance

    // if (place == null) {
    //   queryOptions = QueryOptions(
    //     document: Queries.getClassEventsFromToWithClass,
    //     fetchPolicy: FetchPolicy.networkOnly,
    //     variables: {
    //       "from": from,
    //       "to": to,
    //     },
    //   );
    //   selector = 'class_events';
    // } else {
    //   queryOptions = QueryOptions(
    //     document: Queries.getClassEventsFromToLocationWithClass,
    //     fetchPolicy: FetchPolicy.networkOnly,
    //     variables: {
    //       "from": from,
    //       "to": to,
    //       'latitude': place.latLng.latitude,
    //       'longitude': place.latLng.longitude,
    //       'distance': 100,
    //     },
    //   );
    //   selector = 'class_events_by_location_v1';
    // }

    // choose queryoption based on activityType

    // ActivityProvider activityProvider =
    //     Provider.of<ActivityProvider>(context, listen: false);

    return Query(
        options: QueryOptions(
          document: Queries.getEventsFromTo,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {
            "from": from,
            "to": to,
          },
        ),
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
              child: WeekCalenderWidget(
                  onPageChanged: (_) => {},
                  weekEvents: const [],
                  focusedDay: focusedDay,
                  setFocusedDay: (_) => {},
                  setFocusDayEvents: widget.setFocusDayEvents),
            );
          }

          List<EventInstance> weekEvents = [];

          try {
            if (result.data!["event_instance"] != null) {
              print(result.data!["event_instance"].length);
              weekEvents = List<EventInstance>.from(
                  result.data!["event_instance"].map((json) {
                return EventInstance.fromJson(json);
              }));

              // WidgetsBinding.instance.addPostFrameCallback((_) async {
              //   widget.setFocusDayEvents(weekEvents);
              // activityProvider.setActiveClasses(weekEvents
              //     .where((ClassEvent classEvent) =>
              //         isSameDate(classEvent.date!, focusedDay))
              //     .toList());
              // });
            }
          } catch (e) {
            print(e.toString());
          }

          try {
            weekEvents.sort((a, b) => DateTime.parse(b.startDate!)
                    .isBefore(DateTime.parse(a.startDate!))
                ? 1
                : 0);
          } catch (e) {
            print(e.toString());
          }

          return WeekCalenderWidget(
              onPageChanged: onPageChanged,
              weekEvents: weekEvents,
              focusedDay: focusedDay,
              setFocusedDay: (newFocusedDay) => setState(() {
                    focusedDay = newFocusedDay;
                  }),
              setFocusDayEvents: widget.setFocusDayEvents);
        });
  }
}
