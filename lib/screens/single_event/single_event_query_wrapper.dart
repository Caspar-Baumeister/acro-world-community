import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/single_event/single_event_page.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class SingleEventQueryWrapper extends StatelessWidget {
  const SingleEventQueryWrapper({Key? key, required this.eventId})
      : super(key: key);

  final String eventId;

  @override
  Widget build(BuildContext context) {
    // TODO if the page dhould be openable without login, make the query requests
    // for bookmarks and without
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Query(
      options: QueryOptions(
          document: Queries.getEventByIdWithBookmark,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {
            'event_id': eventId,
            "user_id": userProvider.activeUser!.id
          }),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (queryResult.hasException) {
          return ErrorPage(error: queryResult.exception.toString());
        } else if (queryResult.isLoading) {
          return const LoadingPage();
        } else if (queryResult.data != null &&
            queryResult.data?["events_by_pk"] != null) {
          try {
            EventModel event =
                EventModel.fromJson(queryResult.data?["events_by_pk"]);
            return SingleEventPage(event: event);
          } catch (e) {
            return ErrorPage(
                error:
                    "An unexpected error occured, when transforming the event data to an object with event id $eventId");
          }
        } else {
          return ErrorPage(
              error:
                  "An unexpected error occured, when fetching the event with id $eventId");
        }
      },
    );
  }
}
