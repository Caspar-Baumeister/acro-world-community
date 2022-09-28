import 'package:acroworld/shared/helper_functions.dart';
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
      child: Row(
        children: const [
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
