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
    var now = DateTime.now();
    DateTime date = jam.date.toDate();
    final difference = date.difference(now).inDays;
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
            subtitle: Text("in ${difference.toString()} days"),
            trailing:
                Text(jam.participants.length.toString() + " participants"),
          ),
        ),
      ),
    );
  }
}
