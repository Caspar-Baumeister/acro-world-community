// import 'package:acroworld/components/loading_widget.dart';
// import 'package:acroworld/graphql/queries.dart';
// import 'package:acroworld/models/bookmark_model.dart';
// import 'package:acroworld/models/event_model.dart';
// import 'package:acroworld/screens/main_pages/events/widgets/event_filter_on_card.dart';
// import 'package:acroworld/screens/system_pages/error_page.dart';
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// class UserBookmarks extends StatelessWidget {
//   const UserBookmarks({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Query(
//       options: QueryOptions(
//         document: Queries.userBookmarks,
//         fetchPolicy: FetchPolicy.networkOnly,
//       ),
//       builder: (QueryResult queryResult,
//           {VoidCallback? refetch, FetchMore? fetchMore}) {
//         if (queryResult.hasException) {
//           return ErrorWidget(queryResult.exception.toString());
//         } else if (queryResult.isLoading) {
//           return const LoadingWidget();
//         } else if (queryResult.data != null &&
//             queryResult.data?["me"] != null) {
//           try {
//             List bookmarks = queryResult.data!["me"]![0]?["bookmarks"];
//             List<BookmarkModel> bookmarkModels =
//                 bookmarks.map((e) => BookmarkModel.fromJson(e)).toList();
//             return bookmarkModels.isEmpty
//                 ? Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(40.0),
//                       child: Text(
//                         "You have no bookmarked events",
//                         style: Theme.of(context).textTheme.titleLarge,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: bookmarkModels.length,
//                     itemBuilder: ((context, index) {
//                       EventModel event = bookmarkModels[index].event!;
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8.0, vertical: 4),
//                         child: EventFilterOnCard(event: event),
//                       );
//                     }));
//           } catch (e) {
//             return const ErrorPage(
//                 error:
//                     "An unexpected error occured, when transforming the user bookmarks to an objects with");
//           }
//         } else {
//           return const ErrorPage(
//               error:
//                   "An unexpected error occured, when fetching user bookmarks");
//         }
//       },
//     );
//   }
// }
