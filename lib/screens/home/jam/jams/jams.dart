import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/create_jam/create_jam.dart';
import 'package:acroworld/screens/home/jam/jams/jam_stream.dart';
import 'package:acroworld/screens/home/jam/jams/app_bar_jams.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        onPressed: () => handleCreateJam(context),
        icon: const ImageIcon(
          AssetImage("assets/muscleup_drawing.png"),
          color: Colors.black,
        ),
      ),
    );
  }

  void handleCreateJam(BuildContext context) async {
    // // get user communitys
    // UserCommunitiesProvider userCommunitiesProvider =
    //     Provider.of<UserCommunitiesProvider>(context, listen: false);

    // get the databaseservice of the user
    final user = Provider.of<UserProvider>(context, listen: false);
    final dataBaseService = DataBaseService(uid: user.activeUser!.uid);

    // get user community by the cid
    dataBaseService.get



    Map communityMap = userCommunitiesProvider.userCommunityMaps
        .firstWhere((element) => element["community_id"] == cId);
    Timestamp lastJamCreatedAt = communityMap["last_created_jam_at"];
    DateTime lastJamCreatedAtDate = lastJamCreatedAt.toDate();

    // check if user can create new jam
    int daysSinceLastCreated =
        DateTime.now().difference(lastJamCreatedAtDate).inDays;

    if (daysSinceLastCreated > DAYS_UNTIL_CREATE_NEXT_JAM) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateJam(
                  cid: cId,
                )),
      );
    } else {
      Fluttertoast.showToast(
          msg:
              "You can create another jam in ${DAYS_UNTIL_CREATE_NEXT_JAM - daysSinceLastCreated} days",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
  }
}
