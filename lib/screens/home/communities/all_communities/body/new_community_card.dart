import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/refresh_user_info_provider.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/chatroom/chatroom.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        MaterialPageRoute(builder: (context) => Chatroom(cId: community.id)),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(COMMUNITY_IMG_URL),
        ),
        title: Text(community.name),
        subtitle: Text(timeago.format(community.nextJam, allowFromNow: true),
            style: const TextStyle(fontWeight: FontWeight.w300)),
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

  void addCommunity(BuildContext context) {
    // UserCommunitiesProvider userCommunitiesProvider =
    //     Provider.of<UserCommunitiesProvider>(context, listen: false);
    String userId = UserIdPreferences.getToken();

    Provider.of<UserProvider>(context, listen: false)
        .addUserCommunities(community.id);

    // // reloads the user informations
    // Provider.of<RefreshUserInfoProvider>(context, listen: false)
    //     .notifyFunction();

    //userCommunitiesProvider.addCommunityAndUpdate(community);
    DataBaseService(uid: userId).addCommunityToUser(community: community.id);
  }
}
