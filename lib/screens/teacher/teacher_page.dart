import 'package:acroworld/screens/teacher/teacher_app_bar.dart';
import 'package:acroworld/screens/teacher/teacher_body.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarTeacher(),
      body: TeacherBody(),
    );
  }
}
