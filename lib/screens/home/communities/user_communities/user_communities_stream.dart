import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/user_communities/user_communities_body.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:acroworld/services/user_db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This stream keeps track of the firebase database community collection
// where the query is dependent on the userProvider (specifically on the user communities)
class UserCommunitiesStream extends StatelessWidget {
  UserCommunitiesStream({Key? key}) : super(key: key);

  final UserDBService userDBService = UserDBService();

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User?>(context)!;
    // UserProvider userProvider = Provider.of<UserProvider>(context);
    // UserDto userDto = userDBService.get(user.uid).then((value) => null);

    // return UserCommunitiesBody(userCommunities: userDto);

    return FutureBuilder<UserDto>(
        future: userDBService.get(user.uid),
        builder: (BuildContext context, AsyncSnapshot<UserDto> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return UserCommunitiesBody(
                  userCommunities: snapshot.data!.communities);
            }
          }
        });
  }
}
