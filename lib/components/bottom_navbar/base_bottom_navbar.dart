// Filename: base_bottom_navigation_bar.dart

import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class BaseBottomNavigationBar extends StatelessWidget {
  const BaseBottomNavigationBar({
    super.key,
    required this.child,
    this.height = AppDimensions.bottomNavBarHeight,
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
                  horizontal: AppPaddings.medium, vertical: 2),
              child: child),
        ),
      ),
    );
  }
}
