import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/components/map_app_bar.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/components/marker_component.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/components/new_area_component.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CustomMapComponent extends StatefulWidget {
  const CustomMapComponent({
    super.key,
    required this.initialLocation,
    required this.initialZoom,
  });

  final LatLng initialLocation;
  final double initialZoom;

  @override
  State<CustomMapComponent> createState() => _CustomMapComponentState();
}

class _CustomMapComponentState extends State<CustomMapComponent> {
  MapController mapController = MapController();
  bool isReady = false;
  LatLng? currentCenter;

  @override
  void initState() {
    super.initState();
    // add listener so that if the provider updates, the map updates
    Provider.of<PlaceProvider>(context, listen: false).addListener(() {
      mapController.move(
        Provider.of<PlaceProvider>(
          context,
          listen: false,
        ).locationSingelton.place.latLng,
        mapController.camera.zoom,
      );
    });
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
    MapEventsProvider mapEventProvider =
        Provider.of<MapEventsProvider>(context, listen: false);
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            onPositionChanged: (position, hasGesture) {
              //set controller to position
              if (position.center != null) {
                mapController.move(position.center!, mapController.camera.zoom);
                setState(() {
                  currentCenter = position.center;
                });
              }
            },
            onTap: (_, __) {
              mapEventProvider.setSelectedClassEvent(null);
            },
            initialCenter:
                mapEventProvider.place.latLng, // Initial center of the map
            initialZoom: widget.initialZoom,
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            // CurrentLocationLayer(),
            Consumer<MapEventsProvider>(
              builder: (context, mapEventsProvider, child) {
                return MarkerLayer(
                  markers: mapEventsProvider.classeEvents
                      .map((ClassEvent classEvent) {
                    return Marker(
                      width: AppDimensions.iconSizeLarge,
                      height: AppDimensions.iconSizeLarge,
                      point: LatLng(
                        classEvent.classModel!.location!.coordinates![1]
                            .toDouble(),
                        classEvent.classModel!.location!.coordinates![0]
                            .toDouble(),
                      ),
                      child: MarkerComponent(classEvent: classEvent),
                    );
                  }).toList(),
                );
              },
            )
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
                    ? Consumer<PlaceProvider>(
                        builder: (context, PlaceProvider placeProvider, child) {
                        return NewAreaComponent(
                          placeProvider: placeProvider,
                          center: currentCenter!,
                        );
                      })
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
