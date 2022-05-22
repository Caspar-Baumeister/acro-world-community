import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/jam_overview/app_bar_jam_overview.dart';
import 'package:acroworld/screens/home/jam/jam_overview/participant_modal.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class JamOverview extends StatefulWidget {
  const JamOverview({required this.jam, required this.cid, Key? key})
      : super(key: key);
  final Jam jam;
  final String cid;

  @override
  State<JamOverview> createState() => _JamOverviewState();
}

class _JamOverviewState extends State<JamOverview> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).activeUser;

    //bool userParticipates = widget.jam.participants.contains(user.uid);
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        widget.jam.date.microsecondsSinceEpoch);
    String dateString = DateFormat('yyyy.MM.dd – kk:mm').format(date);
    //bool userPressed = widget.jam.participants.contains(user.uid);
    return loading
        ? const Loading()
        : Scaffold(
            // floatingActionButton: Builder(
            //   builder: (context) =>
            //   FloatingActionButton(
            //     backgroundColor: Colors.grey,
            //     child: Icon(!userPressed ? Icons.add : Icons.exit_to_app),
            //     onPressed: () => onChangeParticipation(userParticipates),
            //   ),
            // ),
            backgroundColor: Colors.white,
            appBar: AppBarJamOverview(jam: widget.jam),
            body: SingleChildScrollView(
              child: ViewRoot(
                // padding: const EdgeInsets.symmetric(
                //     vertical: 20.0, horizontal: 50.0),
                child: Column(
                  children: <Widget>[
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 12.0, horizontal: 12.0),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //         width: 1,
                    //         color: Colors.grey,
                    //       ),
                    //       borderRadius:
                    //           const BorderRadius.all(Radius.circular(30))),
                    //   constraints: const BoxConstraints(maxWidth: 250),
                    //   alignment: Alignment.center,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Expanded(
                    //         child: Container(
                    //           alignment: Alignment.center,
                    //           child: Text(
                    //             widget.jam.location,
                    //             style: const TextStyle(
                    //                 color: Color(0xFFA4A4A4), fontSize: 16.0),
                    //           ),
                    //         ),
                    //       ),
                    //       IconButton(
                    //           onPressed: () =>
                    //               MapsLauncher.launchQuery(widget.jam.location),
                    //           icon: const Icon(Icons.location_on)),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 20.0),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(14.0, 0, 0.0, 8.0),
                      child: Text("Date",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              fontFamily: "rubik")),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      alignment: Alignment.center,
                      child: Text(
                        dateString,
                        style: const TextStyle(
                            color: Color(0xFFA4A4A4), fontSize: 16.0),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(14.0, 0, 0.0, 8.0),
                      child: Text("Information",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              fontFamily: "rubik")),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      alignment: Alignment.center,
                      child: Text(
                        widget.jam.info,
                        maxLines: 10,
                        style: const TextStyle(
                            color: Color(0xFFA4A4A4), fontSize: 16.0),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(14.0, 0, 0.0, 8.0),
                      child: Text("Participants",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              fontFamily: "rubik")),
                    ),
                    GestureDetector(
                      onTap: () => buildMortal(
                          context,
                          ParticipantModal(
                              participants: widget.jam.participants)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        alignment: Alignment.center,
                        child: Text(
                          "Show ${widget.jam.participants.length.toString()} participants",
                          maxLines: 10,
                          style: const TextStyle(
                              color: Color(0xFFA4A4A4), fontSize: 16.0),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      constraints: const BoxConstraints(maxHeight: 350),
                      child: MapWidget(
                        center: widget.jam.latLng,
                        markerLocation: widget.jam.latLng,
                      ),
                    ),
                    // Button open participant list
                  ],
                ),
              ),
            ),

            // Column(
            //   children: [
            //     Text(widget.jam.createdBy),
            //     Text(widget.jam.date),
            //     IconButton(
            //         onPressed: () =>
            //             MapsLauncher.launchQuery(widget.jam.location),
            //         icon: const Icon(Icons.location_on)),
            //     Text(widget.jam.location),
            //     ...widget.jam.participants.map((e) => Text(e))
            //     // ListView(
            //     //     children: List<ListTile>.from(widget.jam.participants
            //     //         .map((e) => ListTile(title: Text(e)))))
            //   ],
            // ),
          );
  }

  void onChangeParticipation(bool userParticipates) async {
    setState(() {
      loading = true;
    });

    // get activ user to safe the id
    UserModel user =
        Provider.of<UserProvider>(context, listen: false).activeUser!;
    List<String> participants = widget.jam.participants;

    if (userParticipates) {
      participants.remove(user.uid);
    } else {
      participants.add(user.uid);
    }

    // // creates a new jam object
    // DataBaseService(uid: user.uid).updateJamField(
    //     jid: widget.jam.jid,
    //     cid: widget.cid,
    //     field: "participants",
    //     value: participants);
    // // redirects to jams

    setState(() {
      loading = false;
    });

    // error handling
  }
}
