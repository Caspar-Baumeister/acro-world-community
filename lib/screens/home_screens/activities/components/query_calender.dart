import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';

import 'package:table_calendar/table_calendar.dart';

class QueryCalender extends StatefulWidget {
  const QueryCalender({Key? key, required this.activityType}) : super(key: key);
  // gets the input from classes/jams tabbar -> decides on selector and query
  final String activityType;

  @override
  State<QueryCalender> createState() => _QueryCalenderState();
}

class _QueryCalenderState extends State<QueryCalender> {
  String from = DateTime.now().toIso8601String();
  late String to;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  void _onDaySelected(DateTime newSelectedDay, DateTime newFocusedDay) {
    if (!isSameDay(newSelectedDay, selectedDay)) {
      setState(() {
        selectedDay = newSelectedDay;
        focusedDay = newFocusedDay;
      });
    }
    // widget.onDaySelected(newSelectedDay);
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
    // gets the input from location
    // locationprovider listening

    QueryOptions queryOptions;
    String selector;
    if (widget.activityType == "jams") {
      queryOptions = QueryOptions(
        document: Queries.jamsFromTo,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"from": from, "to": to},
      );
      selector = 'jams';
    } else {
      // if (place == null) {
      queryOptions = QueryOptions(
        document: Queries.getClassEventsFromToWithClass,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"from": from, "to": to},
      );
      selector = 'class_events';
      // } else {
      //   queryOptions = QueryOptions(
      //     document: Queries.getClassesByLocation,
      //     variables: {
      //       'latitude': place!.latLng.latitude,
      //       'longitude': place!.latLng.longitude,
      //       "from": from,
      //       "to": to
      //     },
      //     fetchPolicy: FetchPolicy.networkOnly,
      //   );
      //   selector = 'classes_by_location_v1';
      // }
    }
    // choose queryoption based on activityType
    return Query(
        options: queryOptions,
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(child: LoadingWidget());
          }

          Future<void> runRefetch() async {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
            }
          }

          List<NewClassEventsModel>? classEvents;
          try {
            classEvents = List<NewClassEventsModel>.from(result.data![selector]
                .map((json) => NewClassEventsModel.fromJson(json)));
          } catch (e) {
            print(e.toString());
          }

          if (classEvents == null) {
            return Container();
          }

          try {
            classEvents.sort((a, b) => DateTime.parse(b.startDate!)
                    .isBefore(DateTime.parse(a.startDate!))
                ? 1
                : 0);
          } catch (e) {
            print(e.toString());
          }
          // if (result.data!.keys.contains(selector) &&
          //     result.data![selector] != null) {
          //   result.data![selector].forEach((clas) {
          //     // classes.add(ClassModel.fromJson(clas));
          //     if (clas["class_events"] != null &&
          //         clas["class_events"].isNotEmpty) {
          //       clas["class_events"].forEach((element) {
          //         List? teacherList;
          //         if (clas["class_teachers"] != null &&
          //             clas["class_teachers"].isNotEmpty) {
          //           teacherList = clas["class_teachers"];
          //         }
          //         if (clas["teacher"] != null && clas["teacher"].isNotEmpty) {
          //           teacherList = clas["teacher"];
          //         }
          //         ClassEvent classEvent = ClassEvent.fromJson(element,
          //             classModel: ClassModel.fromJson(clas),
          //             teacherList: teacherList);

          //         if (isSameDate(classEvent.date, day)) {
          //           classEvents.add(classEvent);
          //         }
          //       });
          //     }
          //   });
          // }

          return TableCalendar(
            availableGestures: AvailableGestures.horizontalSwipe,

            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),

            calendarFormat: CalendarFormat.week,
            rangeSelectionMode:
                RangeSelectionMode.disabled, //_rangeSelectionMode,
            eventLoader: (day) {
              return [];
            },
            startingDayOfWeek: StartingDayOfWeek.monday,

            availableCalendarFormats: const {CalendarFormat.week: 'week'},
            calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                    color: Colors.grey[400]!, shape: BoxShape.circle),
                selectedDecoration: const BoxDecoration(
                    color: PRIMARY_COLOR, shape: BoxShape.circle)),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusDay) => setState(() {
              from = focusDay.toIso8601String();
              to = DateTime(focusDay.year, focusDay.month,
                      focusDay.day + (7 - focusDay.weekday))
                  .toIso8601String();
              focusedDay = focusDay;
            }),
          );
        });
  }
}




// sets its own input for the week

// -> state from / to / activeDay

// querys all the data for the week

// if click on day -> safes activeClasses / activeJams to provider

