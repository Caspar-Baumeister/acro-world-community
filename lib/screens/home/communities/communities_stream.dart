import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/communities_list.dart';
import 'package:acroworld/screens/home/communities/communities_search.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunitiesStream extends StatelessWidget {
  const CommunitiesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = UserIdPreferences.getToken();

    return StreamBuilder<QuerySnapshot>(
      stream: DataBaseService(uid: userId).getCommunities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong with error : ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        List<Community> communities = snapshot.data!.docs.map((e) {
          return Community.fromJson(e.id);
        }).toList();
        return CommunitiesSearch(allCommunities: communities);
      },
    );
  }
}
