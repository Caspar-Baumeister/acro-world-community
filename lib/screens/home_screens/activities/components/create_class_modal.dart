import 'package:acroworld/components/buttons/teacher_button_link_widget.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateClassModal extends StatelessWidget {
  const CreateClassModal({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 24.0),
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: CustomColors.primaryColor,
              thickness: 5.0,
              indent: width * 0.40,
              endIndent: width * 0.40,
            ),
            const SizedBox(height: 30.0),
            Center(
              child: Text(
                "Create a new class/jam",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0).copyWith(top: 15),
              child: Center(
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) => Text(
                    userProvider.activeUser?.userRoles != null &&
                            userProvider.activeUser!.userRoles!
                                .where((UserRole role) =>
                                    role.id ==
                                    "736a4c4c-ec50-41fc-87f8-5ff9de9e506d")
                                .isNotEmpty
                        ? "Go to your dashboard to create a class or jam"
                        : "To be able to create classes or jams, you first have to tell us something about yourself. Log in with your AcroWorld account and fill out some information. We will then review your information promptly. This procedure serves to prevent spam",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            const TeacherButtonLinkWidget(),
            const SizedBox(height: 30.0),
          ]),
    );
  }
}
