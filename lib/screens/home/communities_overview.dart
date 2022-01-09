import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/chatroom.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunitiesOverview extends StatelessWidget {
  const CommunitiesOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = UserIdPreferences.getToken();

    return StreamBuilder<QuerySnapshot>(
        stream: DataBaseService(uid: userId).getCommunities(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("the error is: ${snapshot.error}");
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          print("snapshot data:${snapshot.data!}");

          print("snapshot data:${snapshot.data!.docs}");

          // print("snapshot data:${snapshot.data!.docs.first.id.runtimeType}");
          List<Community> communities = snapshot.data!.docs.map((e) {
            return Community.fromJson(e.id);
          }).toList();
          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              return CommunityCard(community: communities[index]);
            },
          );
        });
  }
}

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
        MaterialPageRoute(builder: (context) => Chatroom(cId: community.id)),
      ),
      child: ListTile(
        title: Text(community.id),
      ),
    );
  }
}
