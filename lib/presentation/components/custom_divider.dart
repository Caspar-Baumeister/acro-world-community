import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: AppDimensions.spacingSmall),
        Divider(),
        SizedBox(height: AppDimensions.spacingSmall),
      ],
    );
  }
}
