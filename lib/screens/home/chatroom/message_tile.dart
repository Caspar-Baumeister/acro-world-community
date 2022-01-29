import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/screens/home/profile/profile.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Let the messagetile fetch the user data from the user id (dont safe other things then message and uid in the message, created at)

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
    const double imgRadius = 20;
    if (!isMe && !sameAuthorThenBevor) {
      return FutureBuilder(
        future: DataBaseService(uid: message.uid).getProfileImage(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.grey[200],
            ));
          } else {
            if (snapshot.hasError) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              uid: message.uid,
                            )),
                  );
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: const CircleAvatar(
                    radius: imgRadius,
                    backgroundImage: NetworkImage(MORTY_IMG_URL),
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              uid: message.uid,
                            )),
                  );
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: imgRadius,
                    backgroundImage:
                        NetworkImage(snapshot.data ?? MORTY_IMG_URL),
                  ),
                ),
              );
            }
          }
        },
      );
    } else if (!isMe && sameAuthorThenBevor) {
      return const SizedBox(
        width: imgRadius * 2,
      );
    } else {
      return Container();
    }
  }

  Widget buildMessage(BuildContext context) => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          (isMe || sameAuthorThenNext)
              ? const SizedBox(
                  width: 0,
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                uid: message.uid,
                              )),
                    );
                  },
                  child: Text(
                    message.userName,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                    //textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ),
          Text(
            message.text,
            textWidthBasis: TextWidthBasis.longestLine,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          )
        ],
      );
}
