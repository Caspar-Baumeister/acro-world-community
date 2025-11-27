import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class BaseBottomNavigationBar extends StatelessWidget {
  const BaseBottomNavigationBar({
    super.key,
    required this.child,
    this.height = AppDimensions.buttonHeight, // Changed to buttonHeight for consistency
    this.adjustForKeyboard = true,
  });

  final Widget child;
  final double height;
  final bool adjustForKeyboard;

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: adjustForKeyboard
          ? EdgeInsets.only(bottom: keyboardHeight)
          : EdgeInsets.zero,
      child: SizedBox(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMedium, vertical: 2),
              child: child),
        ),
      ),
    );
  }
}
