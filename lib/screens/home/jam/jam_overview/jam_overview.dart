import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/jam_overview/app_bar_jam_overview.dart';
import 'package:acroworld/screens/home/jam/jam_overview/body_jam_overview.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
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
        body: loading
            ? const Loading()
            : JamOverviewBody(jam: widget.jam, cid: widget.cid)

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
