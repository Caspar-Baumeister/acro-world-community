import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/chatroom/chatroom.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
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
        // TODO delete community from usercommunities in backend and in state
        trailing: GestureDetector(
          onTap: () => deleteCommunity(context),
          child: const Icon(
            Icons.exit_to_app_rounded,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  void deleteCommunity(BuildContext context) async {
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

    // update the usercommunities
    Provider.of<UserCommunitiesProvider>(context, listen: false)
        .loadDataFromDatabase(token);

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
