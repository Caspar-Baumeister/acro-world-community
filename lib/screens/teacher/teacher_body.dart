import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/teacher/widgets/teacher_card.dart';
import 'package:flutter/material.dart';

class TeacherBody extends StatelessWidget {
  const TeacherBody({Key? key, required this.teachers}) : super(key: key);

  final List<TeacherModel> teachers;

  @override
  Widget build(BuildContext context) {
    return
        // Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Row(
        //         children: const [
        //           // Expanded(
        //           //   child: SearchBarWidget(
        //           //     onChanged: (String value) {
        //           //       setState(() {
        //           //         query = value;
        //           //       });
        //           //     },
        //           //   ),
        //           // ),
        //         ],
        //       ),
        //     ),
        SingleChildScrollView(
            child: Column(
                children: List.from(
                    teachers.map((teacher) => TeacherCard(teacher: teacher)))));
    //   ],
    // );
  }
}
