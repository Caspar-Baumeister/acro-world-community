import 'package:acroworld/data.dart';
import 'package:acroworld/graphql/subscriptions.dart';
import 'package:acroworld/screens/home/chatroom/app_bar_chatroom.dart';
import 'package:acroworld/screens/home/chatroom/message_list.dart';
import 'package:acroworld/screens/home/chatroom/message_text_field.dart';
import 'package:acroworld/widgets/view_root.dart';
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

                  print(result.data!['community_messages'][0]['content']
                      as String);

                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(result.data!['community_messages']
                                [index]['content']),
                          ),
                        );
                      },
                    ),
                  );
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
