import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Center(
        child: Icon(
          icon,
          size: AppDimensions.iconSizeSmall,
        ),
      ),
    );
  }
}
