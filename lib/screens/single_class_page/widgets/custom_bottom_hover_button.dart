import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomBottomHoverButton extends StatelessWidget {
  const CustomBottomHoverButton({
    super.key,
    required this.content,
    required this.onPressed,
    this.backgroundColor,
  });

  final Widget content;
  final Function onPressed;
  // add a color for the background
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            // if no color is given, use the primary color
            backgroundColor: backgroundColor ?? PRIMARY_COLOR,
            padding: const EdgeInsets.all(15), // internal padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Center(child: content),
        ),
      ),
    );
  }
}
