import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/components/map_app_bar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/components/marker_component.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/components/new_area_component.dart';
import 'package:acroworld/provider/riverpod_provider/map_events_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class CustomMapComponent extends ConsumerStatefulWidget {
  const CustomMapComponent({
    super.key,
    required this.initialLocation,
    required this.initialZoom,
  });

  final LatLng initialLocation;
  final double initialZoom;

  @override
  ConsumerState<CustomMapComponent> createState() => _CustomMapComponentState();
}

class _CustomMapComponentState extends ConsumerState<CustomMapComponent> {
  MapController mapController = MapController();
  bool isReady = false;
  LatLng? currentCenter;

  @override
  void initState() {
    super.initState();
    // Map will update automatically when placeProvider changes via ref.watch
    // set isReady to true after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isReady = true;
      });
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapEventsState = ref.watch(mapEventsProvider);
    final mapEventsNotifier = ref.read(mapEventsProvider.notifier);

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
            onPositionChanged: (position, hasGesture) {
              //set controller to position
              mapController.move(position.center, mapController.camera.zoom);
              setState(() {
                currentCenter = position.center;
              });
            },
            onTap: (_, __) {
              mapEventsNotifier.setSelectedClassEvent(null);
            },
            initialCenter: widget.initialLocation, // Initial center of the map
            initialZoom: widget.initialZoom,
          ),
          children: <Widget>[
            TileLayer(
              userAgentPackageName: 'com.acroworld.app',
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            // CurrentLocationLayer(),
            MarkerLayer(
              markers: mapEventsState.classeEvents
                  .where((classEvent) =>
                      classEvent.classModel?.location?.coordinates != null)
                  .map((ClassEvent classEvent) {
                final coordinates =
                    classEvent.classModel!.location!.coordinates!;
                return Marker(
                  point: LatLng(
                      coordinates[1].toDouble(), coordinates[0].toDouble()),
                  child: MarkerComponent(classEvent: classEvent),
                );
              }).toList(),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: SafeArea(
            child: Column(
              children: [
                const MapAppBar(),
                isReady && currentCenter != null
                    ? NewAreaComponent(center: currentCenter!)
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
