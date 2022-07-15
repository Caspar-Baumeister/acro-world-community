import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/leave_community_event.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/chatroom/chatroom.dart';
import 'package:acroworld/screens/user_communities/user_communities.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCommunityCard extends StatelessWidget {
  const NewCommunityCard({
    Key? key,
    required this.community,
  }) : super(key: key);

  final Community community;

  @override
  Widget build(BuildContext context) {
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
        title: Text(community.name),
        // subtitle: Text(timeago.format(community.nextJam, allowFromNow: true),
        //     style: const TextStyle(fontWeight: FontWeight.w300)),
        trailing: GestureDetector(
          onTap: () => addCommunity(context),
          child: const Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  void addCommunity(BuildContext context) async {
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

    String uid = Provider.of<UserProvider>(context, listen: false).getId();

    final response = await database.insertUserCommunitiesOne(community.id, uid);

    eventBus.fire(CrudUserCommunityEvent());
    // update the usercommunities
    Provider.of<UserCommunitiesProvider>(context, listen: false)
        .loadDataFromDatabase(token);

    Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => const UserCommunities())));
  }
}
