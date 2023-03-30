import 'package:acroworld/screens/home_screens/events/event_dashboard.dart';
import 'package:flutter/material.dart';

class EventsWithFilterPage extends StatelessWidget {
  const EventsWithFilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: EventDashboardBody(),
      ),
    );
  }
}
