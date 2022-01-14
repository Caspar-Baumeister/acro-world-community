import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/screens/home/chatroom/message_tile.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    Key? key,
    required this.messages,
    required this.uid,
  }) : super(key: key);

  final List<Message> messages;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageTile(message: message, isMe: message.uid == uid);
      },
      reverse: true,
      itemCount: messages.length,
      physics: const BouncingScrollPhysics(),
    );
  }
}
