import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class SingleEventQueryWrapper extends StatelessWidget {
  const SingleEventQueryWrapper(
      {super.key, required this.classId, this.classEventId});

  final String classId;
  final String? classEventId;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Query(
      options: QueryOptions(
          document: classEventId == null
              ? Queries.getClassByIdWithFavorite
              : Queries.getClassEventWithClasByIdWithFavorite,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: classEventId == null
              ? {'class_id': classId, "user_id": userProvider.activeUser!.id}
              : {
                  'class_event_id': classEventId,
                  "user_id": userProvider.activeUser!.id
                }),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (queryResult.hasException) {
          return ErrorPage(error: queryResult.exception.toString());
        } else if (queryResult.isLoading) {
          return const LoadingPage();
        } else if (queryResult.data != null &&
            queryResult.data?["classes_by_pk"] != null) {
          try {
            ClassModel clas =
                ClassModel.fromJson(queryResult.data?["classes_by_pk"]);
            return SingleClassPage(clas: clas);
          } catch (e, trace) {
            CustomErrorHandler.captureException(e, stackTrace: trace);
            return ErrorPage(
                error:
                    "An unexpected error occured, when transforming the classes_by_pk data to an object with classId $classId");
          }
        } else if (queryResult.data != null &&
            queryResult.data?["class_events_by_pk"] != null) {
          try {
            ClassEvent classEvent =
                ClassEvent.fromJson(queryResult.data?["class_events_by_pk"]);
            print("success");
            print(classEvent.classModel!);
            return SingleClassPage(
              clas: classEvent.classModel!,
              classEvent: classEvent,
            );
          } catch (e, trace) {
            CustomErrorHandler.captureException(e, stackTrace: trace);
            return ErrorPage(
                error:
                    "An unexpected error occured, when transforming the class_event_by_pk data to an object with classEventId $classEventId");
          }
        } else {
          CustomErrorHandler.captureException(
              "An unexpected error occured, when fetching the class / classEvent with id $classId / $classEventId",
              stackTrace: StackTrace.current);
          return ErrorPage(
              error:
                  "An unexpected error occured, when fetching the class / classEvent with id $classId / $classEventId");
        }
      },
    );
  }
}
