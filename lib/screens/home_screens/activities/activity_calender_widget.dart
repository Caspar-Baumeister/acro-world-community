import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityCalenderWidget extends StatefulWidget {
  const ActivityCalenderWidget({
    super.key,
    required this.onPageChanged,
    required this.classWeekEvents,
    required this.focusedDay,
    required this.setFocusedDay,
  });

  final Function(DateTime focusDay) onPageChanged;
  final Function(DateTime newFocusedDay) setFocusedDay;

  final List<ClassEvent> classWeekEvents;
  final DateTime focusedDay;

  @override
  State<ActivityCalenderWidget> createState() => _ActivityCalenderWidgetState();
}

class _ActivityCalenderWidgetState extends State<ActivityCalenderWidget> {
  void _onDaySelected(DateTime newSelectedDay) {
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    // if another day thaen the current focus day is selected
    if (!isSameDate(newSelectedDay, widget.focusedDay)) {
      setState(() {});
      widget.setFocusedDay(laterDay(newSelectedDay, DateTime.now()));

      activityProvider.setActiveClasses(widget.classWeekEvents
          .where((classEvent) =>
              isSameDate(classEvent.startDateDT, newSelectedDay))
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
      eventLoader: (day) => widget.classWeekEvents
          .where((classEvent) => isSameDate(classEvent.startDateDT, day))
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
