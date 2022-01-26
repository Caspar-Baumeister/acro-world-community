import 'package:flutter/material.dart';

class AppBarCreateJam extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const AppBarCreateJam({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  final Function onCreate;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: const Text("New Jam", style: TextStyle(color: Colors.black)),
      leading: const BackButton(color: Colors.black),
      actions: <Widget>[
        TextButton.icon(
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.black,
          ),
          label: const Text(
            'create',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () => onCreate(),
        ),
      ],
    );
  }
}
