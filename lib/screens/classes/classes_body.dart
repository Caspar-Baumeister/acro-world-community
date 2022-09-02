import 'package:acroworld/shared/widgets/comming_soon_widget.dart';
import 'package:flutter/material.dart';

class ClassesBody extends StatelessWidget {
  const ClassesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CommingSoon(
      header: "What are classes?",
      content:
          "This will soon be the place where you will be able to find all classes tailored for your level and preferences in your city.",
    );
  }
}
