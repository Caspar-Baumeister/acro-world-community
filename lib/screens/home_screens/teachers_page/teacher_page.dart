import 'package:acroworld/components/settings_drawer.dart';
import 'package:acroworld/screens/HOME_SCREENS/teachers_page/teacher_query.dart';
import 'package:acroworld/screens/home_screens/teachers_page/teacher_app_bar.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        appBar: AppBarTeacher(),
        endDrawer: SettingsDrawer(),
        // add column with search and give the promt as input to query
        body: TeacherQuery(),
      ),
    );
  }
}
