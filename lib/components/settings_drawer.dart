import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/components/send_feedback_button.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/screens/essentials/essentials.dart';
import 'package:acroworld/services/local_storage_service.dart';
import 'package:acroworld/types_and_extensions/preferences_extension.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/helper_functions/logout.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AccountSettingsPage(),
                  ),
                ),
                child: const ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Settings",
                      style: H18W4,
                    )
                  ],
                )),
              ),
              const Divider(color: Colors.grey, height: 1),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EssentialsPage(),
                  ),
                ),
                child: const ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.backpack_outlined),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Essentials",
                      style: H18W4,
                    )
                  ],
                )),
              ),
              const Divider(color: Colors.grey, height: 1),
              GestureDetector(
                onTap: () => showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => const FeedbackPopUp(
                        subject: 'Feedback from AcroWorld App',
                        title: "Feedback & Bugs")),
                child: const ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.feedback_outlined),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Feedback & Bugs",
                      style: H18W4,
                    )
                  ],
                )),
              ),
              const Divider(color: Colors.grey, height: 1),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const AcronycWidget(),

                    const Spacer(),
                    CustomButton("Teacher dashboard", () async {
                      final token = await TokenSingletonService().getToken();
                      final refreshToken =
                          LocalStorageService.get(Preferences.refreshToken);

                      if (refreshToken != null) {
                        customLaunch(
                            "${AppEnvironment.dashboardUrl}/token-callback?jwtToken=$token&refreshToken=$refreshToken");
                      } else {
                        customLaunch(AppEnvironment.dashboardUrl);
                      }
                    }),
                  ],
                ),
              )),
              buildMenuItem(
                  text: "Log out",
                  icon: Icons.logout,
                  onPressed: () async {
                    await logOut(context);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text,
      required IconData icon,
      required VoidCallback onPressed}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
      ),
      onTap: onPressed,
    );
  }
}
