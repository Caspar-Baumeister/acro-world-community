import 'package:flutter/material.dart';

class AppBarClasses extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarClasses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const Text(
        "Classes",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
