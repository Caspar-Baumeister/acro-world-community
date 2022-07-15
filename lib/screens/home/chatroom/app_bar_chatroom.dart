import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/jam/jams/jams.dart';
import 'package:flutter/material.dart';

class AppBarChatroom extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const AppBarChatroom({
    Key? key,
    required this.cId,
    required this.name,
    required this.community,
  }) : super(key: key);

  final String cId;
  final String name;
  final Community community;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Text(name, style: const TextStyle(color: Colors.black)),
      leading: const BackButton(color: Colors.black),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.white, elevation: 0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Jams(cId: cId, community: community, name: name)),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(
                  'Jams',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 6.0),
                ImageIcon(
                  AssetImage("assets/acro_jam_icon.png"),
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
