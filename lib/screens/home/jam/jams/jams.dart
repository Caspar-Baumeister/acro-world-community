import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/create_jam/create_jam.dart';
import 'package:acroworld/screens/home/jam/jams/jam_stream.dart';
import 'package:acroworld/screens/home/jam/jams/app_bar_jams.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jams extends StatelessWidget {
  const Jams({required this.cId, Key? key}) : super(key: key);

  final String cId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarJams(cId: cId),
      body: JamsStream(cid: cId),
      floatingActionButton: IconButton(
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
    );
  }

  void handleCreateJam(BuildContext context) async {
    // // get user
    // UserProvider userProvider =
    //     Provider.of<UserProvider>(context, listen: false);

    // String userId = userProvider.activeUser!.uid;

    // get user communitys
    UserCommunitiesProvider userCommunitiesProvider =
        Provider.of<UserCommunitiesProvider>(context, listen: false);

    // get user community timestamp

    // check if user can create new jam

    // if not: say when you can create a new jam

    // otherwise link to create jam
  }
}
