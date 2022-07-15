import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/jam/create_jam/create_jam.dart';
import 'package:acroworld/screens/home/jam/jams/app_bar_jams.dart';
import 'package:acroworld/screens/home/jam/jams/future_jams.dart';
import 'package:flutter/material.dart';

class Jams extends StatefulWidget {
  const Jams(
      {required this.cId,
      required this.name,
      Key? key,
      required this.community})
      : super(key: key);

  final String cId;
  final String name;
  final Community community;

  @override
  State<Jams> createState() => _JamsState();
}

class _JamsState extends State<Jams> {
  // define state here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarJams(name: widget.name),
        floatingActionButton: floatingActionButton(context),
        body: FutureJams(cId: widget.cId));
  }

  GestureDetector floatingActionButton(BuildContext context) {
    return GestureDetector(
      onTap: () => handleCreateJam(context),
      child: Container(
        width: 86,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 6),
            Text(
              "New",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(width: 6),
            ImageIcon(
              AssetImage("assets/muscleup_drawing.png"),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void handleCreateJam(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CreateJam(cid: widget.cId, community: widget.community)),
    );
  }
}
