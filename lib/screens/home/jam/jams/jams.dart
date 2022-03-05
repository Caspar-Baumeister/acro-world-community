import 'package:acroworld/screens/home/jam/jams/jam_stream.dart';
import 'package:acroworld/screens/home/jam/jams/app_bar_jams.dart';
import 'package:flutter/material.dart';

class Jams extends StatelessWidget {
  const Jams({required this.cId, Key? key}) : super(key: key);

  final String cId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarJams(cId: cId),
      body: JamsStream(cid: cId),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.black,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => CreateJam(
      //                 cid: cId,
      //               )),
      //     );
      //   },
      //   child: const ImageIcon(
      //     AssetImage("assets/acro_jam_icon.png"),
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
