import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class EventsInitializerQuery extends StatelessWidget {
  const EventsInitializerQuery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return Query(
      options: QueryOptions(
        document: Queries.events,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          print(result.exception);
          return ErrorPage(error: result.exception.toString());
        } else if (result.isLoading) {
          return const LoadingPage();
        } else if (result.data != null && result.data?["events"] != null) {
          // initialize events here
          WidgetsBinding.instance.addPostFrameCallback((_) {
            eventFilterProvider.setInitialData(result.data!["events"]);
          });
          return const LoadingPage();
        } else {
          return const LoadingPage();
        }
      },
    );
  }
}
