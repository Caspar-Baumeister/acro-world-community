import 'package:acroworld/presentation/components/sections/simple_event_slider_row.dart';
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

    // Build event sliders for each event type
    List<Widget> eventSliders = discoveryState.allEventTypes
        .map((EventType eventType) => Padding(
              padding: const EdgeInsets.only(top: AppDimensions.spacingSmall),
              child: SimpleEventSliderRow(
                title: eventType.name,
                events: discoveryState.getEventsByType(eventType),
                onViewAll: () {
                  ref.read(discoveryProvider.notifier).changeActiveCategory(eventType);
                },
              ),
            ))
        .toList();

    return RefreshIndicator(
      onRefresh: () async => await ref.read(discoveryProvider.notifier).fetchAllEventOccurences(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple test - just show basic info first
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Events Found:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Total Events: ${discoveryState.allEventOccurences.length}'),
                  Text('Event Types: ${discoveryState.allEventTypes.length}'),
                  Text('Highlighted: ${discoveryState.getHighlightedEvents().length}'),
                  Text('Bookable: ${discoveryState.getBookableEvents().length}'),
                  const SizedBox(height: 16),
                  Text('Event Types:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...discoveryState.allEventTypes.map((type) => Text('- ${type.name} (${discoveryState.getEventsByType(type).length} events)')),
                ],
              ),
            ),
            // Show a simple list of events for testing
            if (discoveryState.allEventOccurences.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('First 5 Events:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ...discoveryState.allEventOccurences.take(5).map((event) => 
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('${event.classModel?.name ?? "Unknown"} - ${event.classModel?.city ?? "No city"}'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
