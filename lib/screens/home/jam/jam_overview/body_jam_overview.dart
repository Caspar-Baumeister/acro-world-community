import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/jam/jam_overview/participant_modal.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class JamOverviewBody extends StatelessWidget {
  const JamOverviewBody({required this.jam, required this.cid, Key? key})
      : super(key: key);
  final Jam jam;
  final String cid;

  @override
  Widget build(BuildContext context) {
    //UserModel? user = Provider.of<UserProvider>(context).activeUser;

    //bool userParticipates = widget.jam.participants.contains(user.uid);
    String timeString = timeago.format(jam.date);
    // DateTime.fromMicrosecondsSinceEpoch(jam.date.microsecondsSinceEpoch);
    String dateString =
        DateFormat('EEEE – kk:mm – dd-MM-yyyy').format(jam.date);
    //bool userPressed = widget.jam.participants.contains(user.uid);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.fromLTRB(14.0, 0, 0.0, 8.0),
              child: Text("Date",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      fontFamily: "rubik")),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              // decoration: BoxDecoration(
              //     border: Border.all(
              //       width: 1,
              //       color: Colors.grey,
              //     ),
              // borderRadius: const BorderRadius.all(Radius.circular(30))),
              alignment: Alignment.centerLeft,
              child: Text(
                dateString,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.fromLTRB(14.0, 0, 0.0, 8.0),
              child: Text("Information",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      fontFamily: "rubik")),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              // decoration: BoxDecoration(
              //     border: Border.all(
              //       width: 1,
              //       color: Colors.grey,
              //     ),
              //     borderRadius: const BorderRadius.all(Radius.circular(30))),
              alignment: Alignment.centerLeft,
              child: Text(
                jam.info ?? "",
                maxLines: 10,
                style:
                    const TextStyle(color: Color(0xFFA4A4A4), fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    onPressed: () => buildMortal(context,
                        ParticipantModal(participants: jam.participants)),
                    child: Text(
                      "${jam.participants.length.toString()} participants",
                      maxLines: 10,
                      style: const TextStyle(
                          fontSize: 16.0, color: Colors.black54),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    onPressed: () => participate(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          "participate",
                          maxLines: 10,
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // GestureDetector(
            //   onTap: () => buildMortal(
            //       context, ParticipantModal(participants: jam.participants)),
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //         vertical: 12.0, horizontal: 12.0),
            //     decoration: BoxDecoration(
            //         border: Border.all(
            //           width: 1,
            //           color: Colors.grey,
            //         ),
            //         borderRadius: const BorderRadius.all(Radius.circular(30))),
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Show ${jam.participants.length.toString()} participants",
            //       maxLines: 10,
            //       style:
            //           const TextStyle(color: Color(0xFFA4A4A4), fontSize: 16.0),
            //     ),
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              constraints: const BoxConstraints(maxHeight: 350),
              child: MapWidget(
                center: jam.latLng,
                markerLocation: jam.latLng,
              ),
            ),
            // Button open participant list
          ],
        ),
      ),
    );
  }

  Future participate(BuildContext context) async {
    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).validToken();
    if (!isValidToken) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const Authenticate())));
      return null;
    }
    String token = Provider.of<UserProvider>(context, listen: false).token!;
    String uid = Provider.of<UserProvider>(context, listen: false).getId();
    final database = Database(token: token);
    final response = await database.participateToJam(uid, jam.jid);
    print(response);
  }
}
