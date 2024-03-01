// import 'package:acroworld/graphql/queries.dart';
// import 'package:acroworld/models/class_event.dart';
// import 'package:acroworld/models/user_model.dart';
// import 'package:acroworld/provider/user_provider.dart';
// import 'package:acroworld/screens/single_class_page/widgets/class_event_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:provider/provider.dart';

// class ClassEventParticipantQuery extends StatelessWidget {
//   const ClassEventParticipantQuery({Key? key, required this.classEvent})
//       : super(key: key);
//   final ClassEvent classEvent;

//   @override
//   Widget build(BuildContext context) {
//     return Query(
//       options: QueryOptions(
//         fetchPolicy: FetchPolicy.networkOnly,
//         document: Queries.getClassEventParticipants,
//         variables: {
//           'class_event_id': classEvent.id,
//         },
//       ),
//       builder: (QueryResult result,
//           {VoidCallback? refetch, FetchMore? fetchMore}) {
//         if (result.hasException) {
//           return Text(result.exception.toString());
//         }

//         if (result.isLoading) {
//           return Container();
//         }

//         VoidCallback runRefetch = (() {
//           refetch!();
//         });

//         List<User> participantsWithMe = List<User>.from(result
//             .data!["class_events_participants"]
//             .map((u) => User(id: u["user"]["id"], name: u["user"]["name"])));

//         List<User> participants = [];
//         bool isParticipate = false;
//         participantsWithMe.forEach(((element) {
//           if (element.id ==
//               Provider.of<UserProvider>(context, listen: false)
//                   .activeUser!
//                   .id) {
//             isParticipate = true;
//           } else {
//             participants.add(element);
//           }
//         }));

//         return RefreshIndicator(
//           onRefresh: (() async => runRefetch()),
//           child: ClassEventTile(
//             classEvent: classEvent,
//             isParticipate:
//                 isParticipate, //contains(userProvider.activeUser!.id),
//             participants: participants,
//           ),
//         );
//       },
//     );
//   }
// }
