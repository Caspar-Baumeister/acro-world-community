import 'package:acroworld/presentation/screens/creator_mode_screens/location_picker_page/map_location_picker_page.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CustomLocationInputComponent extends StatelessWidget {
  const CustomLocationInputComponent(
      {super.key,
      required this.currentLocation,
      required this.onLocationSelected,
      this.currentLoactionDescription});

  final LatLng? currentLocation;
  final String? currentLoactionDescription;
  final Function onLocationSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapLocationpickerPage(
            onLocationSet: (LatLng location, String? locationDescription) {
              onLocationSelected(location, locationDescription);
            },
            initialLocation: currentLocation,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppPaddings.small),
        padding: const EdgeInsets.all(AppPaddings.small),
        decoration: BoxDecoration(
          color: CustomColors.backgroundColor,
          borderRadius: AppBorders.smallRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: AppPaddings.small),
            Flexible(
              child: Text(
                currentLoactionDescription ?? 'Select a location',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
