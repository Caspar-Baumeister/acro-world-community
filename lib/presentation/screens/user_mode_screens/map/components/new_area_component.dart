import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class NewAreaComponent extends StatelessWidget {
  const NewAreaComponent({
    super.key,
    required this.placeProvider,
    required this.center,
  });

  final PlaceProvider placeProvider;
  final LatLng center;

  @override
  Widget build(BuildContext context) {
    if (center.latitude !=
            placeProvider.locationSingelton.place.latLng.latitude ||
        center.longitude !=
            placeProvider.locationSingelton.place.latLng.longitude) {
      return Padding(
        padding: const EdgeInsets.only(top: AppPaddings.small),
        child: SizedBox(
          width: 200,
          child: StandartButton(
              onPressed: () {
                placeProvider.updatePlaceByLaTLang(center);
                // update MapEventsProvider
                Provider.of<MapEventsProvider>(context, listen: false)
                    .fetchClasseEvents();
              },
              isFilled: true,
              text: "Search in this area"),
        ),
      );
    } else {
      return Container();
    }
  }
}
