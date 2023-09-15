import 'package:acroworld/screens/home_screens/event_calendar/event_calendar_body.dart';
import 'package:flutter/material.dart';

class EventCalendarPage extends StatelessWidget {
  const EventCalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: EventCalendarBody(),
      ),
    );
  }
}
