import 'package:acroworld/components/acronyc/acronyc_widget.dart';
import 'package:acroworld/components/buttons/your_gender_button_widget.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
              ListTile(
                leading: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: userProvider.activeUser!.imageUrl ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
                title: Text(
                  userProvider.activeUser!.name ?? "Unknown",
                  style: BIG_TEXT_STYLE,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10, right: 15),
                child: YourGenderButtonWidget(),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AccountSettingsPage(),
                  ),
                ),
                child: ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.settings),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Settings",
                      style: STANDART_DESCRIPTION,
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
                    const AcronycWidget(),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, height: 1),
                    const SizedBox(height: 10),
                    // RichText(
                    //   textAlign: TextAlign.left,
                    //   text: TextSpan(
                    //     children: <TextSpan>[
                    //       const TextSpan(
                    //           text: "Help us spread the word by sending an ",
                    //           style: TextStyle(color: Colors.black)),
                    //       TextSpan(
                    //           text: "invitation",
                    //           style: const TextStyle(
                    //               color: PRIMARY_COLOR,
                    //               fontWeight: FontWeight.bold),
                    //           recognizer: TapGestureRecognizer()
                    //             ..onTap = () {
                    //               Share.share(
                    //                   "Download AcroWorld!\n...and find all classes and events around acroyoga\n\nAppstore: https://apps.apple.com/au/app/acroworld/id1633240146\nPlaystore: https://play.google.com/store/apps/details?id=com.community.acroworld&gl");
                    //             }),
                    //       const TextSpan(
                    //           text: " to your friends!",
                    //           style: TextStyle(color: Colors.black)),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // const Divider(color: Colors.grey, height: 1),
                    // const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: "For any problems, contact the support at ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "info@acroworld.de",
                              style: const TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Clipboard.setData(const ClipboardData(
                                      text: "info@acroworld.de"));
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
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, height: 1),
                    const SizedBox(height: 10),
                    // const TeacherButtonLinkWidget(),
                    // StandartButton(
                    //   isFilled: true,
                    //   text: "Creator profile",
                    //   onPressed: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const CreateCreatorProfile(),
                    //     ),
                    //   ),
                    // )
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