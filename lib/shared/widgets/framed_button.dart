import 'package:flutter/material.dart';

class FramedButton extends StatelessWidget {
  const FramedButton({Key? key, required this.child, required this.onPressed})
      : super(key: key);

  final Widget child;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("framedButton");
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
