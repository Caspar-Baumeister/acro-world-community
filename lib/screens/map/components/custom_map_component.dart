import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/screens/map/components/marker_component.dart';
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

  @override
  void initState() {
    super.initState();
    // add listener so that if the provider updates, the map updates
    Provider.of<MapEventsProvider>(context, listen: false).addListener(() {
      mapController.move(
        Provider.of<MapEventsProvider>(
          context,
          listen: false,
        ).place.latLng,
        mapController.camera.zoom,
      );
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    Provider.of<MapEventsProvider>(context, listen: false)
        .removeListener(() {});
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
            onPositionChanged: (position, hasGesture) {
              //set controller to position
              if (position.center != null) {
                mapController.move(position.center!, mapController.camera.zoom);
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
                      width: AppSizes.iconSizeLarge,
                      height: AppSizes.iconSizeLarge,
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
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   top: 0,
        //   child: SafeArea(
        //     child: Column(
        //       children: [
        //         const MapAppBar(),
        //         NewAreaComponent(
        //           mapEventProvider: mapEventProvider,
        //           center: mapController.camera.center,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

// class NewAreaComponent extends StatelessWidget {
//   const NewAreaComponent({
//     super.key,
//     required this.mapEventProvider,
//     required this.center,
//   });

//   final MapEventsProvider mapEventProvider;
//   final LatLng center;
//   final bool isReady;

//   @override
//   Widget build(BuildContext context) {
//     print("center $center");
//     print("is ready $isReady");
//     if (center.latitude != mapEventProvider.place.latLng.latitude ||
//         center.longitude != mapEventProvider.place.latLng.longitude) {
//       return Padding(
//         padding: const EdgeInsets.only(top: AppPaddings.small),
//         child: SizedBox(
//           width: 200,
//           child: StandardButtonSmall(
//               onPressed: () {
//                 mapEventProvider.setPlaceToMapArea(center);
//               },
//               isFilled: true,
//               text: "Search in this area"),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
// }
