import 'package:acroworld/screens/home/jams/create_jam.dart';
import 'package:acroworld/screens/home/jams/jam_stream.dart';
import 'package:flutter/material.dart';

class Jams extends StatelessWidget {
  const Jams({required this.cId, Key? key}) : super(key: key);

  final String cId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: Text("Jams of $cId"),
        leading: const BackButton(color: Colors.white),
      ),
      body: JamsStream(cid: cId),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateJam(
                    cid: cId,
                  )),
        );
      }),
    );
  }
}
