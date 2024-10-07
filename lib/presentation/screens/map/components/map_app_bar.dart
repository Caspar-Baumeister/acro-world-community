import 'package:acroworld/core/utils/constants.dart';
import 'package:acroworld/presentation/shared_components/buttons/place_button/place_button.dart';
import 'package:acroworld/presentation/shared_components/custom_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class MapAppBar extends StatelessWidget {
  const MapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.medium),
      child: Row(
        children: [
          BlurIconButton(isCollapsed: false),
          SizedBox(width: AppPaddings.small),
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
