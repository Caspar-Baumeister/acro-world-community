import 'package:flutter/material.dart';

class AppBarBuddy extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarBuddy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const Text(
        "Buddy finder",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
