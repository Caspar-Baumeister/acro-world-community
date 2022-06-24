import 'package:flutter/material.dart';

class AppBarJam extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const AppBarJam({
    Key? key,
    required this.title,
    required this.onSubmit,
  }) : super(key: key);

  final String title;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Text(title, style: const TextStyle(color: Colors.black)),
      leading: const BackButton(color: Colors.black),
      actions: <Widget>[
        TextButton.icon(
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.black,
          ),
          label: const Text(
            "Submit",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () => onSubmit(),
        ),
      ],
    );
  }
}
