import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarJamOverview extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarJamOverview({required this.jam, required this.cid, Key? key})
      : super(key: key);
  final Jam jam;
  final String cid;

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).activeUser!;
    bool userPressed = jam.participants.contains(user.uid);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text(jam.name, style: const TextStyle(color: Colors.black)),
      actions: <Widget>[
        TextButton.icon(
          icon: Icon(
            Icons.add_circle_outline,
            color: userPressed ? Colors.black54 : Colors.black,
          ),
          label: Text(
            userPressed ? 'exit' : 'apply',
            style: const TextStyle(color: Colors.black),
          ),
          onPressed: () => userPressed ? null : onParticipate(context),
        ),
      ],
    );
  }

  void onParticipate(BuildContext context) async {
    // get activ user to safe the id
    UserModel user =
        Provider.of<UserProvider>(context, listen: false).activeUser!;

    List<String> participants = jam.participants;
    participants.add(user.uid);

    // creates a new jam object
    DataBaseService(uid: user.uid).updateJamField(
        jid: jam.jid, cid: cid, field: "participants", value: participants);
    // redirects to jams

    // error handling
  }
}
