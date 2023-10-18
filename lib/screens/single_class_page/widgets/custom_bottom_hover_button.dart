import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomBottomHoverButton extends StatelessWidget {
  const CustomBottomHoverButton(
      {Key? key, required this.content, required this.onPressed})
      : super(key: key);

  final Widget content;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10, // bottom padding
      left: 10, // left padding
      right: 10, // right padding
      child: ClipRRect(
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () => onPressed(),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: PRIMARY_COLOR, // button text color
              padding: const EdgeInsets.all(15), // internal padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
