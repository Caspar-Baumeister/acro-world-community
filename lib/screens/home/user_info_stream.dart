import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/refresh_user_info_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/user_communities/user_communities.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This stream listens for changes in the firebase databse regarding the
// userinfo collection.
// If there is a change, the userProvider gets updated
class UserInfoStream extends StatelessWidget {
  const UserInfoStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User?>(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Provider.of<RefreshUserInfoProvider>(context);

    print("userInfoStream build");

    return StreamBuilder<DocumentSnapshot>(
      stream: DataBaseService(uid: user.uid).userInfoStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong with error : ${snapshot.error}');
        }

        print("userInfoStream builder");

        if (snapshot.hasData) {
          UserModel userModel = UserModel(
            uid: user.uid,
            userName: snapshot.data!.get("userName"),
            imgUrl: snapshot.data!.get("imgUrl"),
            bio: snapshot.data!.get("bio"),
            lastCreatedCommunity: snapshot.data!.get("last_created_community"),
            lastCreatedJam: snapshot.data!.get("last_created_jam"),
          );
          final userCommunities = List<String>.from(snapshot.data!
              .get("communities")
              .map((obj) => obj["community_id"]));
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            print("userInfoStream post frame callback with");

            userProvider.activeUser = userModel;

            userProvider.userCommunities = userCommunities;
          });

          return const UserCommunities();
        }
        return const LoadingScaffold();
      },
    );
  }
}
