import 'package:flutter/material.dart';

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: const Center(
        child: Image(
          image: AssetImage("assets/muscleup_drawing.png"),
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
