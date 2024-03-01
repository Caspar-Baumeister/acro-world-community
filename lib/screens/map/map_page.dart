import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_event_expanded_tile.dart';
import 'package:acroworld/screens/map/components/custom_map_component.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlutterMapScreen extends StatefulWidget {
  const FlutterMapScreen({super.key});

  @override
  State<FlutterMapScreen> createState() => _FlutterMapScreenState();
}

class _FlutterMapScreenState extends State<FlutterMapScreen> {
  @override
  Widget build(BuildContext context) {
    MapEventsProvider mapEventProvider = Provider.of<MapEventsProvider>(
      context,
    );

    print("map screen build");
    print("place  ${mapEventProvider.place.description}");
    print(mapEventProvider.place.latLng);

    return Scaffold(
        body: Stack(
      children: [
        CustomMapComponent(
          initialLocation: mapEventProvider.place.latLng,
          initialZoom: 13,
        ),
        if (mapEventProvider.loading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        // The appbar

        if (mapEventProvider.selectedClassEvent != null)
          Positioned(
            bottom: 0,
            child: SafeArea(
              child: Container(
                color: CustomColors.backgroundColor,
                width:
                    MediaQuery.of(context).size.width - 2 * AppPaddings.medium,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPaddings.small),
                margin: const EdgeInsets.all(AppPaddings.medium),
                child: ClassEventExpandedTile(
                    classEvent: mapEventProvider.selectedClassEvent!),
              ),
            ),
          )
      ],
    ));
  }
}
