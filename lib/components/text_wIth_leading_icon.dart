import 'package:flutter/material.dart';

class TextWIthLeadingIcon extends StatelessWidget {
  const TextWIthLeadingIcon(
      {Key? key, required this.icon, required this.text, this.gap = 6})
      : super(key: key);

  final Widget icon;
  final Widget text;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [icon, SizedBox(width: gap), Flexible(child: text)],
    );
  }
}
