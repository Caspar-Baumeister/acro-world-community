import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/jam/jam_overview/jam_overview.dart';
import 'package:flutter/material.dart';

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
      child: ListTile(
        title: Text(jam.name),
        subtitle: Text(jam.date),
        trailing: Text(jam.participants.length.toString() + " participants"),
      ),
    );
  }
}
