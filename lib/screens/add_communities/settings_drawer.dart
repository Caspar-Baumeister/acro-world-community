import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: SafeArea(
        child: Material(
          child: Column(
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
                ),
              ),
              // GestureDetector(
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const Calender(),
              //     ),
              //   ),
              //   child: ListTile(
              //       leading: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: const [
              //       Icon(Icons.location_on_sharp),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       Text("Jams")
              //     ],
              //   )),
              // ),
              // // Comment in again when feature is ready
              // GestureDetector(
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const TeacherPage(),
              //     ),
              //   ),
              //   child: ListTile(
              //       leading: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: const [
              //       Icon(Icons.person_search_sharp),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       Text("Teacher")
              //     ],
              //   )),
              // ),
              // GestureDetector(
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const ClassesPage(),
              //     ),
              //   ),
              //   child: ListTile(
              //       leading: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: const [
              //       Icon(Icons.calendar_month),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       Text("Classes")
              //     ],
              //   )),
              // ),
              // GestureDetector(
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const EventsPage(),
              //     ),
              //   ),
              //   child: ListTile(
              //       leading: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: const [
              //       Icon(Icons.festival_outlined),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       Text("Events")
              //     ],
              //   )),
              // ),

              // GestureDetector(
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const BuddyPage(),
              //     ),
              //   ),
              //   child: ListTile(
              //       leading: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: const [
              //       Icon(Icons.favorite),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       Text("Buddy finder")
              //     ],
              //   )),
              // ),
              // GestureDetector(
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const RecommendationsPage(),
              //     ),
              //   ),
              //   child: ListTile(
              //       leading: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: const [
              //       Icon(Icons.thumb_up),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       Text("Recommendations")
              //     ],
              //   )),
              // ),
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
                    Text("Settings")
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
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: "Help us spread the word by sending an ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "invitation",
                              style: const TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Share.share(
                                      "Download AcroWorld!\nIt's the new acro community app\n\nAppstore: https://apps.apple.com/au/app/acroworld/id1633240146\nPlaystore: https://play.google.com/store/apps/details?id=com.community.acroworld&gl\n\nUse the friendcode 'AcroWorldCommunity' to create an account");
                                }),
                          const TextSpan(
                              text: " to your community!",
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, height: 1),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: "For any problems, contact the support at ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "info@acroworld.com",
                              style: const TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Clipboard.setData(const ClipboardData(
                                      text: "info@acroworld.com"));
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.token = null;

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
