import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/user_communities/user_communities_body.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This stream keeps track of the firebase database community collection
// where the query is dependent on the userProvider (specifically on the user communities)
class UserCommunitiesStream extends StatelessWidget {
  const UserCommunitiesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User?>(context)!;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    print("user provider update before usercommunitystream");

    return Builder(builder: ((context) {
      if (userProvider.userCommunities == null) {
        return const Center(child: Text("loading your communities..."));
      }

      if (userProvider.userCommunities!.isEmpty) {
        return const UserCommunitiesBody(userCommunities: []);
      }

      print(userProvider.userCommunities!);

      return StreamBuilder<QuerySnapshot>(
        stream: DataBaseService(uid: user.uid)
            .getUserCommunities(userProvider.userCommunities!),
        builder: (context, snapshot) {
          // UserCommunitiesProvider userCommunitiesProvider =
          //     Provider.of<UserCommunitiesProvider>(context, listen: false);
          if (snapshot.hasError) {
            return Text('Something went wrong with error : ${snapshot.error}');
          }

          if (snapshot.hasData) {
            print(snapshot.data!.docs.length);
            List<Community> userCommunities = snapshot.data!.docs
                .where((com) => com.get("confirmed"))
                .map((e) {
              print(e.get("name"));
              return Community.fromJson(e.id, e.get("next_jam"), e.get("name"));
            }).toList();

            // List<Map> communityIds = [];

            // if (snapshot.data!.data() != null) {
            //   communityIds = List<Map>.from(snapshot.data!.get("communities"));
            // }

            // // if provider is initialized
            // if (userCommunitiesProvider.initialized) {
            //   // update provider
            //   WidgetsBinding.instance!.addPostFrameCallback((_) {
            //     userCommunitiesProvider.update(communityIds);
            //   });
            //   // else initialize
            // } else {
            //   WidgetsBinding.instance!.addPostFrameCallback((_) {
            //     userCommunitiesProvider.initialize(communityIds);
            //   });
            // }
            return UserCommunitiesBody(userCommunities: userCommunities);
          } else {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Loading..."),
            ));
          }
        },
      );
    }));
  }
}
