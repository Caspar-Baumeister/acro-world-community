import 'package:acroworld/data.dart';
import 'package:acroworld/screens/home/chatroom/app_bar_chatroom.dart';
import 'package:acroworld/screens/home/chatroom/message_list.dart';
import 'package:acroworld/screens/home/chatroom/message_text_field.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatelessWidget {
  const Chatroom({required this.cId, required this.name, Key? key})
      : super(key: key);

  final String cId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarChatroom(cId: cId, name: name),
      body: ViewRoot(
        child: Column(
          children: [
            Expanded(
              child: MessageList(messages: DataClass().messages, uid: "user"),
            ),
            MessageTextField(cId: cId)
          ],
        ),
      ),
    );
  }
}
