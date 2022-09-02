import 'package:acroworld/screens/classes/classes_body.dart';
import 'package:acroworld/screens/classes/classes_app_bar.dart';
import 'package:flutter/material.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarClasses(),
      body: ClassesBody(),
    );
  }
}
