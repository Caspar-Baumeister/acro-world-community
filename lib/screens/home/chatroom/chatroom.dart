import 'package:acroworld/graphql/errors/graphql_error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/community_messages/community_message.dart';
import 'package:acroworld/models/community_messages/community_messages.dart';
import 'package:acroworld/graphql/subscriptions.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/chatroom/app_bar_chatroom.dart';
import 'package:acroworld/screens/home/chatroom/widgets/chat_bubble.dart';
import 'package:acroworld/screens/home/chatroom/widgets/message_text_field.dart';
import 'package:acroworld/widgets/view_root.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Chatroom extends StatefulWidget {
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
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  @override
  void dispose() {
    // TODO update last visited
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    final String userId = userProvider.activeUser!.id!;
    return Mutation(
        options: MutationOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: Mutations.updateLastVisetedAt,
          onError: GraphQLErrorHandler().handleError,
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          return WillPopScope(
            onWillPop: () async {
              var response = runMutation({
                "user_id": userProvider.activeUser!.id!,
                "community_id": widget.cId
              });
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBarChatroom(
                  cId: widget.cId,
                  community: widget.community,
                  name: widget.name,
                  updateLastVisitedAt: () => runMutation({
                        "user_id": userProvider.activeUser!.id!,
                        "community_id": widget.cId
                      })),
              body: ViewRoot(
                child: Column(
                  children: [
                    Expanded(
                      child: Subscription(
                        options: SubscriptionOptions(
                            document: gql(
                              Subscriptions.communityMessages,
                            ),
                            variables: {'community_id': widget.cId}),
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
                            Provider.of<UserCommunitiesProvider>(context,
                                    listen: false)
                                .setLastMessage(messages[0]!, widget.cId);
                            return ListView.builder(
                              reverse: true,
                              itemCount: messageCount,
                              itemBuilder: (context, index) {
                                CommunityMessage? message = messages[index];
                                CommunityMessage? nextMessage =
                                    messages[index + 1];
                                CommunityMessage? previousMessage =
                                    messages[index - 1];
                                User? fromUser = message!.fromUser;
                                var isSameDayAsPrevious = isSameDay(
                                    message.createdAt, nextMessage?.createdAt);
                                final isMe = userId == fromUser!.id;

                                final isSameAuthorThenNext =
                                    nextMessage != null &&
                                        nextMessage.fromUser!.id ==
                                            message.fromUser!.id;

                                final isSameAuthorThenPrevious =
                                    previousMessage != null &&
                                        previousMessage.fromUser!.id ==
                                            message.fromUser!.id;
                                if (!isSameDayAsPrevious) {
                                  return Column(
                                    children: [
                                      Center(
                                          child: Container(
                                        margin: const EdgeInsets.all(6),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30))),
                                        child: Text(DateFormat.EEEE().format(
                                            DateTime.parse(
                                                message.createdAt!))),
                                      )),
                                      isMe
                                          ? OutBubble(
                                              message: message,
                                              sameAuthorThenBevor:
                                                  isSameAuthorThenPrevious,
                                            )
                                          : InBubble(
                                              message: message,
                                              sameAuthorThenBevor:
                                                  isSameAuthorThenPrevious,
                                              sameAuthorThenNext: false,
                                            )
                                      // MessageTile(
                                      //     message: message,
                                      //     isMe: isMe,
                                      //     sameAuthorThenNext:
                                      //         isSameAuthorThenNext,
                                      //     sameAuthorThenBevor:
                                      //         isSameAuthorThenPrevious)
                                    ],
                                  );
                                }

                                return isMe
                                    ? OutBubble(
                                        message: message,
                                        sameAuthorThenBevor:
                                            isSameAuthorThenPrevious,
                                      )
                                    : InBubble(
                                        message: message,
                                        sameAuthorThenBevor:
                                            isSameAuthorThenPrevious,
                                        sameAuthorThenNext:
                                            isSameAuthorThenNext,
                                      );
                                // MessageTile(
                                //   message: message,
                                //   isMe: isMe,
                                //   sameAuthorThenNext: isSameAuthorThenNext,
                                //   sameAuthorThenBevor: isSameAuthorThenPrevious,
                                // );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    MessageTextField(cId: widget.cId)
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool isSameDay(String? t1, String? t2) {
    if (t1 == null || t2 == null) {
      return false;
    }
    return DateTime.parse(t1).day == DateTime.parse(t2).day;
  }
}
