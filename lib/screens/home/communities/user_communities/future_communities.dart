import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/communities/user_communities/body.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/querys.dart';
import 'package:acroworld/shared/error_page.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FutureCommunity extends StatelessWidget {
  const FutureCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final UserProvider user = Provider.of<UserProvider>(context, listen: true);
    return FutureBuilder<List<Community>?>(
        future: loadUserCommunities(context),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            //Provider.of<User?>(context)?.reload();
            return ErrorScreenWidget(error: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return UserCommunitiesBody(
              userCommunities: snapshot.data ?? [],
            );
          }

          return const LoadingScaffold();
        }));
  }

  Future<List<Community>?> loadUserCommunities(BuildContext context) async {
    // TODO later get token from shared pref

    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).validToken();
    if (!isValidToken) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const Authenticate())));
      return null;
    }
    String token = Provider.of<UserProvider>(context, listen: false).token!;
    final database = Database(token: token);
    final response = await database.authorizedApi(Querys.userCommunities);
    print("usercoms response:$response");
    List userCommunities = response["data"]["user_communities"];
    print(userCommunities);

    return List<Community>.from(userCommunities.map((com) => Community(
        id: com["community"]["id"],
        nextJam: DateTime.now(),
        name: com["community"]["name"],
        confirmed: true)));

    // List<UserCommunityModel>? userCommunities = userProvider.userCommunities;
    // if (userCommunities == null || userCommunities.isEmpty) return [];

    // List<String> userCommunityIds =
    //     List<String>.from(userCommunities.map((e) => e.id));
    // final userCommunitySnapshot =
    //     await DataBaseService(uid: userProvider.activeUser!.uid)
    //         .getUserCommunitiesFuture(userCommunityIds);

    // List<Community> communitiesOfUser = userCommunitySnapshot.docs
    //     .where((com) => com.get("confirmed"))
    //     .map((e) {
    //   print(e.get("name"));
    //   return Community.fromJson(e.id, e.data());
    // }).toList();
    // return communitiesOfUser;
  }
}
