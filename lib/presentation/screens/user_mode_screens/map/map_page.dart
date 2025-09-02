import 'package:acroworld/presentation/components/tiles/event_tiles/class_event_expanded_tile.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/components/custom_map_component.dart';
import 'package:acroworld/provider/riverpod_provider/map_events_provider.dart';
import 'package:acroworld/provider/riverpod_provider/place_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  @override
  Widget build(BuildContext context) {
    final currentPlace = ref.watch(placeProvider);
    final mapEventsState = ref.watch(mapEventsProvider);

    return Scaffold(
        body: Stack(
      children: [
        CustomMapComponent(
          initialLocation: currentPlace?.latLng ??
              const LatLng(52.5200, 13.4050), // Default Berlin location
          initialZoom: 13,
        ),
        if (mapEventsState.loading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading events...'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (mapEventsState.selectedClassEvent != null)
          Positioned(
            bottom: 0,
            child: SafeArea(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                width: MediaQuery.of(context).size.width -
                    2 * AppDimensions.spacingMedium,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingSmall),
                margin: const EdgeInsets.all(AppDimensions.spacingMedium),
                child: ClassEventExpandedTile(
                  classEvent: mapEventsState.selectedClassEvent!,
                  showFullDate: true,
                ),
              ),
            ),
          ),
      ],
    ));
  }
}
