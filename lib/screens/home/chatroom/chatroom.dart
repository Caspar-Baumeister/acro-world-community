import 'package:acroworld/graphql/model/community_messages/community_message.dart';
import 'package:acroworld/graphql/model/community_messages/community_messages.dart';
import 'package:acroworld/graphql/model/user/user.dart';
import 'package:acroworld/graphql/subscriptions.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/chatroom/app_bar_chatroom.dart';
import 'package:acroworld/screens/home/chatroom/message_text_field.dart';
import 'package:acroworld/screens/home/chatroom/message_tile.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Chatroom extends StatelessWidget {
  const Chatroom(
      {required this.cId,
      required this.name,
      Key? key,
      required this.community})
      : super(key: key);

  final String cId;
  final String name;
  final Community community;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    final String userId = userProvider.activeUser!.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarChatroom(cId: cId, community: community, name: name),
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
                      reverse: true,
                      itemCount: messageCount,
                      itemBuilder: (context, index) {
                        CommunityMessage? message = messages[index];
                        CommunityMessage? nextMessage = messages[index + 1];
                        CommunityMessage? previousMessage = messages[index - 1];
                        User? fromUser = message!.fromUser;
                        var isSameDayAsPrevious = isSameDay(
                            message.createdAt, nextMessage?.createdAt);
                        final isMe = userId == fromUser!.id;

                        final isSameAuthorThenNext = nextMessage != null &&
                            nextMessage.fromUser!.id == message.fromUser!.id;

                        final isSameAuthorThenPrevious =
                            previousMessage != null &&
                                previousMessage.fromUser!.id ==
                                    message.fromUser!.id;
                        if (!isSameDayAsPrevious) {
                          return Column(
                            children: [
                              Center(
                                  child: Text(DateFormat.EEEE().format(
                                      DateTime.parse(message.createdAt!)))),
                              MessageTile(
                                  message: Message(
                                      cid: message.id!,
                                      uid: fromUser.id!,
                                      text: message.content!,
                                      imgUrl: MORTY_IMG_URL,
                                      createdAt: message.createdAt!,
                                      userName: fromUser.name!),
                                  isMe: isMe,
                                  sameAuthorThenNext: isSameAuthorThenNext,
                                  sameAuthorThenBevor: isSameAuthorThenPrevious)
                            ],
                          );
                        }

                        return MessageTile(
                          message: Message(
                              cid: message.id!,
                              uid: fromUser.id!,
                              text: message.content!,
                              imgUrl: MORTY_IMG_URL,
                              createdAt: message.createdAt!,
                              userName: fromUser.name!),
                          isMe: isMe,
                          sameAuthorThenNext: isSameAuthorThenNext,
                          sameAuthorThenBevor: isSameAuthorThenPrevious,
                        );
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

  bool isSameDay(String? t1, String? t2) {
    if (t1 == null || t2 == null) {
      return false;
    }
    return DateTime.parse(t1).day == DateTime.parse(t2).day;
  }
}
