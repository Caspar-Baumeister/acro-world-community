import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/provider/riverpod_provider/map_events_provider.dart';
import 'package:acroworld/provider/riverpod_provider/place_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class NewAreaComponent extends ConsumerWidget {
  const NewAreaComponent({
    super.key,
    required this.center,
  });

  final LatLng center;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlace = ref.watch(placeProvider);
    final placeNotifier = ref.read(placeProvider.notifier);

    if (currentPlace == null ||
        center.latitude != currentPlace.latLng.latitude ||
        center.longitude != currentPlace.latLng.longitude) {
      return Padding(
        padding: const EdgeInsets.only(top: AppDimensions.spacingSmall),
        child: SizedBox(
          width: 200,
          child: ModernButton(
              onPressed: () {
                placeNotifier.updatePlaceByLatLng(center);
                // update MapEventsProvider
                ref.read(mapEventsProvider.notifier).fetchClasseEvents();
              },
              isFilled: true,
              text: "Search in this area"),
        ),
      );
    } else {
      return Container();
    }
  }
}
