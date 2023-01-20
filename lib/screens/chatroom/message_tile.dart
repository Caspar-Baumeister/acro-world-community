import 'package:acroworld/models/community_messages/community_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Let the messagetile fetch the user data from the user id (dont safe other things then message and uid in the message, created at)

class MessageTile extends StatelessWidget {
  const MessageTile(
      {required this.sameAuthorThenNext,
      required this.sameAuthorThenBevor,
      required this.message,
      required this.isMe,
      Key? key})
      : super(key: key);

  final CommunityMessage message;
  final bool isMe;
  final bool sameAuthorThenBevor;
  final bool sameAuthorThenNext;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(12.0);
    const borderRadius = BorderRadius.all(radius);
    // The row spans over the full display width and either puts the child to the left or the right
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            // Space between content and border of frame
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            // space between whole messages
            margin: EdgeInsets.only(bottom: sameAuthorThenBevor ? 2.0 : 10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[200]!,
              ),
              color: isMe ? Colors.grey[200] : Colors.white,
              borderRadius: isMe
                  ? borderRadius
                      .subtract(const BorderRadius.only(bottomRight: radius))
                  : sameAuthorThenNext
                      ? borderRadius
                      : borderRadius.subtract(
                          const BorderRadius.only(bottomLeft: radius)),
            ),
            //alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: buildMessage(context))
      ],
    );
  }

  Widget buildMessage(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              (isMe || sameAuthorThenNext)
                  ? const SizedBox(
                      width: 0,
                    )
                  : Text(
                      message.fromUser?.name ?? "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                      //textAlign: isMe ? TextAlign.end : TextAlign.start,
                    ),
              Container(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: Text(
                  message.content ?? "",
                  //textWidthBasis: TextWidthBasis.longestLine,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              message.createdAt != null
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateFormat.Hm().format(
                            DateTime.parse(message.createdAt!).toLocal()),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ))
                  : Container()
            ],
          ),
        ],
      );
}
