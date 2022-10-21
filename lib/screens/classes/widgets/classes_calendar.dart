import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/screens/classes/widgets/class_event_expanded_tile.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassesEventCalendar extends StatefulWidget {
  const ClassesEventCalendar({required this.kEvents, Key? key})
      : super(key: key);

  final Map<DateTime, List<ClassEvent>> kEvents;

  @override
  _ClassesEventCalendarState createState() => _ClassesEventCalendarState();
}

class _ClassesEventCalendarState extends State<ClassesEventCalendar> {
  late ValueNotifier<List<ClassEvent>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .disabled; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<ClassEvent> _getEventsForDay(DateTime day) {
    // Implementation

    return widget.kEvents[day] ?? [];
  }

  List<ClassEvent> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableCalendar<ClassEvent>(
          availableGestures: AvailableGestures.horizontalSwipe,

          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode:
              RangeSelectionMode.disabled, //_rangeSelectionMode,
          eventLoader: _getEventsForDay,
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
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder<List<ClassEvent>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: value.length,
              itemBuilder: (context, index) {
                print(value[index].toString());
                return ClassEventExpandedTile(classEvent: value[index]);

                // ClassEventParticipantQuery(
                //   classEvent: value[index],
                // );
              },
            );
          },
        )
      ],
    );
  }
}
