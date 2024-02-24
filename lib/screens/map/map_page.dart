import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/provider/class_event_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_event_expanded_tile.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class FlutterMapScreen extends StatefulWidget {
  const FlutterMapScreen(
      {super.key, this.initialLocation = const LatLng(52.5200, 13.4050)});

  final LatLng? initialLocation;

  @override
  State<FlutterMapScreen> createState() => _FlutterMapScreenState();
}

class _FlutterMapScreenState extends State<FlutterMapScreen> {
  MapController mapController = MapController();
  LatLng? cameraPosition;
  LatLng? currentCenter;

  @override
  void initState() {
    super.initState();
    cameraPosition = widget.initialLocation;
    currentCenter = widget.initialLocation;
  }

  void _zoomIn() {
    mapController.move(mapController.camera.center, mapController.zoom + 1);
  }

  void _zoomOut() {
    mapController.move(mapController.camera.center, mapController.zoom - 1);
  }

  Widget _zoomControls() {
    return Column(
      children: [
        FloatingActionButton(
          mini: true,
          onPressed: _zoomIn,
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 20),
        FloatingActionButton(
          mini: true,
          onPressed: _zoomOut,
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // classevent provider
    ClassEventProvider classEventProvider =
        Provider.of<ClassEventProvider>(context);

    return Scaffold(
      // floatingActionButton in the top right corner
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.backgroundColor,
        onPressed: () {
          // set the selected classEvent to null
          classEventProvider.setSelectedClassEvent(null);
        },
        child: const Icon(
          Icons.close,
          color: CustomColors.iconColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,

      body: currentCenter != null
          ? Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    onPositionChanged: (position, hasGesture) {
                      print("position: $position");
                      setState(() {
                        cameraPosition = position.center;
                      });

                      print("cameraPosition: $cameraPosition");
                      print("currentCenter: $currentCenter");
                    },
                    onTap: (_, __) {
                      classEventProvider.setSelectedClassEvent(null);
                    },
                    initialCenter: currentCenter!, // Initial center of the map
                    initialZoom: 10.0,
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    // CurrentLocationLayer(),
                    MarkerLayer(
                        markers: classEventProvider.classeEvents
                            .map((ClassEvent classEvent) {
                      return Marker(
                          width: AppSizes.iconSizeLarge,
                          height: AppSizes.iconSizeLarge,
                          point: LatLng(
                              classEvent.classModel!.location!.coordinates![1]
                                  .toDouble(),
                              classEvent.classModel!.location!.coordinates![0]
                                  .toDouble()),
                          child: MarkerComponent(classEvent: classEvent));
                    }).toList())
                  ],
                ),
                // in the center a loading indicator if provider.loading is true
                if (classEventProvider.loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                // if the current map position is defferent from the classEventProvider.location show a button to search from new position
                if (cameraPosition?.latitude != currentCenter?.latitude ||
                    cameraPosition?.longitude != currentCenter?.longitude)
                  Positioned(
                    top: 50,
                    right: 80,
                    left: 80,
                    child: FloatingActionButton(
                      onPressed: () {
                        classEventProvider.location = cameraPosition!;
                        classEventProvider.fetchClasseEvents();
                        setState(() {
                          currentCenter = cameraPosition;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Search in this area",
                              style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(
                            width: AppPaddings.medium,
                          ),
                          const Icon(
                            Icons.search,
                            color: CustomColors.iconColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  right: 10,
                  top: MediaQuery.of(context).size.height / 2 -
                      60, // Adjust based on your preference
                  child: _zoomControls(),
                ),
                if (classEventProvider.selectedClassEvent != null)
                  Positioned(
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
                            classEvent: classEventProvider.selectedClassEvent!),
                      ),
                    ),
                  )
              ],
            )
          : const LoadingPage(),
    );
  }
}

class MarkerComponent extends StatelessWidget {
  final ClassEvent classEvent;
  const MarkerComponent({super.key, required this.classEvent});

  @override
  Widget build(BuildContext context) {
    // define the classEventProvider with listen true
    ClassEventProvider classEventProvider =
        Provider.of<ClassEventProvider>(context, listen: true);
    return InkWell(
      onTap: () {
        // set the selected classEvent
        classEventProvider.setSelectedClassEvent(classEvent);
      },
      child: Icon(Icons.location_on,
          color: classEventProvider.selectedClassEvent?.id == classEvent.id
              ? CustomColors.accentColor
              : CustomColors.iconColor,
          size: AppSizes.iconSizeLarge),
    );
  }
}
