import 'package:flutter/material.dart';

class AppBarUserCommunities extends StatelessWidget with PreferredSizeWidget {
  AppBarUserCommunities({Key? key}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    //UserProvider userProvider = Provider.of<UserProvider>(context);
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0.0,
      centerTitle: false,
      titleSpacing: 20,
      backgroundColor: Colors.white,
      title: const Text("Communities", style: TextStyle(color: Colors.black)),
      leading: null,
    );
  }
}
