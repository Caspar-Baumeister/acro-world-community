import 'package:flutter/material.dart';

class FramedButton extends StatelessWidget {
  const FramedButton({super.key, required this.child, required this.onPressed});

  final Widget child;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: child),
    );
  }
}
