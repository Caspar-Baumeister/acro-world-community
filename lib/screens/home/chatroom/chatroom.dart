import 'package:acroworld/screens/home/chatroom/message_text_field.dart';
import 'package:acroworld/screens/home/chatroom/messages_stream.dart';
import 'package:acroworld/screens/home/jams/jams.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatelessWidget {
  const Chatroom({required this.cId, Key? key}) : super(key: key);

  final String cId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(cId, style: const TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.black),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Jams(
                          cId: cId,
                        )),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(
                  'Jams',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                ImageIcon(
                  AssetImage("assets/acro_jam_icon.png"),
                  color: Colors.black,
                )
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: MessagesStream(cid: cId),
            ),
          ),
          MessageTextField(cId: cId)
        ],
      ),
    );
  }
}
