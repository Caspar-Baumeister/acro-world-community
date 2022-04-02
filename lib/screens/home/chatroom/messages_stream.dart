import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/chatroom/message_list.dart';
import 'package:acroworld/services/auth.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// provides a stream that fetches all messages for a specific community id (uid) from firebase
class MessagesStream extends StatelessWidget {
  const MessagesStream({required this.cid, Key? key}) : super(key: key);
  final String cid;
  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserProvider>(context).activeUser == null) {
      AuthService().signOut();
    }
    String uid = Provider.of<UserProvider>(context).activeUser!.uid;

    return StreamBuilder<QuerySnapshot>(
        stream: DataBaseService(uid: uid).getMessages(cid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          // snapshot.connectionstate is done or none. try to create Message widgets
          try {
            List<Message> messages = snapshot.data!.docs.map((e) {
              return Message.fromJson(e.data(), cid);
            }).toList();

            if (messages.isEmpty) {
              return buildText("A beautiful new community");
            }

            // snapshot arrived and messages exist
            return MessageList(messages: messages, uid: uid);
          } catch (e) {
            // ignore: avoid_print
            print(
                "MessageWidget: couldnt translate snapshot into message widgets with error: ${e.toString()}");
            return Center(
              child: Text(e.toString()),
            );
          }
        });
  }

  buildText(String text) {
    return Center(
      child: Text(text),
    );
  }
}
