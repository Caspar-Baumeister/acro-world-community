import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/screens/single_class_page/widgets/class_event_participant_query.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassEventCalendar extends StatefulWidget {
  const ClassEventCalendar({required this.kEvents, Key? key}) : super(key: key);

  final Map<DateTime, List<ClassEvent>> kEvents;

  @override
  ClassEventCalendarState createState() => ClassEventCalendarState();
}

class ClassEventCalendarState extends State<ClassEventCalendar> {
  late ValueNotifier<List<ClassEvent>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
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
        const SizedBox(height: 8.0),
        ValueListenableBuilder<List<ClassEvent>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: value.length,
              itemBuilder: (context, index) {
                return ClassEventParticipantQuery(
                  classEvent: value[index],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
