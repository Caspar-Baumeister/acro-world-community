import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/chatroom/chatroom.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    Key? key,
    required this.community,
  }) : super(key: key);

  final Community community;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: Queries.getUserCommunityMessageCount,
            variables: {
              'community_id': community.id,
              'last_visited_at': community.lastVisitedAt
            }),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return const CircularProgressIndicator();
          }
          int? count;
          if (result.data!["user_communities"].isNotEmpty) {
            // get the number of messages
            count = result.data!["user_communities"][0]["community"]
                ["community_messages_aggregate"]["aggregate"]["count"];
          }

          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => Chatroom(
                        cId: community.id,
                        community: community,
                        name: community.name,
                      )),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(COMMUNITY_IMG_URL),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    community.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  community.lastMessage?.createdAt != null
                      ? Container(
                          constraints: const BoxConstraints(maxWidth: 60),
                          child: Text(
                            DateFormat.EEEE().format(DateTime.parse(
                                    community.lastMessage!.createdAt!)
                                .toLocal()),
                            style: const TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.fade,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ))
                      : Container()
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      child: community.lastMessage?.fromUser?.name != null &&
                              community.lastMessage?.content != null
                          ? RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(overflow: TextOverflow.ellipsis),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "${community.lastMessage!.fromUser!.name}: ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: community.lastMessage!.content,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            )
                          : null,
                    ),
                  ),
                  Container(
                    child: count != null && count > 0
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 187, 236, 189),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(count.toString()))
                        : null,
                  )
                ],
              ),
            ),
          );
        });
  }
}
