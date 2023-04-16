// import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/jams/new_jam_tile.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TableEventsCommunity extends StatefulWidget {
  const TableEventsCommunity(
      {required this.kEvents, Key? key, required this.cid})
      : super(key: key);

  final Map<DateTime, List<Jam>> kEvents;
  final String cid;

  @override
  _TableEventsCommunityState createState() => _TableEventsCommunityState();
}

class _TableEventsCommunityState extends State<TableEventsCommunity> {
  late ValueNotifier<List<Jam>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Jam> _getEventsForDay(DateTime day) {
    return widget.kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
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
        TableCalendar<Jam>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          rangeSelectionMode: RangeSelectionMode.disabled,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: const CalendarStyle(
            canMarkersOverflow: false,
            markersMaxCount: 100,
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
          ),
          onDaySelected: _onDaySelected,
          //onRangeSelected: _onRangeSelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: SingleChildScrollView(
            child: ValueListenableBuilder<List<Jam>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox(height: 55);
                    }
                    return NewJamTile(jam: value[index - 1]);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
