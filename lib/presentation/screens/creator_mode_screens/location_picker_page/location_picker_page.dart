// import 'package:acroworld/screens/base_page.dart';
// import 'package:acroworld/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:latlong2/latlong.dart';

// class LocationPickerPage extends StatefulWidget {
//   const LocationPickerPage({super.key});

//   @override
//   _LocationPickerPageState createState() => _LocationPickerPageState();
// }

// class _LocationPickerPageState extends State<LocationPickerPage> {
//   final TextEditingController _controller = TextEditingController();
//   final MapController _mapController = MapController();

//   LatLng _initialLocation =
//       const LatLng(51.5, -0.09); // Default location (London)

//   void _searchLocation() async {
//     if (_controller.text.isNotEmpty) {
//       try {
//         List<Location> locations = await locationFromAddress(_controller.text);
//         if (locations.isNotEmpty) {
//           final newLocation =
//               LatLng(locations[0].latitude, locations[0].longitude);
//           _mapController.move(newLocation, 15.0);
//           setState(() {
//             _initialLocation = newLocation;
//           });
//         } else {
//           // Show an error message if no locations are found
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text('No location found for the provided address.')),
//           );
//         }
//       } catch (e) {
//         // Handle any other errors (e.g., network issues)
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to find location: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BasePage(
//       makeScrollable: false,
//       child: Column(
//         children: [
//           // SearchBarWidget(
//           //   onChanged: (String value) {
//           //     setState(() {
//           //       query = value;
//           //     });
//           //   },
//           // ),
//           const SizedBox(height: AppPaddings.large),
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 initialCenter: _initialLocation,
//                 interactionOptions: const InteractionOptions(
//                   flags: InteractiveFlag.none, // Disable all interactions
//                 ),
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 ),
//                 MarkerLayer(markers: [
//                   Marker(
//                     width: 80.0,
//                     height: 80.0,
//                     point: _initialLocation,
//                     child: const Icon(
//                       Icons.location_on,
//                       color: Colors.red,
//                       size: 40.0,
//                     ),
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
