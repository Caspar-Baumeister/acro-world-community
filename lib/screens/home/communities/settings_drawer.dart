import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/calender/calender.dart';
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
                  userProvider.activeUser!.userName,
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
                  Icon(Icons.calendar_month_rounded),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Calendar")
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
