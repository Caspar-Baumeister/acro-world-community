import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/home_screens/events/event_dashboard.dart';
import 'package:acroworld/screens/home_screens/events/event_init_query.dart';
import 'package:acroworld/screens/home_screens/events/widgets/filter_bar.dart';
import 'package:acroworld/screens/home_screens/events/with_filter/filter_on_event_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const FilterBar(),
        body: Consumer<EventFilterProvider>(
          builder: (context, eventFilterProvider, child) =>
              _buildEventBody(eventFilterProvider),
        ),
      ),
    );
  }

  Widget _buildEventBody(EventFilterProvider provider) {
    if (!provider.initialized) {
      return const EventsInitializerQuery();
    } else if (!provider.isFilterActive()) {
      return const EventDashboardBody();
    } else {
      return const FilterOnEventBody();
    }
  }
}
