
// class CommunityLoader extends StatefulWidget {
//   const CommunityLoader({Key? key, required this.communityIds})
//       : super(key: key);

//   final List<String> communityIds;

//   @override
//   State<CommunityLoader> createState() => _CommunityLoaderState();
// }

// class _CommunityLoaderState extends State<CommunityLoader> {
//   late Future<List<Community>> future;

//   @override
//   void initState() {
//     future = getCommunities();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Community>>(
//         future: future,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong with error : ${snapshot.error}');
//           }

//           if (snapshot.hasData) {
//             return CommunitiesBody(allCommunities: snapshot.data!);
//           } else {
//             return const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Text("Loading..."),
//               ),
//             );
//           }
//         });
//   }

//   Future<List<Community>> getCommunities() async {
//     List<Community> communities = [];

//     for (String id in widget.communityIds) {
//       String userId = UserIdPreferences.getToken();
//       DocumentSnapshot<Object?> communityObject =
//           await DataBaseService(uid: userId).getCommunity(id);
//       Community community = Community.fromJson(
//           communityObject.id, communityObject.get("next_jam"));
//       communities.add(community);
//     }
//     return communities;
//   }
// }