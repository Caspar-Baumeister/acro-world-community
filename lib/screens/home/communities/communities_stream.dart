import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/screens/home/communities/user_communities_guard.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// keeps track of the firebase user communities. If they change (stream), update the provider.
class CommunitiesStream extends StatelessWidget {
  const CommunitiesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = UserIdPreferences.getToken();

    return StreamBuilder<DocumentSnapshot>(
      stream: DataBaseService(uid: userId).getUserCommunities(),
      builder: (context, snapshot) {
        UserCommunitiesProvider userCommunitiesProvider =
            Provider.of<UserCommunitiesProvider>(context, listen: false);
        if (snapshot.hasError) {
          return Text('Something went wrong with error : ${snapshot.error}');
        }

        if (snapshot.hasData) {
          List<String> communityIds =
              List<String>.from(snapshot.data!.get("communities"));
//
          // if provider is initialized
          if (userCommunitiesProvider.initialized) {
            // update provider
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              userCommunitiesProvider.update(communityIds);
            });
            // else initialize
          } else {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              userCommunitiesProvider.initialize(communityIds);
            });
          }
          return const UserCommunitiesGuard();
        } else {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Loading..."),
          ));
        }
      },
    );
  }
}
