import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/communities_body/communities_list.dart';
import 'package:acroworld/screens/home/communities/communities_body/communities_search_bar.dart';
import 'package:acroworld/screens/home/communities/communities_body/new_community_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key, this.onLocationSelected}) : super(key: key);

  final Function(LatLng)? onLocationSelected;

  @override
  State<MapWidget> createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(52.5200, 13.4050);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add(LatLng center) {
    const MarkerId markerId = MarkerId('0');

    // creating a new MARKER
    final Marker marker = Marker(markerId: markerId, position: center);

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onLongPress(LatLng clickedLocation) {
    print(clickedLocation);
    _add(clickedLocation);
    widget.onLocationSelected!(clickedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      onLongPress: _onLongPress,
      markers: Set<Marker>.of(markers.values),
    );
  }
}
