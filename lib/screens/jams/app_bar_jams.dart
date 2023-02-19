import 'package:flutter/material.dart';

class AppBarJams extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarJams({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Text("Jams in $name", style: const TextStyle(color: Colors.black)),
      leading: const BackButton(color: Colors.black),
    );
  }
}
