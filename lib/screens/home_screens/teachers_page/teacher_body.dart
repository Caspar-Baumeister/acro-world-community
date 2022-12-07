import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/home_screens/teachers_page/widgets/teacher_card.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                    text:
                        "You are an acro teacher and want to show your profile? Tell us about you in a brief email to ",
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: "info@acroworld.com",
                    style: const TextStyle(
                        color: PRIMARY_COLOR, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Clipboard.setData(
                            const ClipboardData(text: "info@acroworld.com"));
                        Fluttertoast.showToast(
                            msg: "Email copied",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }),
              ],
            ),
          ),
        ),
        ...teacherList
      ]),
    );
    //   ],
    // );
  }
}
