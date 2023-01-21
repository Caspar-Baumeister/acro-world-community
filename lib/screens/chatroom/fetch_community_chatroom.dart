import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/chatroom/chatroom.dart';
import 'package:acroworld/screens/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FetchCommunityChatroom extends StatelessWidget {
  const FetchCommunityChatroom({Key? key, required this.communityId})
      : super(key: key);
  final String communityId;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: Queries.getCommunityById,
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {"communityId": communityId}),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const LoadingPage();
          }
          Community community =
              Community.fromJson(result.data?['communities'][0]);
          return Chatroom(
            cId: communityId,
            name: community.name,
            community: community,
          );
        });
  }
}
