import 'package:acroworld/components/buttons/standard_icon_button.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class SetToUserLocationWidget extends StatefulWidget {
  const SetToUserLocationWidget({Key? key}) : super(key: key);

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
      Fluttertoast.showToast(
          msg:
              "We could not locate you, please enter your current location manually",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    }
    locationData = locationData0;

    Place userPlace = Place(
        id: "0",
        description: "My location",
        latLng: LatLng(locationData.latitude!, locationData.longitude!));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<PlaceProvider>(context, listen: false).updatePlace(userPlace);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StandardIconButton(
      text: "My location",
      onPressed: () async {
        setState(() {
          loading = true;
        });
        await setToUserLocation(context);
        setState(() {
          loading = false;
        });
      },
      icon: Icons.location_on,
      loading: loading,
    );
  }
}
