// import 'package:acroworld/models/community_model.dart';
// import 'package:acroworld/models/user_community_model.dart';
// import 'package:acroworld/provider/user_provider.dart';
// import 'package:acroworld/screens/home/communities/user_communities/body.dart';
// import 'package:acroworld/services/database.dart';
// import 'package:acroworld/shared/error_page.dart';
// import 'package:acroworld/shared/loading_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class UserCommunitiesFuture extends StatelessWidget {
//   const UserCommunitiesFuture({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final UserProvider user = Provider.of<UserProvider>(context, listen: true);
//     return RefreshIndicator(
//       onRefresh: () async {},
//       child: FutureBuilder<List<Community>>(
//           future: loadUserCommunities(context, user),
//           builder: ((context, snapshot) {
//             if (snapshot.hasError) {
//               //Provider.of<User?>(context)?.reload();
//               return ErrorScreenWidget(error: snapshot.error.toString());
//             }
//             if (snapshot.hasData) {
//               return UserCommunitiesBody(
//                 userCommunities: snapshot.data ?? [],
//               );
//             }

//             return const LoadingScaffold();
//           })),
//     );
//   }

//   Future<List<Community>> loadUserCommunities(
//       BuildContext context, UserProvider userProvider) async {
//     List<UserCommunityModel>? userCommunities = userProvider.userCommunities;
//     if (userCommunities == null || userCommunities.isEmpty) return [];

//     List<String> userCommunityIds =
//         List<String>.from(userCommunities.map((e) => e.id));
//     final userCommunitySnapshot =
//         await DataBaseService(uid: userProvider.activeUser!.uid)
//             .getUserCommunitiesFuture(userCommunityIds);

//     List<Community> communitiesOfUser = userCommunitySnapshot.docs
//         .where((com) => com.get("confirmed"))
//         .map((e) {
//       print(e.get("name"));
//       return Community.fromJson(e.id, e.data());
//     }).toList();
//     return communitiesOfUser;
//   }
// }
