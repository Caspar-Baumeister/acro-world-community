import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/screens/teacher/widgets/teacher_card.dart';
import 'package:acroworld/shared/widgets/comming_soon_widget.dart';
import 'package:flutter/material.dart';

class TeacherBody extends StatefulWidget {
  const TeacherBody({Key? key}) : super(key: key);

  @override
  State<TeacherBody> createState() => _TeacherBodyState();
}

class _TeacherBodyState extends State<TeacherBody> {
  String query = "";

  List<Map<String, dynamic>> filterTeacher() {
    if (query == "") {
      return teacher;
    }

    return List.from(teacher.where((t) {
      if (t["name"].toString().toLowerCase().contains(query.toLowerCase()) ||
          t["city"].toString().toLowerCase().contains(query.toLowerCase())) {
        return true;
      }
      return false;
    }));
  }

  @override
  Widget build(BuildContext context) {
    final showTeacher = filterTeacher();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  onChanged: (String value) {
                    setState(() {
                      query = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        teacher.isEmpty
            ? const CommingSoon(
                header: "What is the teacher page",
                content:
                    "On the teacher page you have the opportunity to discover the local teachers that suit you best. You can see their teaching style, level, and user feedback. You can also instantly join their community and participate in their classes and jams.")
            : SingleChildScrollView(
                child: Column(
                    children: List.from(showTeacher.map((json) =>
                        TeacherCard(teacher: TeacherModel.fromJson(json)))))),
      ],
    );
  }
}
