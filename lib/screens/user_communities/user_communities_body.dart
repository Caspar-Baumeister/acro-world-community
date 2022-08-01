import 'dart:async';

import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/leave_community_event.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/screens/user_communities/widgets/list_coms.dart';
import 'package:acroworld/screens/user_communities/widgets/new_button.dart';
import 'package:acroworld/shared/widgets/loading_indicator/loading_indicator.dart';
import 'package:event_bus/event_bus.dart';
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

  @override
  void dispose() {
    super.dispose();
    for (final eventListener in eventListeners) {
      eventListener.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context, listen: false);
    final EventBus eventBus = eventBusProvider.eventBus;
    return Query(
      options: QueryOptions(
          document: Queries.getUserCommunities,
          variables: {'query': '$query%'}),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        VoidCallback runRefetch = (() {
          try {
            refetch!();
          } catch (e) {
            print(e.toString());
          }
        });
        eventListeners
            .add(eventBus.on<CrudUserCommunityEvent>().listen((event) {
          runRefetch();
        }));

        List<Community> communities = [];
        if (result.data != null && result.data?['me'].length > 0) {
          communities.addAll(List<Community>.from(
              result.data?['me']?[0]?['communities'].map((userCommunity) {
            dynamic messageJson;
            if (userCommunity['community']["community_messages"].isNotEmpty) {
              messageJson = userCommunity['community']["community_messages"][0];
            }

            return Community.fromJson(userCommunity['community'],
                lastVisitedAt: userCommunity["last_visited_at"],
                messageJson: messageJson);
          })));
        }
        Future.delayed(const Duration(milliseconds: 200), () {
          Provider.of<UserCommunitiesProvider>(context, listen: false)
              .userCommunities = communities;
        });

        return RefreshIndicator(
          onRefresh: () async => {refetch!()},
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Searchbar
                    Row(
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
                    const SizedBox(height: 12),
                    Expanded(
                      child: result.isLoading
                          ? const LoadingIndicator()
                          : const UserCommunitiesList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
