import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/provider/riverpod_provider/map_events_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkerComponent extends ConsumerWidget {
  final ClassEvent classEvent;
  const MarkerComponent({super.key, required this.classEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapEventsState = ref.watch(mapEventsProvider);
    final mapEventsNotifier = ref.read(mapEventsProvider.notifier);

    return InkWell(
      onTap: () {
        // set the selected classEvent
        mapEventsNotifier.setSelectedClassEvent(classEvent);
      },
      child: Icon(Icons.location_on,
          color: Theme.of(context).colorScheme.onSurface,
          size: AppDimensions.iconSizeLarge),
    );
  }
}
