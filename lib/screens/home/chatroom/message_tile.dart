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
    //double messageWidth = MediaQuery.of(context).size.width * 0.8;
    const radius = Radius.circular(12.0);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        leadingDecide(),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            // this is the padding of the message tile:
            margin: EdgeInsets.only(bottom: sameAuthorThenBevor ? 2.0 : 10.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
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

  Widget leadingDecide() {
    return Container();
  }

  Widget buildMessage(BuildContext context) => Column(
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.content ?? "",
                textWidthBasis: TextWidthBasis.longestLine,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
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
          )
        ],
      );
}
