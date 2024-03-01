import 'package:flutter/material.dart';

class H extends StatelessWidget {
  const H(this.text, {super.key, required this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: TextAlign.left,
    );
  }
}
