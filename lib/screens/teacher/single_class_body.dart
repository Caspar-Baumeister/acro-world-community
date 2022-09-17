import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
import 'package:flutter/material.dart';

class SingleClassBody extends StatelessWidget {
  const SingleClassBody(
      {Key? key, required this.classEvents, required this.classe})
      : super(key: key);

  final List<ClassEvent> classEvents;
  final ClassModel classe;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SpacedColumn(
        space: 10,
        children: [
          const SizedBox(height: 20),
          Text(
            classe.description,
            // textAlign: TextAlign.center,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Requirements",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "Hier fehlt class requirements, This is a class for acrobats with at least fundamental experience. We recommend at least 6 months experience and the ability to perform a stable shoulder stand on feet, Foot to foot, Two-High, and 30 sec handstand against the wall.")
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Prices",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Hier fehlt pricing,\nSingle Session 15€\n4 Sessions 50€\n10 Sessions 100€",
                      textAlign: TextAlign.end,
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            color: Colors.grey,
            height: 600,
          )
        ],
      ),
    ));
  }
}
