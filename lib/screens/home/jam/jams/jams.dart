import 'package:acroworld/screens/home/jam/create_jam/create_jam.dart';
import 'package:acroworld/screens/home/jam/jams/app_bar_jams.dart';
import 'package:acroworld/screens/home/jam/jams/future_jams.dart';
import 'package:flutter/material.dart';

// Here are all jams of that community imported
// getComms(cid) => List<Map<String, dynamic>> List<communityJson>

class Jams extends StatelessWidget {
  const Jams({required this.cId, required this.name, Key? key})
      : super(key: key);

  final String cId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarJams(name: name),
        floatingActionButton: GestureDetector(
          onTap: () => handleCreateJam(context),
          child: Container(
            width: 80,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("New"),
                SizedBox(width: 6),
                ImageIcon(
                  AssetImage("assets/muscleup_drawing.png"),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        body: FutureJams(cId: cId) //JamsBody(cId: cId), //JamsStream(cid: cId),
        );
  }

  void handleCreateJam(BuildContext context) async {
    // // get user communitys
    // UserCommunitiesProvider userCommunitiesProvider =
    //     Provider.of<UserCommunitiesProvider>(context, listen: false);

    // // get the databaseservice of the user
    // final user = Provider.of<UserProvider>(context, listen: false);
    // final dataBaseService = DataBaseService(uid: user.activeUser!.uid);

    // final lastCreated = await dataBaseService.getLastCreatedJamAt(cId);
    // final date = lastCreated.get("last_created_jam_at");

    // get user community by the cid

    //   Map communityMap = userCommunitiesProvider.userCommunityMaps
    //       .firstWhere((element) => element["community_id"] == cId);
    //   Timestamp lastJamCreatedAt = communityMap["last_created_jam_at"];
    //   DateTime lastJamCreatedAtDate = lastJamCreatedAt.toDate();

    //   // check if user can create new jam
    //   int daysSinceLastCreated =
    //       DateTime.now().difference(lastJamCreatedAtDate).inDays;

    //   if (daysSinceLastCreated > DAYS_UNTIL_CREATE_NEXT_JAM) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateJam(
                cid: cId,
              )),
    );
    //   } else {
    //     Fluttertoast.showToast(
    //         msg:
    //             "You can create another jam in ${DAYS_UNTIL_CREATE_NEXT_JAM - daysSinceLastCreated} days",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM_LEFT,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.red,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //     return;
    //   }
    // }
  }
}
