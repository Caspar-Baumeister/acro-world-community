import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

class OpenGoogleMaps extends StatelessWidget {
  const OpenGoogleMaps(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);
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
            color: Colors.black,
          ),
          Text("Google Maps"),
        ],
      ),
    );
  }
}
