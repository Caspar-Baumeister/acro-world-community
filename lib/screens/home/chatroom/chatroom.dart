import 'package:acroworld/data.dart';
import 'package:acroworld/graphql/subscriptions.dart';
import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/screens/home/chatroom/app_bar_chatroom.dart';
import 'package:acroworld/screens/home/chatroom/message_list.dart';
import 'package:acroworld/screens/home/chatroom/message_text_field.dart';
import 'package:acroworld/screens/home/chatroom/message_tile.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
              child: Subscription(
                options: SubscriptionOptions(
                    document: gql(
                      Subscriptions.communityMessages,
                    ),
                    variables: {'community_id': cId}),
                builder: (result) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  int messageCount = result.data!['community_messages'].length;
                  if (messageCount == 0) {
                    return const Center(
                      child: Text('No messages yet'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: result.data!['community_messages'].length,
                      itemBuilder: (context, index) {
                        dynamic message =
                            result.data!['community_messages'][index];
                        dynamic fromUser = message['from_user'];
                        print(message);
                        return MessageTile(
                            message: Message(
                                text: message['content'],
                                cid: message['id'],
                                uid: fromUser['id'],
                                imgUrl: fromUser['image_url'] ?? '',
                                createdAt: Timestamp.fromDate(
                                    DateTime.parse(message['created_at'])),
                                userName: fromUser['name']),
                            isMe: false,
                            sameAuthorThenNext: false,
                            sameAuthorThenBevor: false);
                        // return Card(
                        //   child: ListTile(
                        //     title: Text(message['content']),
                        //   ),
                        // );
                      },
                    );
                  }
                },
              ),
              // child: MessageList(messages: DataClass().messages, uid: "user"),
            ),
            MessageTextField(cId: cId)
          ],
        ),
      ),
    );
  }
}
