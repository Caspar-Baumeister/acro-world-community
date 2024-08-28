import 'package:acroworld/models/class_model.dart';
import 'package:flutter/material.dart';

class ClassTileTitleWidget extends StatelessWidget {
  const ClassTileTitleWidget({
    super.key,
    required this.classObject,
  });

  final ClassModel classObject;

  @override
  Widget build(BuildContext context) {
    return Text(
      classObject.name ?? "Unknown",
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            letterSpacing: -0.5,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
