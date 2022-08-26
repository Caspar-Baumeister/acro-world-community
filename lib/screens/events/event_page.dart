import 'package:acroworld/screens/events/event_body.dart';
import 'package:acroworld/screens/events/events_app_bar.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarEvents(),
      body: EventsBody(),
    );
  }
}
