import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/jam/jam_overview/jam_overview.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class JamTile extends StatelessWidget {
  const JamTile({required this.jam, required this.cid, Key? key})
      : super(key: key);

  final Jam jam;
  final String cid;

  @override
  Widget build(BuildContext context) {
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
          child: ListTile(
            title: Text(jam.name),
            subtitle: Text(timeago.format(jam.date, allowFromNow: true),
                locale: const Locale('de', 'DE')),
            trailing:
                Text(jam.participants.length.toString() + " participants"),
          ),
        ),
      ),
    );
  }
}
