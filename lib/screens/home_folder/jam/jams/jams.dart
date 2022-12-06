import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/create_jam/create_jam.dart';
import 'package:acroworld/screens/home_folder/jam/jams/app_bar_jams.dart';
import 'package:acroworld/screens/home_folder/jam/jams/future_jams.dart';
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

  Widget floatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () => handleCreateJam(context),
        child: const Text(
          "Plan a jam",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
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
