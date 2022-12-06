import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/error_page.dart';
import 'package:acroworld/screens/home_screens/activities/components/choose_community_modal.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserCommunityQuery extends StatelessWidget {
  const UserCommunityQuery({Key? key, this.day}) : super(key: key);
  final DateTime? day;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: Queries.getUserCommunities,
          fetchPolicy: FetchPolicy.networkOnly,
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return ErrorPage(error: result.exception.toString());
          }

          if (result.isLoading) {
            return Container(
                padding: const EdgeInsets.all(40),
                margin: const EdgeInsets.all(20),
                height: 100,
                child: const Center(
                  child: LoadingWidget(),
                ));
          }

          VoidCallback runRefetch = (() {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
            }
          });
          List<Community> communities = [];

          if (result.data != null && result.data?['me'].length > 0) {
            communities.addAll(List<Community>.from(
                result.data?['me']?[0]?['communities'].map((userCommunity) {
              dynamic messageJson;
              if (userCommunity['community']["community_messages"].isNotEmpty) {
                messageJson =
                    userCommunity['community']["community_messages"][0];
              }

              return Community.fromJson(
                userCommunity['community'],
                lastVisitedAt: userCommunity["last_visited_at"],
                messageJson: messageJson,
                // nextJamAt: date
              );
            })));
          }

          return ChooseCommunityModal(
            communities: communities,
            day: day,
          );
        });
  }
}
