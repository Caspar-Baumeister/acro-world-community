import 'package:flutter/material.dart';

class SpacedColumn extends StatelessWidget {
  const SpacedColumn({
    Key? key,
    required this.space,
    required this.children,
    this.crossAxisAlignment,
  }) : super(key: key);

  final double space;
  final List<Widget> children;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: children
            .map((e) => Column(
                  children: [e, SizedBox(height: space)],
                ))
            .toList());
  }
}
