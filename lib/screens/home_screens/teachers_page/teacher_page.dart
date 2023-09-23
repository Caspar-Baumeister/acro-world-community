import 'package:acroworld/screens/home_screens/teachers_page/teacher_app_bar.dart';
import 'package:acroworld/screens/home_screens/teachers_page/teacher_query.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  String search = "";

  setSearch(String newSearch) {
    setState(() {
      search = newSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TeacherAppBar(onSearchChanged: setSearch),

        // add column with search and give the promt as input to query
        body: TeacherQuery(search: search),
      ),
    );
  }
}
