import 'package:acroworld/provider/riverpod_provider/calendar_provider.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarComponent extends ConsumerWidget {
  const CalendarComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    return IgnorePointer(
      ignoring: calendarState.loading,
      child: TableCalendar(
        availableGestures: AvailableGestures.horizontalSwipe,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: calendarState.focusedDay ?? DateTime.now(),
        selectedDayPredicate: (day) =>
            isSameDay(calendarState.focusedDay, day),
        calendarFormat: CalendarFormat.week,
        rangeSelectionMode: RangeSelectionMode.disabled,
        eventLoader: (day) => calendarState.weekClassEvents.where((event) => 
            isSameDay(event.startDateDT, day)).toList(),
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {CalendarFormat.week: 'week'},
        calendarStyle: CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle)),
        onDaySelected: (DateTime newSelectedDay, DateTime _) {
          ref.read(calendarProvider.notifier).setFocusedDay(newSelectedDay);
        },
        onPageChanged: (newFocusedDay) {
          ref.read(calendarProvider.notifier).setFocusedDay(newFocusedDay);
        },
      ),
    );
  }
}
