import 'package:acroworld/screens/home/settings/settings.dart';
import 'package:acroworld/services/auth.dart';
import 'package:flutter/material.dart';

class AppBarCommunities extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: const Text("Acroworld", style: TextStyle(color: Colors.black)),
      leading: null,
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await AuthService().signOut();
          },
          child: const Text(
            "logout",
            style: TextStyle(color: Colors.black),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ),
          ),
          icon: const Icon(Icons.person),
          color: Colors.black,
        )
      ],
    );
  }
}
