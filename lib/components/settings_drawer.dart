import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/components/send_feedback_button.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/screens/essentials/essentials.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
                    builder: (BuildContext context) => const FeedbackPopUp()),
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
                    CustomButton("Teacher dashboard", () {
                      String? token = userProvider.token;
                      String? refreshToken = userProvider.refreshToken;

                      if (token != null && refreshToken != null) {
                        customLaunch(
                            "https://teacher.acroworld.de/token-callback?jwtToken=$token&refreshToken=$refreshToken");
                      } else {
                        customLaunch("https://teacher.acroworld.de");
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
                  } //=> await AuthService().signOut(),
                  )
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

  logOut(BuildContext context) {
    // deletes the credentials
    CredentialPreferences.removeEmail();
    CredentialPreferences.removePassword();

    // deletes the token and user from user provider
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.token = null;

    AuthProvider.token = null;

    // safe the user to provider
    userProvider.setUserFromToken();

    // delete all and push to authentication
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => const Authenticate(
                  initShowSignIn: true,
                )),
        (Route<dynamic> route) => false);
  }
}
