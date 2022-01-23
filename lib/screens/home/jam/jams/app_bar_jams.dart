import 'package:acroworld/screens/home/jam/create_jam/create_jam.dart';
import 'package:flutter/material.dart';

class AppBarJams extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarJams({
    Key? key,
    required this.cId,
  }) : super(key: key);

  final String cId;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Text("Jams in $cId", style: const TextStyle(color: Colors.black)),
      leading: const BackButton(color: Colors.black),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateJam(
                        cid: cId,
                      )),
            );
          },
          icon: const ImageIcon(
            AssetImage("assets/muscleup_drawing.png"),
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
