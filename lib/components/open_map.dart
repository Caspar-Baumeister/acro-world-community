import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OpenMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double initialZoom;

  const OpenMap(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.initialZoom});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            initialZoom: initialZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none, // Disable all interactions
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(latitude, longitude),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ]),
          ],
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () => openMap(latitude, longitude),
            child: Container(
                color: Colors
                    .transparent), // Transparent container to capture the tap
          ),
        ),
      ],
    );
  }
}
