import 'package:acroworld/components/teacher_button_link_widget.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/HOME_SCREENS/teachers_page/widgets/teacher_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherBody extends StatelessWidget {
  const TeacherBody(
      {Key? key, required this.teachers, required this.teachersILike})
      : super(key: key);

  final List<TeacherModel> teachers;
  final List<String> teachersILike;

  @override
  Widget build(BuildContext context) {
    List<Widget> teacherList = List.from(
      teachers.map(
        (teacher) => TeacherCard(
          teacher: teacher,
          isLiked: teachersILike.contains(teacher.id),
        ),
      ),
    );
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(18.0),
          child: TeacherButtonLinkWidget(),
        ),
        ...teacherList
      ]),
    );
    //   ],
    // );
  }
}
