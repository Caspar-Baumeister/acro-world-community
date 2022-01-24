import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

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
    bool userPressed = widget.jam.participants.contains(user.uid);
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
                    color: userPressed ? Colors.black54 : Colors.black,
                  ),
                  label: Text(
                    userPressed ? 'exit' : 'apply',
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () => userPressed ? null : onParticipate(),
                ),
              ],
            ),
            body: Column(
              children: [
                Text(widget.jam.createdBy),
                Text(widget.jam.date),
                IconButton(
                    onPressed: () =>
                        MapsLauncher.launchQuery(widget.jam.location),
                    icon: const Icon(Icons.location_on)),
                Text(widget.jam.location),
                ...widget.jam.participants.map((e) => Text(e))
                // ListView(
                //     children: List<ListTile>.from(widget.jam.participants
                //         .map((e) => ListTile(title: Text(e)))))
              ],
            ),
          );
  }

  void onParticipate() async {
    setState(() {
      loading = true;
    });

    // get activ user to safe the id
    UserModel user =
        Provider.of<UserProvider>(context, listen: false).activeUser!;

    List<String> participants = widget.jam.participants;
    participants.add(user.uid);

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
