import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({required this.message, required this.isMe, Key? key})
      : super(key: key);

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(12.0);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(MORTY_IMG_URL),
          ),
        Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 140),
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[500] : Colors.grey[50],
              borderRadius: isMe
                  ? borderRadius
                      .subtract(const BorderRadius.only(bottomRight: radius))
                  : borderRadius
                      .subtract(const BorderRadius.only(bottomLeft: radius)),
            ),
            child: buildMessage()),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.userName,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.black54,
            ),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
          Text(
            message.text,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.black54,
            ),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          )
        ],
      );
}
