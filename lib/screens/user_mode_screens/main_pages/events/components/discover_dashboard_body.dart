import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/events/components/slider_row_dashboard_discovery.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverDashboardBody extends StatefulWidget {
  const DiscoverDashboardBody({super.key});

  @override
  State<DiscoverDashboardBody> createState() => _DiscoverDashboardBodyState();
}

class _DiscoverDashboardBodyState extends State<DiscoverDashboardBody> {
  @override
  void initState() {
    super.initState();

    // add post frame callback to fetch all event occurences
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<DiscoveryProvider>(context, listen: false)
          .fetchAllEventOccurences();
    });
  }

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);

    List<Widget> eventSliders = discoveryProvider.allEventTypes
        .map((EventType eventType) => Padding(
              padding: const EdgeInsets.only(top: AppPaddings.small),
              child: SliderRowDashboardDiscovery(
                  onViewAll: () {
                    // set filter catergory to the event type
                    discoveryProvider.changeActiveCategory(eventType);
                  },
                  header: eventType.name,
                  events: discoveryProvider.getEventsByType(eventType)),
            ))
        .toList();

    return RefreshIndicator(
      onRefresh: () async => await discoveryProvider.fetchAllEventOccurences(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            discoveryProvider.getHighlightedEvents().isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: AppPaddings.small),
                    child: SliderRowDashboardDiscovery(
                        onViewAll: () {
                          discoveryProvider.setToOnlyHighlightedFilter();
                        },
                        header: 'Highlights',
                        events: discoveryProvider.getHighlightedEvents()))
                : Container(),
            discoveryProvider.getBookableEvents().isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: AppPaddings.small),
                    child: SliderRowDashboardDiscovery(
                        onViewAll: () {
                          discoveryProvider.setToOnlyBookableFilter();
                        },
                        header: 'Bookable Events',
                        subHeader: "Tickets available here!",
                        events: discoveryProvider.getBookableEvents()))
                : Container(),
            // Followed Teacher
            // for each event type in the discovery provider, create a slider row with the events
            ...eventSliders
          ],
        ),
      ),
    );
  }
}
