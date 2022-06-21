import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/jam_overview/jam_overview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JamTile extends StatelessWidget {
  const JamTile({required this.jam, required this.cid, Key? key})
      : super(key: key);

  final Jam jam;
  final String cid;

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context, listen: false).getId();
    print("uid: $uid");
    print(jam.participants);
    bool paticipate = jam.participants.contains(uid);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => JamOverview(
                  jam: jam,
                  cid: cid,
                )),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300.0),
        child: Card(
          color: paticipate ? Colors.green : Colors.white,
          child: ListTile(
            title: Text(jam.name),
            subtitle: Text(DateFormat('kk:mm').format(jam.date)),
            // Text(timeago.format(jam.date, allowFromNow: true),
            //     locale: const Locale('de', 'DE')),
            trailing:
                Text(jam.participants.length.toString() + " participants"),
          ),
        ),
      ),
    );
  }
}
