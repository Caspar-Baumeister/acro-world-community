import 'package:acroworld/screens/home/chatroom/message_text_field.dart';
import 'package:acroworld/screens/home/chatroom/messages_stream.dart';
import 'package:acroworld/screens/home/jams/jam_stream.dart';
import 'package:acroworld/screens/home/jams/jams.dart';
import 'package:acroworld/screens/home/jams/jams_list.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatelessWidget {
  const Chatroom({required this.cId, Key? key}) : super(key: key);

  final String cId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: Text(cId),
        leading: BackButton(color: Colors.white),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.transparent),
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
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
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
