import 'package:flutter/material.dart';

class DifficultyWidget extends StatelessWidget {
  const DifficultyWidget(this.classLevel, {Key? key}) : super(key: key);

  final List<String> classLevel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.green[100],
            border: classLevel.contains("Beginner") ? Border.all() : null,
          ),
        ),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            border: classLevel.contains("Intermediate") ? Border.all() : null,
          ),
        ),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.red[100],
            border: classLevel.contains("Advanced") ? Border.all() : null,
          ),
        )
      ],
    );
  }
}
