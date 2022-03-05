import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/jams/jams_list.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// provides a stream that fetches all jams for a specific community id (uid) from firebase
class JamsStream extends StatelessWidget {
  const JamsStream({required this.cid, Key? key}) : super(key: key);
  final String cid;
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context).activeUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: DataBaseService(uid: uid).getJams(cid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        // snapshot.connectionstate is done or none. try to create Jam widgets
        try {
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return buildText("There are no jams jet");
          }
          List<Jam> jams = snapshot.data!.docs.map((e) {
            return Jam.fromJson(e.data(), e.id);
          }).toList();

          // snapshot arrived and jams exist
          return JamsList(jams: jams, cid: cid);
        } catch (e) {
          // ignore: avoid_print
          print(
              "JamStream: couldnt translate snapshot into jam widgets with error: ${e.toString()}");
          return Center(
            child: Text(e.toString()),
          );
        }
      },
    );
  }

  buildText(String text) {
    return Center(
      child: Text(text),
    );
  }
}
