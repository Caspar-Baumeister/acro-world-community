import 'package:flutter/material.dart';

class FramedButton extends StatelessWidget {
  const FramedButton({super.key, required this.child, required this.onPressed});

  final Widget child;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed(),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey), // Retaining original border color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Retaining original border radius
        ),
        padding: const EdgeInsets.all(4), // Retaining original padding
      ),
      child: child,
    );
  }
}
