import 'package:acroworld/components/teacher_button_link_widget.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEventModal extends StatelessWidget {
  const CreateEventModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 24.0),
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: PRIMARY_COLOR,
              thickness: 5.0,
              indent: width * 0.40,
              endIndent: width * 0.40,
            ),
            const SizedBox(height: 30.0),
            const Center(
              child: Text(
                "Create a new event",
                style: HEADER_1_TEXT_STYLE,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0).copyWith(top: 15),
              child: Center(
                child: Text(
                  userProvider.activeUser?.userRoles != null &&
                          userProvider.activeUser!.userRoles!
                              .where((UserRole role) =>
                                  role.id ==
                                  "736a4c4c-ec50-41fc-87f8-5ff9de9e506d")
                              .isNotEmpty
                      ? "Go to your dashboard to create an event"
                      : "To be able to create an event, you first have to tell us something about yourself. Log in with your AcroWorld account and fill out some information. We will review your information promptly.",
                  style: STANDART_TEXT_STYLE,
                ),
              ),
            ),
            const TeacherButtonLinkWidget(),
            const SizedBox(height: 30.0),
          ]),
    );
  }
}
