import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/settings/settings.dart';
import 'package:acroworld/services/auth.dart';
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
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              ),
              child: ListTile(
                  leading: Text(
                    userProvider.activeUser!.userName!,
                  ),
                  trailing: CircleAvatar(
                    backgroundImage:
                        NetworkImage(userProvider.activeUser!.imgUrl!),
                  )),
            ),
            const Divider(color: Colors.grey, height: 1),
            buildMenuItem(
              text: "Log out",
              icon: Icons.logout,
              onPressed: () async => await AuthService().signOut(),
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
}
