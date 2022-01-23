import 'package:acroworld/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(
      {required this.sameAuthorThenNext,
      required this.sameAuthorThenBevor,
      required this.message,
      required this.isMe,
      Key? key})
      : super(key: key);

  final Message message;
  final bool isMe;
  final bool sameAuthorThenBevor;
  final bool sameAuthorThenNext;
  @override
  Widget build(BuildContext context) {
    //double messageWidth = MediaQuery.of(context).size.width * 0.8;
    const radius = Radius.circular(12.0);
    const borderRadius = BorderRadius.all(radius);
    return Row(
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
            child: buildMessage())
      ],
    );
  }

  Widget leadingDecide() {
    final double imgRadius = 20;
    if (!isMe && !sameAuthorThenBevor) {
      return Container(
        alignment: Alignment.bottomCenter,
        child: CircleAvatar(
          radius: imgRadius,
          backgroundImage: NetworkImage(message.imgUrl),
        ),
      );
    } else if (!isMe && sameAuthorThenBevor) {
      return SizedBox(
        width: imgRadius * 2,
      );
    } else {
      return Container();
    }
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          (isMe || sameAuthorThenNext)
              ? SizedBox(
                  width: 0,
                )
              : Text(
                  message.userName,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800),
                  //textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
          Text(
            message.text,
            textWidthBasis: TextWidthBasis.longestLine,
            style: const TextStyle(
              color: Colors.black,
            ),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          )
        ],
      );
}
