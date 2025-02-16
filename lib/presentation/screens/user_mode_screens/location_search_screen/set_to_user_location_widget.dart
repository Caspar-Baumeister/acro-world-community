import 'package:acroworld/data/models/places/place.dart';
import 'package:acroworld/provider/calendar_provider.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class SetToUserLocationWidget extends StatefulWidget {
  const SetToUserLocationWidget({super.key});

  @override
  State<SetToUserLocationWidget> createState() =>
      _SetToUserLocationWidgetState();
}

class _SetToUserLocationWidgetState extends State<SetToUserLocationWidget> {
  bool loading = false;
  setToUserLocation(BuildContext context) async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData0 = await Future.any([
      location.getLocation(),
      Future.delayed(const Duration(seconds: 6), () => null),
    ]);

    if (locationData0 == null) {
      showErrorToast(
          "We could not locate you, please enter your current location manually");

      return;
    }
    locationData = locationData0;

    Place place = Place(
        id: "0",
        description: "My location",
        latLng: LatLng(locationData.latitude!, locationData.longitude!));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LocationSingleton().setPlace(place);
      Provider.of<PlaceProvider>(context, listen: false).updatePlace(place);
      Provider.of<CalendarProvider>(context, listen: false).fetchClasseEvents();
      // updateCurrentCameraPosition MapEventsProvider
      Provider.of<MapEventsProvider>(context, listen: false)
          .setPlaceFromPlace(place);

      Provider.of<MapEventsProvider>(context, listen: false)
          .fetchClasseEvents();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
          height: AppDimensions.iconSizeMedium,
          width: AppDimensions.iconSizeMedium,
          child: CircularProgressIndicator());
    }
    return IconButton(
      iconSize: AppDimensions.iconSizeMedium,
      onPressed: () async {
        setState(() {
          loading = true;
        });
        await setToUserLocation(context);
        setState(() {
          loading = false;
        });
      },
      icon: const Icon(
        Icons.my_location_outlined,
      ),
    );
  }
}
