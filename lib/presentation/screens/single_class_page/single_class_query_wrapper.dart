import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart' as provider;

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
    final userRole =
        provider.Provider.of<UserRoleProvider>(context, listen: false);

    final isCreator = userRole.isCreator;

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
      query = Queries.getClassEventWithClasByIdWithFavorite;
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
            stackTrace: result.exception!.originalStackTrace,
          );
          return ErrorPage(error: "Error in fetching the event");
        }
        if (result.isLoading) {
          return const LoadingPage();
        }
        final data = result.data?[queryName];
        if (data == null) {
          return const ErrorPage(
            error: "No data returned from server.",
          );
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
              isCreator: isCreator,
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
