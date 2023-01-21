import 'package:acroworld/screens/HOME_SCREENS/teachers_page/teacher_query.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        // add column with search and give the promt as input to query
        body: TeacherQuery(),
      ),
    );
  }
}
