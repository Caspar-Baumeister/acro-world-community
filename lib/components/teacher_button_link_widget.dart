import 'package:acroworld/components/standart_button.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherButtonLinkWidget extends StatefulWidget {
  const TeacherButtonLinkWidget({Key? key}) : super(key: key);

  @override
  State<TeacherButtonLinkWidget> createState() =>
      _TeacherButtonLinkWidgetState();
}

class _TeacherButtonLinkWidgetState extends State<TeacherButtonLinkWidget> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return userProvider.activeUser?.userRoles != null &&
            userProvider.activeUser!.userRoles!
                .where((UserRole role) =>
                    role.id == "736a4c4c-ec50-41fc-87f8-5ff9de9e506d")
                .isNotEmpty
        ? StandartButton(
            text: "Your Teacher Dashboard",
            onPressed: () async {
              setState(() {
                loading = true;
              });
              Uri _url = Uri.parse("https://teacher.acroworld.de");
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
              setState(() {
                loading = false;
              });
            },
            isFilled: true,
          )
        : RichText(
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
          );
  }
}
