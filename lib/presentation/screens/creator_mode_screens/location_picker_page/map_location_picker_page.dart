import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/presentation/components/search_bar_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/location_search_screen/place_search_body.dart';
import 'package:acroworld/services/location_search_service.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';

class MapLocationpickerPage extends StatefulWidget {
  const MapLocationpickerPage(
      {super.key, required this.onLocationSet, this.initialLocation});

  final Function(LatLng location, String? locationDescription) onLocationSet;
  final LatLng? initialLocation;

  @override
  State<MapLocationpickerPage> createState() => _MapLocationpickerPageState();
}

class _MapLocationpickerPageState extends State<MapLocationpickerPage> {
  late MapController mapController;
  late LatLng markerLocation;
  String query = '';

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    markerLocation = widget.initialLocation ?? LocationSingleton().place.latLng;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              onPositionChanged: (position, hasGesture) {
                //set controller to position
                mapController.move(position.center, mapController.camera.zoom);
              },
              interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
              onTap: (tapPosition, point) => {
                setState(() {
                  markerLocation = point;
                }),
                print("location changed to $point"),
                widget.onLocationSet(markerLocation, "custom location"),
                showSuccessToast("Set to custom location", isTop: false)
              },
              initialCenter: markerLocation,
              initialZoom: 13,
            ),
            children: <Widget>[
              TileLayer(
                userAgentPackageName: 'com.acroworld.app',
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: markerLocation,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ]),
              // CurrentLocationLayer(),
            ],
          ),
          Positioned(
            left: 0,
            top: 0,
            child: SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: AppDimensions.iconSizeLarge,
                          ),
                        ),
                        Flexible(
                          child: SearchBarWidget(
                            color: Theme.of(context).colorScheme.surface,
                            onChanged: (String value) {
                              setState(() {
                                query = value;
                              });
                            },
                          ),
                        ),
                        // const SetToUserLocationWidget(),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingMedium),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: SingleChildScrollView(
                        child: query.isNotEmpty
                            ? PlacesQuery(
                                query: query,
                                onPlaceIdSet: _onPlaceSet,
                                selector: "search_by_input_text",
                                queryOptions: QueryOptions(
                                    document: Queries.getPlacesIds,
                                    fetchPolicy: FetchPolicy.networkOnly,
                                    variables: {'query': query}),
                              )
                            : Container(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onPlaceSet(String placeId, {String? description}) async {
    Map<String, dynamic>? place =
        await LocationSearchService().getPlaceFromId(placeId);

    if (place != null &&
        place["latitude"] != null &&
        place["longitude"] != null) {
      setState(() {
        markerLocation = LatLng(place["latitude"], place["longitude"]);
      });
      mapController.move(markerLocation, 13);
      setState(() {
        query = '';
      });
      widget.onLocationSet(
          markerLocation, description ?? place["description"] ?? '');
    }
  }
}
