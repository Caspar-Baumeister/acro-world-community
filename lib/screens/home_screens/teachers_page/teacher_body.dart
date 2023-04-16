import 'package:acroworld/components/teacher_button_link_widget.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/HOME_SCREENS/teachers_page/widgets/teacher_card.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherBody extends StatelessWidget {
  const TeacherBody({Key? key, required this.teachers}) : super(key: key);

  final List<TeacherModel> teachers;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    List<Widget> teacherList = List.from(
      teachers.map(
        (teacher) => TeacherCard(
            teacher: teacher,
            isLiked: isTeacherFollowedByUser(
                teacher.userLikes, userProvider.activeUser!.id!)),
      ),
    );
    Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(18.0),
          child: TeacherButtonLinkWidget(),
        ),
        ...teacherList
      ]),
    );
  }
}
