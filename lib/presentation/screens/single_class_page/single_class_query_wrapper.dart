import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SingleEventQueryWrapper extends ConsumerWidget {
  const SingleEventQueryWrapper({
    super.key,
    this.urlSlug,
    this.classEventId,
  });

  final String? urlSlug;
  final String? classEventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (urlSlug == null && classEventId == null) {
      return const ErrorPage(
        error: "No Event provided. Please check the URL.",
      );
    }

    // Build query & variables
    DocumentNode query;
    Map<String, dynamic> variables = {};
    String queryName;

    if (classEventId == null) {
      query = Queries.getClassBySlug;
      variables["url_slug"] = urlSlug;
      queryName = "classes";
    } else {
      query = Queries.getClassEventWithClasById;
      variables["class_event_id"] = classEventId;
      queryName = "class_events_by_pk";
    }

    return Query(
      options: QueryOptions(
        document: query,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: variables,
      ),
      builder: (result, {refetch, fetchMore}) {
        if (result.hasException) {
          CustomErrorHandler.captureException(
            result.exception.toString(),
            stackTrace: StackTrace.current,
          );
          return ErrorPage(error: "Error in fetching the event");
        }
        if (result.isLoading) {
          return const LoadingPage();
        }
        print("result: $result");
        final data = result.data?[queryName];
        if (data == null) {
          // Look for GraphQL errors in the response context
          final linkException = result.context.entry<HttpLinkResponseContext>();
          print("Link response: $linkException");
          final extensions = result.context.entry<ResponseExtensions>();
          print("Response extensions: $extensions");

          // Get a more specific error message
          String errorMessage = "The requested event could not be found.";
          if (queryName == "class_events_by_pk") {
            errorMessage =
                "Event ID $classEventId was not found or may have been deleted.";
          } else if (queryName == "classes") {
            errorMessage =
                "Class with URL $urlSlug was not found or may have been deleted.";
          }

          CustomErrorHandler.captureException(
            "GraphQL returned null for $queryName",
            stackTrace: StackTrace.current,
          );

          return ErrorPage(error: errorMessage);
        }

        try {
          if (queryName == "class_events_by_pk") {
            final classEvent = ClassEvent.fromJson(data);
            return SingleClassPage(
              clas: classEvent.classModel!,
              classEvent: classEvent,
            );
          } else {
            final item = (queryName == "classes" ? (data as List).first : data)
                as Map<String, dynamic>;
            final clas = ClassModel.fromJson(item);
            return SingleClassPage(
              clas: clas,
            );
          }
        } catch (e, st) {
          CustomErrorHandler.captureException(
            e.toString(),
            stackTrace: st,
          );
          return ErrorPage(
            error: "Error parsing data for $queryName: ${data.toString()}",
          );
        }
      },
    );
  }
}
