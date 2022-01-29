import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
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
    UserModel user = Provider.of<UserProvider>(context).activeUser!;
    bool userParticipates = widget.jam.participants.contains(user.uid);
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        widget.jam.date.microsecondsSinceEpoch);
    String dateString = DateFormat('yyyy.MM.dd – kk:mm').format(date);
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text(
                widget.jam.name,
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: userParticipates ? Colors.black54 : Colors.black,
                  ),
                  label: Text(
                    userParticipates ? 'exit' : 'apply',
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () => onChangeParticipation(userParticipates),
                ),
              ],
            ),

            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(14.0, 0, 0.0, 8.0),
                      child: Text("Place",
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
                      constraints: const BoxConstraints(maxWidth: 250),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                widget.jam.location,
                                style: const TextStyle(
                                    color: Color(0xFFA4A4A4), fontSize: 16.0),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () =>
                                  MapsLauncher.launchQuery(widget.jam.location),
                              icon: const Icon(Icons.location_on)),
                        ],
                      ),
                    ),
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
                      constraints: const BoxConstraints(maxWidth: 250),
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
                      constraints: const BoxConstraints(maxWidth: 250),
                      alignment: Alignment.center,
                      child: Text(
                        widget.jam.info,
                        maxLines: 10,
                        style: const TextStyle(
                            color: Color(0xFFA4A4A4), fontSize: 16.0),
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

    // creates a new jam object
    DataBaseService(uid: user.uid).updateJamField(
        jid: widget.jam.jid,
        cid: widget.cid,
        field: "participants",
        value: participants);
    // redirects to jams

    setState(() {
      loading = false;
    });

    // error handling
  }
}
