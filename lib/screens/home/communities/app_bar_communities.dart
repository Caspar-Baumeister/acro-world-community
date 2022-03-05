import 'package:flutter/material.dart';

class AppBarCommunities extends StatelessWidget with PreferredSizeWidget {
  AppBarCommunities({Key? key}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    //UserProvider userProvider = Provider.of<UserProvider>(context);
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: const Text("Communities", style: TextStyle(color: Colors.black)),
      leading: null,
      // actions: <Widget>[
      //   TextButton(
      //     onPressed: () async {
      //       await AuthService().signOut();
      //     },
      //     child: const Text(
      //       "logout",
      //       style: TextStyle(color: Colors.black),
      //     ),
      //   ),
      //   userProvider.activeUser != null
      //       ? GestureDetector(
      //           onTap: () => Navigator.of(context).push(
      //             MaterialPageRoute(
      //               builder: (context) => const SettingsPage(),
      //             ),
      //           ),
      //           child: CircleAvatar(
      //               radius: 32.0,
      //               backgroundImage: NetworkImage(
      //                   userProvider.activeUser!.imgUrl ?? MORTY_IMG_URL)),
      //         )
      //       : IconButton(
      //           onPressed: () => Navigator.of(context).push(
      //             MaterialPageRoute(
      //               builder: (context) => const SettingsPage(),
      //             ),
      //           ),
      //           icon: const Icon(Icons.person),
      //           color: Colors.black,
      //         )
      // ],
    );
  }
}
