import 'package:acroworld/presentation/components/headers/h.dart';
import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  const H1({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return H(
      text,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}
