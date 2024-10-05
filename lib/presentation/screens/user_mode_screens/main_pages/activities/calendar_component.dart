import 'package:acroworld/provider/calendar_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarComponent extends StatelessWidget {
  const CalendarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarProvider calendarProvider = Provider.of<CalendarProvider>(context);
    return IgnorePointer(
      ignoring: calendarProvider.loading,
      child: TableCalendar(
        availableGestures: AvailableGestures.horizontalSwipe,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: calendarProvider.focusedDay,
        selectedDayPredicate: (day) =>
            isSameDay(calendarProvider.focusedDay, day),
        calendarFormat: CalendarFormat.week,
        rangeSelectionMode: RangeSelectionMode.disabled,
        eventLoader: (day) => calendarProvider.getClassEventsForDay(day),
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {CalendarFormat.week: 'week'},
        calendarStyle: CalendarStyle(
            canMarkersOverflow: false,
            markersMaxCount: 1,
            outsideDaysVisible: false,
            todayDecoration:
                BoxDecoration(color: Colors.grey[400]!, shape: BoxShape.circle),
            selectedDecoration: const BoxDecoration(
                color: CustomColors.primaryColor, shape: BoxShape.circle)),
        onDaySelected: (DateTime newSelectedDay, DateTime _) {
          calendarProvider.setFocusedDay(newSelectedDay);
        },
        onPageChanged: (newFocusedDay) {
          calendarProvider.onPageChanged(newFocusedDay);
        },
      ),
    );
  }
}
