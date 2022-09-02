import 'package:flutter/material.dart';

class H extends StatelessWidget {
  const H(this.text, {Key? key, required this.style}) : super(key: key);

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
