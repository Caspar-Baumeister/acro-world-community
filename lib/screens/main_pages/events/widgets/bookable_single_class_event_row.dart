// import 'package:acroworld/components/loading_indicator/loading_indicator.dart';
// import 'package:acroworld/graphql/queries.dart';
// import 'package:acroworld/models/class_event.dart';
// import 'package:acroworld/screens/main_pages/events/widgets/class_event_slider_card.dart';
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// class BookableSingleClassEventRow extends StatelessWidget {
//   const BookableSingleClassEventRow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Query(
//       options: QueryOptions(
//         document: Queries.getBokableSingleClassEvents,
//         fetchPolicy: FetchPolicy.networkOnly,
//       ),
//       builder: (QueryResult queryResult,
//           {VoidCallback? refetch, FetchMore? fetchMore}) {
//         if (queryResult.hasException) {
//           return ErrorWidget(queryResult.exception.toString());
//         } else if (queryResult.isLoading) {
//           return const LoadingIndicator();
//         } else if (queryResult.data != null &&
//             queryResult.data?["class_events"] != null &&
//             queryResult.data?["class_events"].isNotEmpty) {
//           List<ClassEvent> singleClassEvents = List<ClassEvent>.from(queryResult
//               .data?["class_events"]
//               .map((event) => ClassEvent.fromJson(event)));

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 alignment: Alignment.centerLeft,
//                 child: Text("Book trough AcroWorld",
//                     style: Theme.of(context).textTheme.headlineMedium),
//               ),
//               const SizedBox(height: 10),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: List<Widget>.from(singleClassEvents.map(
//                       (ClassEvent item) =>
//                           ClassEventSliderCard(classEvent: item))),
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }
