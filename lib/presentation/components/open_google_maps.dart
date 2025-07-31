import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

class OpenGoogleMaps extends StatelessWidget {
  const OpenGoogleMaps(
      {super.key, required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openMap(latitude, longitude),
      child: const Row(
        children: [
          Icon(
            Icons.location_on,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          Text("Google Maps"),
        ],
      ),
    );
  }
}
