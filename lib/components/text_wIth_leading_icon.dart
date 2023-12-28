// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TextWithLeadingIcon extends StatelessWidget {
  const TextWithLeadingIcon(
      {super.key, required this.icon, required this.text, this.gap = 6});

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
