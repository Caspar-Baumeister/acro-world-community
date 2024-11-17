import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_occurence_page/class_occurence_body.dart';
import 'package:flutter/material.dart';

class ClassOccurencePage extends StatelessWidget {
  const ClassOccurencePage({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return BasePage(
        appBar: CustomAppbarSimple(
          title: "${classModel.name} Occurences",
          isBackButton: true,
        ),
        makeScrollable: false,
        child: ClassOccurenceBody(classModel: classModel));
  }
}
