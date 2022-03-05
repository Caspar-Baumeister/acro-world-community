import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/communities_body.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunitiesStream extends StatelessWidget {
  const CommunitiesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = UserIdPreferences.getToken();

    return StreamBuilder<DocumentSnapshot>(
      stream: DataBaseService(uid: userId).getUserCommunities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong with error : ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        List<String> communityIds =
            List<String>.from(snapshot.data!.get("communities"));

        return CommunityLoader(communityIds: communityIds);
      },
    );
  }
}

class CommunityLoader extends StatefulWidget {
  const CommunityLoader({Key? key, required this.communityIds})
      : super(key: key);

  final List<String> communityIds;

  @override
  State<CommunityLoader> createState() => _CommunityLoaderState();
}

class _CommunityLoaderState extends State<CommunityLoader> {
  late Future<List<Community>> future;

  @override
  void initState() {
    future = getCommunities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Community>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong with error : ${snapshot.error}');
          }

          if (snapshot.hasData) {
            return CommunitiesBody(allCommunities: snapshot.data!);
          } else {
            return const Text("Loading");
          }
        });
  }

  Future<List<Community>> getCommunities() async {
    List<Community> communities = [];

    for (String id in widget.communityIds) {
      String userId = UserIdPreferences.getToken();
      DocumentSnapshot<Object?> communityObject =
          await DataBaseService(uid: userId).getCommunity(id);
      Community community = Community.fromJson(
          communityObject.id, communityObject.get("next_jam"));
      communities.add(community);
    }
    return communities;
  }
}
