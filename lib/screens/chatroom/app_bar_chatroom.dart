import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/leave_community_event.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/screens/jam/jams/jams.dart';
import 'package:acroworld/screens/users_list/user_list_screen.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarChatroom extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const AppBarChatroom({
    Key? key,
    required this.cId,
    required this.name,
    required this.community,
    required this.updateLastVisitedAt,
  }) : super(key: key);

  final String cId;
  final String name;
  final Community community;
  final Function updateLastVisitedAt;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QueryUserListScreen(
                  query: Queries.getCommunityUsers,
                  variables: {'community_id': community.id},
                ),
              ),
            );
          },
          child: Text(
            name,
            style: const TextStyle(color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          updateLastVisitedAt();
          Navigator.of(context).pop();
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Jams(cId: cId, community: community, name: name)),
              );
            },
            child: const Text(
              'Jams',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
        PopupMenuButton(
          offset: const Offset(0, 45),
          color: Colors.white,
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              onTap: () {
                Navigator.of(context).pop();
                leaveCommunity(context);
              },
              child: const ListTile(
                visualDensity: VisualDensity.compact,
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Exit community',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          // visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(0),
          // onPressed: () {},
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  void leaveCommunity(BuildContext context) async {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context, listen: false);
    final EventBus eventBus = eventBusProvider.eventBus;
    // TODO later get token from shared pref
    // TODO filter out the communities that the user is part of
    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).validToken();
    if (!isValidToken) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const Authenticate())));
      return null;
    }
    String token = Provider.of<UserProvider>(context, listen: false).token!;
    final database = Database(token: token);

    final response = await database.deleteUserCommunitiesOne(community.id);

    eventBus.fire(CrudUserCommunityEvent());
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: ((context) => const UserCommunities())));

    // UserCommunitiesProvider userCommunitiesProvider =
    //     Provider.of<UserCommunitiesProvider>(context, listen: false);
    // String userId = UserIdPreferences.getToken();

    // Provider.of<UserProvider>(context, listen: false)
    //     .addUserCommunities(community.id);

    // // reloads the user informations
    // Provider.of<RefreshUserInfoProvider>(context, listen: false)
    //     .notifyFunction();

    //userCommunitiesProvider.addCommunityAndUpdate(community);
    // DataBaseService(uid: userId).addCommunityToUser(communityId: community.id);
  }
}
