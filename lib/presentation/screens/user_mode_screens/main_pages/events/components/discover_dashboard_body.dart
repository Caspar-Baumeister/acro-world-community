import 'package:acroworld/presentation/components/sections/simple_event_slider_row.dart';
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

    // Debug information
    print('Discovery State Debug:');
    print('- Loading: ${discoveryState.loading}');
    print('- All Events: ${discoveryState.allEventOccurences.length}');
    print('- All Event Types: ${discoveryState.allEventTypes.length}');
    print('- Highlighted Events: ${discoveryState.getHighlightedEvents().length}');
    print('- Bookable Events: ${discoveryState.getBookableEvents().length}');

    // Simple test - just return a basic widget to see if the issue is with the provider
    return Container(
      color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TEST: Discovery Page is rendering!', style: TextStyle(fontSize: 20, color: Colors.white)),
            Text('Loading: ${discoveryState.loading}', style: TextStyle(color: Colors.white)),
            Text('Events: ${discoveryState.allEventOccurences.length}', style: TextStyle(color: Colors.white)),
            ElevatedButton(
              onPressed: () {
                ref.read(discoveryProvider.notifier).fetchAllEventOccurences();
              },
              child: Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }
}
