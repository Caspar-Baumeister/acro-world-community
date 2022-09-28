import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/buddy/buddy_page.dart';
import 'package:acroworld/screens/classes/classes_page.dart';
import 'package:acroworld/screens/events/event_page.dart';
import 'package:acroworld/screens/home/account_settings/account_settings_page.dart';
import 'package:acroworld/screens/home/calender/calender.dart';
import 'package:acroworld/screens/teacher/teachers_page/teacher_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: Material(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              // onTap: () => Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const SettingsPage(),
              //   ),
              // ),
              child: ListTile(
                leading: Text(
                  userProvider.activeUser!.name ?? "Unknown",
                ),
                // trailing: CircleAvatar(
                //   backgroundImage: NetworkImage(
                //       userProvider.activeUser!.imgUrl ?? MORTY_IMG_URL),
                // )
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Calender(),
                ),
              ),
              child: ListTile(
                  leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.location_on_sharp),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Jams")
                ],
              )),
            ),
            // Comment in again when feature is ready
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TeacherPage(),
                ),
              ),
              child: ListTile(
                  leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.person_search_sharp),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Teacher")
                ],
              )),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ClassesPage(),
                ),
              ),
              child: ListTile(
                  leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.calendar_month),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Classes")
                ],
              )),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EventsPage(),
                ),
              ),
              child: ListTile(
                  leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.festival_outlined),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Events")
                ],
              )),
            ),

            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BuddyPage(),
                ),
              ),
              child: ListTile(
                  leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.favorite),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Buddy finder")
                ],
              )),
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
                  Text("Settings")
                ],
              )),
            ),

            const Divider(color: Colors.grey, height: 1),
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
        MaterialPageRoute(builder: (context) => const Authenticate()),
        (Route<dynamic> route) => false);
  }
}
