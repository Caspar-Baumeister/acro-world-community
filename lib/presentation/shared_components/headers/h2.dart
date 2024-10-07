import 'package:acroworld/presentation/shared_components/headers/h.dart';
import 'package:flutter/material.dart';

class H2 extends StatelessWidget {
  const H2({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return H(
      text,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}
