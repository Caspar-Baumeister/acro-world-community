import 'package:acroworld/screens/HOME_SCREENS/events/event_body.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        // appBar: AppBarEvents(),
        body: EventsBody(),
      ),
    );
  }
}
