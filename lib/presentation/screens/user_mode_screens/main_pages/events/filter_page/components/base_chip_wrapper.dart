import 'package:flutter/material.dart';

class BaseChipWrapper extends StatelessWidget {
  const BaseChipWrapper({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 6, runSpacing: -5, children: children);
  }
}
