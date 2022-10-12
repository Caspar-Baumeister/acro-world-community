// main.dart
import 'package:acroworld/models/community_messages/community_message.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

//  Received message bubble
class InBubble extends StatelessWidget {
  final CommunityMessage message;
  final bool sameAuthorThenBevor;
  final bool sameAuthorThenNext;
  const InBubble(
      {Key? key,
      required this.message,
      required this.sameAuthorThenBevor,
      required this.sameAuthorThenNext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomPaint(
            painter: Triangle(Colors.grey.shade200),
          ),
        ),
        Flexible(
          child: Stack(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.all(12),
                margin:
                    EdgeInsets.only(bottom: sameAuthorThenBevor ? 1.0 : 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(19),
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sameAuthorThenNext
                        ? const SizedBox(
                            width: 0,
                          )
                        : SelectableText(
                            message.fromUser?.name ?? "",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
                            //textAlign: isMe ? TextAlign.end : TextAlign.start,
                          ),
                    RichText(
                      text: TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Clipboard.setData(
                                ClipboardData(text: message.content));
                            Fluttertoast.showToast(
                                msg: "Text copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                        text: message.content,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                        children: const <TextSpan>[
                          TextSpan(
                              text: '       .',
                              style: TextStyle(
                                  color: Colors.transparent, height: 0.55)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 11,
                right: 11,
                child: message.createdAt != null
                    ? Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat.Hm().format(
                              DateTime.parse(message.createdAt!).toLocal()),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10),
                        ))
                    : Container(),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// Sent message bubble
class OutBubble extends StatelessWidget {
  final CommunityMessage message;
  final bool sameAuthorThenBevor;
  const OutBubble(
      {Key? key, required this.message, required this.sameAuthorThenBevor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Stack(
            // alignment: AlignmentDirectional.bottomEnd,
            children: [
              Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.all(12),
                  margin:
                      EdgeInsets.only(bottom: sameAuthorThenBevor ? 1.0 : 5.0),
                  decoration: const BoxDecoration(
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19),
                      bottomLeft: Radius.circular(19),
                      bottomRight: Radius.circular(19),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Clipboard.setData(
                              ClipboardData(text: message.content));
                          Fluttertoast.showToast(
                              msg: "Text copied",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                      text: message.content,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      children: const <TextSpan>[
                        TextSpan(
                            text: '       .',
                            style: TextStyle(
                                color: Colors.transparent, height: 0.55)),
                      ],
                    ),
                  )
                  // Text(
                  //   message.content! + "          ",
                  //   style: const TextStyle(color: Colors.white, fontSize: 15),
                  // ),
                  ),
              Positioned(
                bottom: 11,
                right: 11,
                child: message.createdAt != null
                    ? Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat.Hm().format(
                              DateTime.parse(message.createdAt!).toLocal()),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10),
                        ))
                    : Container(),
              )
            ],
          ),
        ),
        CustomPaint(painter: Triangle(Colors.indigo.shade600)),
      ],
    );
  }
}

// Create a custom triangle
class Triangle extends CustomPainter {
  final Color backgroundColor;
  Triangle(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
