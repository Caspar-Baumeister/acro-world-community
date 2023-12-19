import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => StandartButton(
        text: userProvider.activeUser?.userRoles != null &&
                userProvider.activeUser!.userRoles!
                    .where((UserRole role) =>
                        role.id == "736a4c4c-ec50-41fc-87f8-5ff9de9e506d")
                    .isNotEmpty
            ? "Your dashboard"
            : "Apply",
        onPressed: () async {
          setState(() {
            loading = true;
          });
          await customLaunch(AppEnvironment.dashboardUrl);
          setState(() {
            loading = false;
          });
        },
        isFilled: true,
      ),
    );
  }
}
