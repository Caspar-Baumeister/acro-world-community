import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class SingleEventQueryWrapper extends StatelessWidget {
  const SingleEventQueryWrapper(
      {super.key,
      this.urlSlug,
      this.classId,
      this.classEventId,
      required this.isCreator});

  final String? urlSlug;
  final String? classId;
  final String? classEventId;
  final bool isCreator;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    if (userProvider.activeUser == null) {
      return const ErrorPage(
        error: "You need to be logged in to view this page.",
      );
    }
    if (urlSlug == null && classId == null && classEventId == null) {
      return const ErrorPage(
        error: "No id or slug provided.",
      );
    }

    Map<String, dynamic> variables = {};
    DocumentNode query;
    String? queryName;
    print("classEventId: $classEventId");
    print("classId: $classId");
    print("urlSlug: $urlSlug");
    if (isCreator) {
      query = Queries.getClassBySlugWithOutFavorite;
      variables["url_slug"] = urlSlug;
      queryName = "classes";
    } else if (classEventId != null) {
      query = Queries.getClassEventWithClasByIdWithFavorite;
      variables["class_event_id"] = classEventId;
      variables["user_id"] = userProvider.activeUser!.id;
      queryName = "class_events_by_pk";
    } else if (classId != null && urlSlug == null) {
      query = Queries.getClassByIdWithFavorite;
      variables["class_id"] = classId;
      variables["user_id"] = userProvider.activeUser!.id;
      queryName = "classes_by_pk";
    } else {
      query = Queries.getClassBySlugWithFavorite;
      variables["url_slug"] = urlSlug;
      variables["user_id"] = userProvider.activeUser!.id;
      queryName = "classes";
    }

    return Query(
      options: QueryOptions(
          document: query,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: variables),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (queryResult.hasException) {
          CustomErrorHandler.captureException(queryResult.exception,
              stackTrace: StackTrace.current);
          return const Center(
            child: Text("This event does not exist."),
          );
        } else if (queryResult.isLoading) {
          return const LoadingPage();
        } else if (queryResult.data != null &&
            queryResult.data?[queryName] != null) {
          var queryData = queryResult.data?[queryName];

          try {
            if (queryName == "class_events_by_pk") {
              ClassEvent classEvent = ClassEvent.fromJson(queryData);
              return SingleClassPage(
                clas: classEvent.classModel!,
                classEvent: classEvent,
              );
            }
            if (queryName == "classes") {
              queryData = queryResult.data?["classes"][0];
            }

            ClassModel clas = ClassModel.fromJson(queryData);
            return SingleClassPage(clas: clas, isCreator: isCreator);
          } catch (e, trace) {
            CustomErrorHandler.captureException(e, stackTrace: trace);
            return ErrorPage(
                error:
                    "There was an error transforming the data from $queryName: $queryData");
          }
        } else {
          CustomErrorHandler.captureException(
              "An unexpected error occured, when fetching the class / classEvent with id $urlSlug / $classEventId",
              stackTrace: StackTrace.current);
          return ErrorPage(
              error:
                  "An unexpected error occured, when fetching the class / classEvent with id $urlSlug / $classEventId");
        }
      },
    );
  }
}
