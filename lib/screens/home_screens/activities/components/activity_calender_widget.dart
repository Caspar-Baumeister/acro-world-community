import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';

class ActivityCalenderWidget extends StatefulWidget {
  const ActivityCalenderWidget({
    Key? key,
    required this.onPageChanged,
    required this.classWeekEvents,
    required this.focusedDay,
    required this.setFocusedDay,
    required this.jamWeekEvents,
    required this.activiyType,
    required this.initialSelectedDate,
    required this.setInitialSelectedDate,
  }) : super(key: key);

  final Function(DateTime focusDay) onPageChanged;
  final Function(DateTime newFocusedDay) setFocusedDay;
  final Function(DateTime newFocusedDay) setInitialSelectedDate;

  final List<ClassEvent> classWeekEvents;
  final List<Jam> jamWeekEvents;
  final String activiyType;
  final DateTime initialSelectedDate;
  final DateTime focusedDay;

  @override
  State<ActivityCalenderWidget> createState() => _ActivityCalenderWidgetState();
}

class _ActivityCalenderWidgetState extends State<ActivityCalenderWidget> {
  late DateTime selectedDay;

  @override
  void initState() {
    selectedDay = widget.initialSelectedDate;
    super.initState();
  }

  void _onDaySelected(DateTime newSelectedDay, DateTime _) {
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    if (!isSameDate(newSelectedDay, selectedDay)) {
      setState(() {
        selectedDay = newSelectedDay;
      });
      widget.setFocusedDay(laterDay(newSelectedDay, DateTime.now()));

      if (widget.activiyType == "classes") {
        activityProvider.setActiveClasses(widget.classWeekEvents
            .where((classEvent) => isSameDate(classEvent.date, newSelectedDay))
            .toList());
      } else {
        activityProvider.setActiveJams(widget.jamWeekEvents
            .where((jam) => isSameDate(jam.dateAsDateTime!, newSelectedDay))
            .toList());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      availableGestures: AvailableGestures.horizontalSwipe,
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: widget.focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      calendarFormat: CalendarFormat.week,
      rangeSelectionMode: RangeSelectionMode.disabled,
      eventLoader: (day) => widget.activiyType == "jams"
          ? widget.jamWeekEvents
              .where((jam) => isSameDate(jam.dateAsDateTime!, day))
              .toList()
          : widget.classWeekEvents
              .where((classEvent) => isSameDate(classEvent.date, day))
              .toList(),
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {CalendarFormat.week: 'week'},
      calendarStyle: CalendarStyle(
          canMarkersOverflow: false,
          markersMaxCount: 5,
          outsideDaysVisible: false,
          todayDecoration:
              BoxDecoration(color: Colors.grey[400]!, shape: BoxShape.circle),
          selectedDecoration: const BoxDecoration(
              color: PRIMARY_COLOR, shape: BoxShape.circle)),
      onDaySelected: (DateTime newSelectedDay, DateTime newFocusedDay) {
        _onDaySelected(newSelectedDay, newFocusedDay);
      },
      onPageChanged: (newFocusedDay) {
        widget.onPageChanged(newFocusedDay);
        widget.setFocusedDay(newFocusedDay);

        DateTime monday = DateTime(newFocusedDay.year, newFocusedDay.month,
            newFocusedDay.day - newFocusedDay.weekday + 1);
        _onDaySelected(monday, newFocusedDay);
        widget.setInitialSelectedDate(monday);
      },
    );
  }
}
