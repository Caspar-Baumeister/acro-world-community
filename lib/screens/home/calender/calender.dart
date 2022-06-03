// before this screen there has to be another widgets that pulls the data from the database
// here i pretend the data ist there
// data: all jams from the user with time from all usercommunities

import 'package:acroworld/data.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/calender/app_bar_calendar.dart';
import 'package:acroworld/screens/home/calender/calender_body.dart';
import 'package:acroworld/screens/home/calender/future_calender_jams.dart';
import 'package:flutter/material.dart';

class Calender extends StatelessWidget {
  const Calender({Key? key}) : super(key: key);

  //final List<Jam> userJams = DataClass().jams;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarCalendar(),
      body: FutureCalenderJams(),
    );
  }
}
