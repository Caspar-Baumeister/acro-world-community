import 'package:acroworld/screens/home/chatroom/app_bar_chatroom.dart';
import 'package:acroworld/screens/home/chatroom/message_text_field.dart';
import 'package:acroworld/screens/home/chatroom/messages_stream.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatelessWidget {
  const Chatroom({required this.cId, Key? key}) : super(key: key);

  final String cId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarChatroom(cId: cId),
      body: ViewRoot(
        child: Column(
          children: [
            Expanded(
              child: MessagesStream(cid: cId),
            ),
            MessageTextField(cId: cId)
          ],
        ),
      ),
    );
  }
}
