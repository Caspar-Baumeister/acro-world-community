import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
          child: CircularProgressIndicator(),
          // child: Image(
          //   image: AssetImage("assets/muscleup_drawing.png"),
          //   height: 200,
          //   fit: BoxFit.contain,
          // ),
        ),
      ],
    );
  }
}