import 'package:acroworld/screens/teacher/teachers_page/teacher_app_bar.dart';
import 'package:acroworld/screens/teacher/teachers_page/teacher_query.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarTeacher(),
      body: TeacherQuery(),
    );
  }
}