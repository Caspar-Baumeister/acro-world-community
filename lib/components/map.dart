// import 'package:acroworld/utils/helper_functions/helper_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapWidget extends StatefulWidget {
//   const MapWidget(
//       {Key? key,
//       this.center,
//       this.markerLocation,
//       this.onLocationSelected,
//       this.zoom,
//       this.height})
//       : super(key: key);

//   final LatLng? center;
//   final LatLng? markerLocation;
//   final Function(LatLng)? onLocationSelected;
//   final double? zoom;
//   final double? height;

//   @override
//   State<MapWidget> createState() => _MapState();
// }

// class _MapState extends State<MapWidget> {
//   late GoogleMapController mapController;

//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

//   void _add(LatLng markerLocation) {
//     // Allow only one marker Location. Set hardcoded id.
//     const MarkerId markerId = MarkerId('0');

//     // creating a new MARKER
//     final Marker marker = Marker(markerId: markerId, position: markerLocation);

//     setState(() {
//       // adding a new marker to map
//       markers[markerId] = marker;
//     });
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   // void _onLongPress(LatLng clickedLocation) {
//   //   _add(clickedLocation);
//   //   widget.onLocationSelected!(clickedLocation);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     LatLng center = const LatLng(52.5200, 13.4050);

//     if (widget.center != null) {
//       center = widget.center!;
//     }

//     if (widget.markerLocation != null) {
//       _add(widget.markerLocation!);
//     }

//     return SizedBox(
//       height: widget.height ?? 350,
//       child: GoogleMap(
//         myLocationEnabled: false,
//         onMapCreated: _onMapCreated,
//         myLocationButtonEnabled: false,
//         initialCameraPosition: CameraPosition(
//           target: center,
//           zoom: widget.zoom ?? 0,
//         ),
//         // onLongPress: _onLongPress,
//         onTap: (argument) => openMap(argument.latitude, argument.longitude),
//         markers: Set<Marker>.of(markers.values),
//       ),
//     );
//   }
// }
