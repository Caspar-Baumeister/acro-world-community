import 'package:acroworld/data/models/class_model.dart';
import 'package:flutter/material.dart';

class ClassTileTitleWidget extends StatelessWidget {
  const ClassTileTitleWidget({
    super.key,
    required this.classObject,
  });

  final ClassModel classObject;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            classObject.name ?? "Unknown",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  letterSpacing: -0.5,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (classObject.amountActiveFlaggs != null &&
            classObject.amountActiveFlaggs! > 0)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  classObject.amountActiveFlaggs.toString(),
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.flag,
                color: Colors.red,
                size: 20,
              ),
            ],
          ),
      ],
    );
  }
}
