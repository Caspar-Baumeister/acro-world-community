import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/loading/modern_loading_widget.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/class_event_calendar.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassEventCalenderQuery extends StatelessWidget {
  const ClassEventCalenderQuery(
      {super.key, required this.classId, this.isCreator = false});

  final String classId;
  final bool isCreator;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: Queries.getClassEventsByClassId,
            fetchPolicy: FetchPolicy.noCache,
            variables: {"class_id": classId}),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            print("error in Queries.getClassEventsByClassId");
            CustomErrorHandler.captureException(result.exception.toString());
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const ModernLoadingWidget();
          }

          List<ClassEvent> classEvents = [];
          try {
            result.data!["class_events"].forEach(
                (cEvent) => classEvents.add(ClassEvent.fromJson(cEvent)));
          } catch (e) {
            CustomErrorHandler.captureException(e.toString());
          }

          return ClassEventCalendar(
              kEvents: classEventToHash(classEvents), isCreator: isCreator);
        });
  }
}
