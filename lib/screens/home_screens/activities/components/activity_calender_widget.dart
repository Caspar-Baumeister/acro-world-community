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
  }) : super(key: key);

  final Function(DateTime focusDay) onPageChanged;
  final Function(DateTime newFocusedDay) setFocusedDay;

  final List<NewClassEventsModel> classWeekEvents;
  final List<Jam> jamWeekEvents;
  final String activiyType;

  final DateTime focusedDay;

  @override
  State<ActivityCalenderWidget> createState() => _ActivityCalenderWidgetState();
}

class _ActivityCalenderWidgetState extends State<ActivityCalenderWidget> {
  DateTime selectedDay = DateTime.now();

  void _onDaySelected(DateTime newSelectedDay, DateTime newFocusedDay) {
    if (!isSameDay(newSelectedDay, selectedDay)) {
      setState(() {
        selectedDay = newSelectedDay;
      });
      widget.setFocusedDay(newFocusedDay);
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
          markersMaxCount: 100,
          outsideDaysVisible: false,
          todayDecoration:
              BoxDecoration(color: Colors.grey[400]!, shape: BoxShape.circle),
          selectedDecoration: const BoxDecoration(
              color: PRIMARY_COLOR, shape: BoxShape.circle)),
      onDaySelected: (DateTime newSelectedDay, DateTime newFocusedDay) {
        _onDaySelected(newSelectedDay, newFocusedDay);
        // Provider.of<ActivityProvider>(context, listen: false).setWeekEvents()
        if (widget.activiyType == "classes") {
          Provider.of<ActivityProvider>(context, listen: false)
                  .activeClasseEvents =
              widget.classWeekEvents
                  .where((classEvent) =>
                      isSameDate(classEvent.date, newSelectedDay))
                  .toList();
          Provider.of<ActivityProvider>(context, listen: false)
              .notifyListeners();
        } else {
          Provider.of<ActivityProvider>(context, listen: false).activeJams =
              widget.jamWeekEvents
                  .where(
                      (jam) => isSameDate(jam.dateAsDateTime!, newSelectedDay))
                  .toList();
          Provider.of<ActivityProvider>(context, listen: false)
              .notifyListeners();
        }
      },
      onPageChanged: (newFocusedDay) {
        widget.onPageChanged(newFocusedDay);
        widget.setFocusedDay(newFocusedDay);
      },
    );
  }
}
