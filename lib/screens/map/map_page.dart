import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/main_pages/activities/components/classes/class_event_expanded_tile.dart';
import 'package:acroworld/screens/map/components/custom_map_component.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Consumer<PlaceProvider>(
          builder: (context, placeProvider, child) {
            return CustomMapComponent(
              initialLocation: placeProvider.locationSingelton.place.latLng,
              initialZoom: 13,
            );
          },
        ),
        Consumer<MapEventsProvider>(
          builder: (context, mapEventProvider, child) {
            if (mapEventProvider.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
        ),
        Consumer<MapEventsProvider>(
          builder: (context, mapEventProvider, child) {
            if (mapEventProvider.selectedClassEvent != null) {
              return Positioned(
                bottom: 0,
                child: SafeArea(
                  child: Container(
                    color: CustomColors.backgroundColor,
                    width: MediaQuery.of(context).size.width -
                        2 * AppPaddings.medium,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppPaddings.small),
                    margin: const EdgeInsets.all(AppPaddings.medium),
                    child: ClassEventExpandedTile(
                      classEvent: mapEventProvider.selectedClassEvent!,
                      showFullDate: true,
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        )
      ],
    ));
  }
}
