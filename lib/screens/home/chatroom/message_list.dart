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
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final Message message = messages[index];
        final Message? bevorMessage = (index > 0) ? messages[index - 1] : null;
        final Message? nextMessage =
            (index < messages.length - 1) ? messages[index + 1] : null;
        var sameAuthorThenNext = false;
        var sameAuthorThenBevor = false;
        if (bevorMessage != null) {
          if (message.uid == bevorMessage.uid) {
            sameAuthorThenBevor = true;
          }
        }
        if (nextMessage != null) {
          if (message.uid == nextMessage.uid) {
            sameAuthorThenNext = true;
          }
        }
        return MessageTile(
            message: message,
            isMe: message.uid == uid,
            sameAuthorThenNext: sameAuthorThenNext,
            sameAuthorThenBevor: sameAuthorThenBevor);
      },
      reverse: true,
      itemCount: messages.length,
      physics: const BouncingScrollPhysics(),
    );
  }
}
