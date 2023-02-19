import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/leave_community_event.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCommunityCard extends StatefulWidget {
  const NewCommunityCard({
    Key? key,
    required this.community,
  }) : super(key: key);

  final Community community;

  @override
  State<NewCommunityCard> createState() => _NewCommunityCardState();
}

class _NewCommunityCardState extends State<NewCommunityCard> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: const CircleAvatar(
      //   radius: 32,
      //   backgroundImage: AssetImage("assets/logo/play_store_512.png"),
      // ),
      title: Text(widget.community.name),
      // subtitle: Text(timeago.format(community.nextJam, allowFromNow: true),
      //     style: const TextStyle(fontWeight: FontWeight.w300)),
      subtitle: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textAlign: TextAlign.left,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: widget.community.distance != null
                  ? " (${widget.community.distance!.toStringAsFixed(2)} km distance)"
                  : "",
              style: const TextStyle(color: Colors.black, fontSize: 10),
            ),
          ],
        ),
      ),
      trailing: IgnorePointer(
        ignoring: isLoading,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: () => addCommunity(context),
          child: const Text(
            "Join",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void addCommunity(BuildContext context) async {
    String uid = Provider.of<UserProvider>(context, listen: false).getId();

    String token = Provider.of<UserProvider>(context, listen: false).token!;
    setState(() {
      isLoading = true;
    });
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

    final database = Database(token: token);

    final response =
        await database.insertUserCommunitiesOne(widget.community.id, uid);

    eventBus.fire(CrudUserCommunityEvent());
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);

    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: ((context) => const UserCommunities())));
  }
}
