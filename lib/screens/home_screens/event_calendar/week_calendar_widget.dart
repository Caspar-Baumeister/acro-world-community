import 'package:acroworld/models/event/event_instance.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class WeekCalenderWidget extends StatefulWidget {
  const WeekCalenderWidget({
    Key? key,
    required this.onPageChanged,
    required this.weekEvents,
    required this.focusedDay,
    required this.setFocusedDay,
    required this.setFocusDayEvents,
  }) : super(key: key);

  final Function(DateTime focusDay) onPageChanged;
  final Function(DateTime newFocusedDay) setFocusedDay;
  final Function(List<EventInstance>) setFocusDayEvents;

  final List<EventInstance> weekEvents;
  final DateTime focusedDay;

  @override
  State<WeekCalenderWidget> createState() => _WeekCalenderWidgetState();
}

class _WeekCalenderWidgetState extends State<WeekCalenderWidget> {
  void _onDaySelected(DateTime newSelectedDay) {
    // ActivityProvider activityProvider =
    //     Provider.of<ActivityProvider>(context, listen: false);
    // if another day thaen the current focus day is selected
    if (!isSameDate(newSelectedDay, widget.focusedDay)) {
      setState(() {});
      widget.setFocusedDay(laterDay(newSelectedDay, DateTime.now()));

      widget.setFocusDayEvents(widget.weekEvents
          .where((event) =>
              isSameDate(DateTime.parse(event.startDate!), newSelectedDay))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      availableGestures: AvailableGestures.horizontalSwipe,
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: widget.focusedDay,
      selectedDayPredicate: (day) => isSameDay(widget.focusedDay, day),
      calendarFormat: CalendarFormat.week,
      rangeSelectionMode: RangeSelectionMode.disabled,
      eventLoader: (day) => widget.weekEvents
          .where((event) => isSameDate(DateTime.parse(event.startDate!), day))
          .toList(),
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {CalendarFormat.week: 'week'},
      calendarStyle: CalendarStyle(
          canMarkersOverflow: false,
          markersMaxCount: 1,
          outsideDaysVisible: false,
          todayDecoration:
              BoxDecoration(color: Colors.grey[400]!, shape: BoxShape.circle),
          selectedDecoration: const BoxDecoration(
              color: PRIMARY_COLOR, shape: BoxShape.circle)),
      onDaySelected: (DateTime newSelectedDay, DateTime _) {
        _onDaySelected(newSelectedDay);
      },
      onPageChanged: (newFocusedDay) {
        DateTime monday = DateTime(newFocusedDay.year, newFocusedDay.month,
            newFocusedDay.day - newFocusedDay.weekday + 1);
        DateTime firstValidDayOfWeek = laterDay(monday, DateTime.now());
        _onDaySelected(firstValidDayOfWeek);
        widget.onPageChanged(firstValidDayOfWeek);
        widget.setFocusedDay(firstValidDayOfWeek);
      },
    );
  }
}
