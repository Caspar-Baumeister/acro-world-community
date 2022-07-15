import 'dart:async';

import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/leave_community_event.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/screens/home/communities/user_communities/app_bar.dart';
import 'package:acroworld/screens/home/communities/settings_drawer.dart';
import 'package:acroworld/screens/home/communities/user_communities/list_coms.dart';
import 'package:acroworld/screens/home/communities/user_communities/new_button.dart';
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
            // print(e);
          }
        });
        eventListeners
            .add(eventBus.on<CrudUserCommunityEvent>().listen((event) {
          runRefetch();
        }));

        List<Community> communities = [];
        if (result.data != null && result.data?['me'].length > 0) {
          communities.addAll(List<Community>.from(
              result.data?['me'][0]['communities'].map((userCommunity) =>
                  Community.fromJson(userCommunity['community']))));
        }

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
                            // onChanged: (query) => search(query),
                          ),
                        ),
                        const NewCommunityButton(),
                      ],
                    ),
                    Expanded(
                      child: result.isLoading
                          ? const LoadingIndicator()
                          : UserCommunitiesList(communities: communities),
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

class UserCommunities extends StatelessWidget {
  const UserCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarUserCommunities(),
      body: const UserCommunitiesBody(),
      endDrawer: const SettingsDrawer(),
    );
  }
}
