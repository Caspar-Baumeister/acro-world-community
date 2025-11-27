import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/utils/app_constants.dart';
import 'package:flutter/material.dart';

class DifficultyWidget extends StatelessWidget {
  const DifficultyWidget(this.classLevel,
      {super.key,
      this.height = DIFFICULTY_LEVEL_HEIGHT,
      this.totalWidth = DIFFICULTY_LEVEL_WIDTH});

  final List<ClassLevels>? classLevel;
  final double height;
  final double totalWidth;

  @override
  Widget build(BuildContext context) {
    // take first entry and paints in that colour/ show this text
    List<String> levels = classLevel?.map((e) => e.level!.name!).toList() ??
        List<String>.from([]);
    Gradient? gradient;
    Color? color;
    String text = "";
    if (levels.contains("Open")) {
      gradient = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromARGB(255, 194, 246, 195),
          Color.fromARGB(255, 251, 243, 172),
          Color.fromARGB(255, 252, 181, 188),
        ],
        stops: [
          0.33,
          0.66,
          0.99,
        ],
      );
      text = "Open";
    } else if (levels.isEmpty) {
      return Container();
    } else if (levels[0] == "Beginner") {
      color = const Color.fromARGB(255, 194, 246, 195);
      text = "Beginner";
    } else if (levels[0] == "Intermediate") {
      color = const Color.fromARGB(255, 251, 243, 172);
      text = "Intermediate";
    } else if (levels[0] == "Advanced") {
      color = const Color.fromARGB(255, 252, 181, 188);
      text = "Advanced";
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          gradient: gradient,
          color: color),
      child: Center(
          child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      )),
    );
  }
}
