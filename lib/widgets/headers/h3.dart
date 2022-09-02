import 'package:acroworld/widgets/headers/h.dart';
import 'package:flutter/material.dart';

class H3 extends StatelessWidget {
  const H3({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return H(
      text,
      style: Theme.of(context).textTheme.headline3,
    );
  }
}
