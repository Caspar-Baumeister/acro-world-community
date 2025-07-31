import 'package:acroworld/presentation/screens/creator_mode_screens/location_picker_page/map_location_picker_page.dart';
import 'package:acroworld/theme/app_dimensions.dart';
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
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSmall),
        padding: const EdgeInsets.all(AppDimensions.spacingSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Theme.of(context).iconTheme.color),
            const SizedBox(width: AppDimensions.spacingSmall),
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
