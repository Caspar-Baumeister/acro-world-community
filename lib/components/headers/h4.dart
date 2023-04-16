import 'package:acroworld/components/headers/h.dart';
import 'package:flutter/material.dart';

class H4 extends StatelessWidget {
  const H4({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return H(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
