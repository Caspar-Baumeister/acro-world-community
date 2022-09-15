import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/teacher/single_teacher_page.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({Key? key, required this.teacher}) : super(key: key);

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => SingleTeacherPage(
                    teacher: teacher,
                    isEdit: false,
                  )),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(teacher.profilePicUrl),
          ),
          title: Text(
            teacher.name,
            style: MAINTEXT,
          ),
          subtitle: Text(teacher.city, style: SECONDARYTEXT),
          trailing: Stack(alignment: AlignmentDirectional.center, children: [
            const Icon(
              Icons.favorite,
              size: 42,
              color: SECONDARY_COLOR,
            ),
            Text(
              teacher.likes.toString(),
              style: SECONDARYTEXT.copyWith(fontSize: 12, color: Colors.black),
            )
          ]),
        ),
      ),
    );
  }
}
