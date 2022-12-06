import 'package:acroworld/components/place_button/place_button.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes_view.dart';
import 'package:acroworld/screens/home_screens/activities/components/jams_view.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivitiesBody extends StatefulWidget {
  const ActivitiesBody({Key? key}) : super(key: key);

  @override
  State<ActivitiesBody> createState() => _ActivitiesBodyState();
}

class _ActivitiesBodyState extends State<ActivitiesBody> {
  Place? place = PlacePreferences.getSavedPlace();
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  void _onDaySelected(DateTime _selectedDay, DateTime _focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        selectedDay = _selectedDay;
        focusedDay = _focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap everything by DefaultTabController length 2
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Column(
        children: [
          // Searchbar that sets the place as state and provider
          const SizedBox(height: 10),
          SizedBox(
            child: PlaceButton(
              initialPlace: place,
              onPlaceSet: (Place? _place) async {
                PlacePreferences.setSavedPlace(_place);
                setState(
                  () {
                    place = _place;
                  },
                );
              },
            ),
          ),

          // date chooser that sets the state date
          TableCalendar(
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
            onPageChanged: (_focusedDay) {
              setState(() {
                focusedDay = _focusedDay;
              });
            },
          ),
          // later: more option that sets the provider option and preferences for either search (different)
          const Divider(color: PRIMARY_COLOR),
          const TabBar(
            padding: EdgeInsets.only(bottom: 6, top: 4),
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Classes",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Jams",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          // flexible TabBarView that shows either the results of classes or jams
          Flexible(
            child: TabBarView(
              children: [
                // inside the tabbarview is the query with current state location and date)
                ClassesView(place: place, day: selectedDay),
                JamsView(place: place, day: selectedDay)
              ],
            ),
          )
        ],
      )),
    );
  }
}
