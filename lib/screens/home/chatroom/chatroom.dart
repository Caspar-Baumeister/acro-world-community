import 'package:acroworld/data.dart';
import 'package:acroworld/graphql/model/community_messages/community_message.dart';
import 'package:acroworld/graphql/model/community_messages/community_messages.dart';
import 'package:acroworld/graphql/model/user/user.dart';
import 'package:acroworld/graphql/subscriptions.dart';
import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/chatroom/app_bar_chatroom.dart';
import 'package:acroworld/screens/home/chatroom/message_list.dart';
import 'package:acroworld/screens/home/chatroom/message_text_field.dart';
import 'package:acroworld/screens/home/chatroom/message_tile.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class Chatroom extends StatelessWidget {
  const Chatroom({required this.cId, required this.name, Key? key})
      : super(key: key);

  final String cId;
  final String name;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final Map<String, dynamic>? parsedJwt = userProvider.parsedJwt;

    print('userProvider.parsedJwt');
    print(userProvider.parsedJwt);

    final String userId = parsedJwt!['sub'];
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

                  CommunityMessages messages =
                      CommunityMessages.fromJson(result.data!);

                  int messageCount = messages.length;
                  if (messageCount == 0) {
                    return const Center(
                      child: Text('No messages yet'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: messageCount,
                      itemBuilder: (context, index) {
                        CommunityMessage? message = messages[index];
                        CommunityMessage? nextMessage = messages[index + 1];
                        CommunityMessage? previousMessage = messages[index - 1];
                        print(index);
                        print(message);
                        User? fromUser = message!.fromUser;

                        final isMe = userId == fromUser!.id;
                        final isSameAuthorThenNext = nextMessage != null &&
                            nextMessage.fromUser == message.fromUser;
                        final isSameAuthorThenPrevious =
                            previousMessage != null &&
                                previousMessage.fromUser == message.fromUser;

                        return MessageTile(
                            message: Message(
                                cid: message.id!,
                                uid: fromUser.id!,
                                text: message.content!,
                                imgUrl: MORTY_IMG_URL,
                                createdAt: Timestamp.fromDate(
                                    DateTime.parse(message.createdAt!)),
                                userName: fromUser.name!),
                            isMe: isMe,
                            sameAuthorThenNext: isSameAuthorThenNext,
                            sameAuthorThenBevor: isSameAuthorThenPrevious);
                      },
                    );
                  }
                },
              ),
            ),
            MessageTextField(cId: cId)
          ],
        ),
      ),
    );
  }
}
