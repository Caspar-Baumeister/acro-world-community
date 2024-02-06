import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/HOME_SCREENS/teachers_page/widgets/teacher_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherBody extends StatelessWidget {
  const TeacherBody({
    super.key,
    required this.teachers,
  });

  final List<TeacherModel> teachers;

  @override
  Widget build(BuildContext context) {
    List<Widget> teacherList = List.from(
      teachers.where((TeacherModel teacher) => teacher.type != "Anonymous").map(
            (teacher) => Consumer<UserProvider>(
              builder: (context, userProvider, child) => TeacherCard(
                teacher: teacher,
                isLiked: userProvider.activeUser?.id == null
                    ? false
                    : teacher.likedByUser ?? false,
              ),
            ),
          ),
    );
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...teacherList]);
  }
}
