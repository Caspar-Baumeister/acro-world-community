import 'package:acroworld/environment.dart';
import 'package:acroworld/presentation/components/buttons/custom_button.dart';
import 'package:acroworld/presentation/components/send_feedback_button.dart';
import 'package:acroworld/presentation/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/essentials/essentials.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/services/local_storage_service.dart';
import 'package:acroworld/types_and_extensions/preferences_extension.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/helper_functions/logout.dart';
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
                child: ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Settings",
                      style: Theme.of(context).textTheme.headlineSmall,
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
                child: ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.backpack_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Essentials",
                      style: Theme.of(context).textTheme.headlineSmall,
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
                child: ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.feedback_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Feedback & Bugs",
                      style: Theme.of(context).textTheme.headlineSmall,
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
                    CustomButton("Creator Dashboard", () async {
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
