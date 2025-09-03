import 'package:acroworld/presentation/components/sections/responsive_event_section.dart';
import 'package:acroworld/presentation/components/sections/responsive_event_list.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverDashboardBody extends ConsumerStatefulWidget {
  const DiscoverDashboardBody({super.key});

  @override
  ConsumerState<DiscoverDashboardBody> createState() =>
      _DiscoverDashboardBodyState();
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

    // Debug information
    print('Discovery State Debug:');
    print('- Loading: ${discoveryState.loading}');
    print('- All Events: ${discoveryState.allEventOccurences.length}');
    print('- All Event Types: ${discoveryState.allEventTypes.length}');
    print(
        '- Highlighted Events: ${discoveryState.getHighlightedEvents().length}');
    print('- Bookable Events: ${discoveryState.getBookableEvents().length}');

    // Build event sections for each event type
    List<Widget> eventSections = discoveryState.allEventTypes
        .map((EventType eventType) => ResponsiveEventSection(
              title: eventType.name,
              events: discoveryState.getEventsByType(eventType)
                  .map((event) => EventCardData.fromClassEvent(event))
                  .toList(),
              onViewAll: () {
                ref
                    .read(discoveryProvider.notifier)
                    .changeActiveCategory(eventType);
              },
            ))
        .toList();

    return RefreshIndicator(
      onRefresh: () async =>
          await ref.read(discoveryProvider.notifier).fetchAllEventOccurences(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show highlighted events if available
            if (discoveryState.getHighlightedEvents().isNotEmpty)
              ResponsiveEventSection(
                title: 'Highlights',
                events: discoveryState.getHighlightedEvents()
                    .map((event) => EventCardData.fromClassEvent(event))
                    .toList(),
                onViewAll: () {
                  ref
                      .read(discoveryProvider.notifier)
                      .setToOnlyHighlightedFilter();
                },
              ),
            // Show bookable events if available
            if (discoveryState.getBookableEvents().isNotEmpty)
              ResponsiveEventSection(
                title: 'Bookable Events',
                subtitle: "Tickets available here!",
                events: discoveryState.getBookableEvents()
                    .map((event) => EventCardData.fromClassEvent(event))
                    .toList(),
                onViewAll: () {
                  ref
                      .read(discoveryProvider.notifier)
                      .setToOnlyBookableFilter();
                },
              ),
            // Show all event type sections
            ...eventSections,
            // Show message if no events at all
            if (discoveryState.allEventOccurences.isEmpty &&
                !discoveryState.loading)
              Container(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('No events found',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Try refreshing or check your connection'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
