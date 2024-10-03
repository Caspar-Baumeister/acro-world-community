import 'package:flutter/material.dart';

class SpacedColumn extends StatelessWidget {
  const SpacedColumn({
    super.key,
    required this.space,
    required this.children,
    this.crossAxisAlignment,
  });

  final double space;
  final List<Widget> children;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (Widget widget in children) {
      widgets.add(widget);
      widgets.add(SizedBox(height: space));
    }
    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: widgets);
  }
}
