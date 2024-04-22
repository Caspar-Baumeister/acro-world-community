import 'package:acroworld/components/headers/h.dart';
import 'package:flutter/material.dart';

class H3 extends StatelessWidget {
  const H3({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return H(
      text,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}
