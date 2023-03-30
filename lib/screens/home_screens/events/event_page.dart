import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/home_screens/events/event_dashboard.dart';
import 'package:acroworld/screens/home_screens/events/widgets/filter_bar.dart';
import 'package:acroworld/screens/home_screens/events/with_filter/filter_on_event_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: const FilterBar(),
        body: !eventFilterProvider.isFilterActive()
            ? const EventDashboardBody()
            : const FilterOnEventBody(),
      ),
    );
  }
}
