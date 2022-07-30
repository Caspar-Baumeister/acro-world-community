import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/jam_overview/jam_overview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JamTile extends StatelessWidget {
  const JamTile(
      {required this.jam, required this.cid, this.communityName, Key? key})
      : super(key: key);

  final Jam jam;
  final String cid;
  final String? communityName;

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context, listen: false).getId();
    List<String> uids = jam.participants.map((e) => e.id!).toList();
    bool paticipate = uids.contains(uid);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => JamOverview(
                  jam: jam,
                  cid: cid,
                )),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            color: paticipate ? Colors.green : Colors.grey,
            width: 2.0,
          ),
        ),
        constraints: const BoxConstraints(maxWidth: 300.0),
        child: ListTile(
          title: Text(jam.name),
          subtitle: Text(DateFormat('kk:mm').format(jam.date)),
          // Text(timeago.format(jam.date, allowFromNow: true),
          //     locale: const Locale('de', 'DE')),
          trailing: communityName != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(communityName!),
                    const SizedBox(height: 3),
                    Text(
                      jam.participants.length.toString() + " participants",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              : Text(jam.participants.length.toString() + " participants"),
        ),
      ),
    );
  }
}
