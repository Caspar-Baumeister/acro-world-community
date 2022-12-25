import 'dart:async';

import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/subscriptions.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/screens/home_folder/communities/search_bar_widget.dart';
import 'package:acroworld/screens/home_screens/user_communities/widgets/list_coms.dart';
import 'package:acroworld/screens/home_screens/user_communities/widgets/new_button.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class UserCommunitiesBody extends StatefulWidget {
  const UserCommunitiesBody({Key? key}) : super(key: key);

  @override
  State<UserCommunitiesBody> createState() => _UserCommunitiesBodyState();
}

class _UserCommunitiesBodyState extends State<UserCommunitiesBody> {
  String query = "";
  List<StreamSubscription> eventListeners = [];
  Place? place;

  @override
  void dispose() {
    super.dispose();
    for (final eventListener in eventListeners) {
      eventListener.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Subscription(
      options: SubscriptionOptions(
          document: gql(Subscriptions.subscribeUserCommunities),
          variables: {'query': '$query%'}),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        VoidCallback runRefetch = (() {
          try {
            refetch!();
          } catch (e) {
            print(e.toString());
          }
        });
        if (result.hasException) {
          // TODO show exeption screen
          return RefreshIndicator(
              onRefresh: () async => runRefetch(),
              child: Text(result.exception.toString()));
        }

        List<Community> communities = [];

        if (result.data != null && result.data?['me'].length > 0) {
          communities.addAll(List<Community>.from(
              result.data?['me']?[0]?['communities'].map((userCommunity) {
            dynamic messageJson;
            if (userCommunity['community']["community_messages"].isNotEmpty) {
              messageJson = userCommunity['community']["community_messages"][0];
            }

            return Community.fromJson(
              userCommunity['community'],
              lastVisitedAt: userCommunity["last_visited_at"],
              messageJson: messageJson,
              // nextJamAt: date
            );
          })));
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          Provider.of<UserCommunitiesProvider>(context, listen: false)
              .userCommunities = communities;
        });

        return RefreshIndicator(
          onRefresh: () async => {runRefetch()},
          child: result.isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingWidget(
                      onRefresh: () async => runRefetch(),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      // Searchbar
                      Container(
                        constraints: const BoxConstraints(maxHeight: 42),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: SearchBarWidget(
                                onChanged: (String value) {
                                  setState(() {
                                    query = value;
                                  });
                                },
                              ),
                            ),
                            const NewCommunityButton(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Expanded(
                        child: UserCommunitiesList(),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
