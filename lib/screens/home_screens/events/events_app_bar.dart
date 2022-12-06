import 'package:flutter/material.dart';

class AppBarEvents extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const Text(
        "Events",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
