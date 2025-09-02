import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/slider_row_dashboard_discovery.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverDashboardBody extends ConsumerStatefulWidget {
  const DiscoverDashboardBody({super.key});

  @override
  ConsumerState<DiscoverDashboardBody> createState() => _DiscoverDashboardBodyState();
}

class _DiscoverDashboardBodyState extends ConsumerState<DiscoverDashboardBody> {
  @override
  void initState() {
    super.initState();

    // add post frame callback to fetch all event occurences
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(discoveryProvider.notifier).fetchAllEventOccurences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final discoveryState = ref.watch(discoveryProvider);

    List<Widget> eventSliders = discoveryState.allEventTypes
        .map((EventType eventType) => Padding(
              padding: const EdgeInsets.only(top: AppDimensions.spacingSmall),
              child: SliderRowDashboardDiscovery(
                  onViewAll: () {
                    // set filter catergory to the event type
                    ref.read(discoveryProvider.notifier).changeActiveCategory(eventType);
                  },
                  header: eventType.name,
                  events: discoveryState.getEventsByType(eventType)),
            ))
        .toList();

    return RefreshIndicator(
      onRefresh: () async => await ref.read(discoveryProvider.notifier).fetchAllEventOccurences(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            discoveryState.getHighlightedEvents().isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.spacingSmall),
                    child: SliderRowDashboardDiscovery(
                        onViewAll: () {
                          ref.read(discoveryProvider.notifier).setToOnlyHighlightedFilter();
                        },
                        header: 'Highlights',
                        events: discoveryState.getHighlightedEvents()))
                : Container(),
            discoveryState.getBookableEvents().isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.spacingSmall),
                    child: SliderRowDashboardDiscovery(
                        onViewAll: () {
                          ref.read(discoveryProvider.notifier).setToOnlyBookableFilter();
                        },
                        header: 'Bookable Events',
                        subHeader: "Tickets available here!",
                        events: discoveryState.getBookableEvents()))
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
