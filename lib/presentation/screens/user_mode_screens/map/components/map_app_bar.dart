import 'package:acroworld/presentation/components/buttons/place_button/place_button.dart';
import 'package:acroworld/presentation/components/custom_sliver_app_bar.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class MapAppBar extends StatelessWidget {
  const MapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Row(
        children: [
          BlurIconButton(isCollapsed: false),
          SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            child: PlaceButton(
              rightPadding: false,
            ),
          ),
        ],
      ),
    );
  }
}
