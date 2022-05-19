// import 'package:acroworld/models/community_model.dart';
// import 'package:acroworld/provider/user_provider.dart';
// import 'package:acroworld/screens/home/communities/all_communities/body/all_communities_body.dart';
// import 'package:acroworld/services/database.dart';
// import 'package:acroworld/services/preferences/user_id.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AllCommunitiesStream extends StatelessWidget {
//   const AllCommunitiesStream({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String userId = UserIdPreferences.getToken();
//     UserProvider userProvider = Provider.of<UserProvider>(context);

//     return userProvider.userCommunities == null
//         ? const Center(child: Text("loading your communities..."))
//         : StreamBuilder<QuerySnapshot>(
//             stream: userProvider.userCommunities!.isEmpty
//                 ? DataBaseService(uid: userId).getCommunities()
//                 : DataBaseService(uid: userId)
//                     .getNonUserCommunities(userProvider.userCommunities!),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text(
//                     'Something went wrong with error : ${snapshot.error}');
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: Text("Loading"));
//               }

//               List<Community> communities = snapshot.data!.docs
//                   .where((com) => com.get("confirmed"))
//                   .map((e) {
//                 return Community.fromJson(
//                     e.id, e.get("next_jam"), e.get("name"));
//               }).toList();
//               return AllCommunitiesBody(allCommunities: communities);
//             },
//           );
//   }
// }
