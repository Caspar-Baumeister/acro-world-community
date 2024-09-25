import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/class_event_calendar.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassEventCalenderQuery extends StatelessWidget {
  const ClassEventCalenderQuery({super.key, required this.classId});

  final String classId;

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
            print(result.exception);
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const LoadingWidget();
          }

          List<ClassEvent> classEvents = [];
          try {
            result.data!["class_events"].forEach(
                (cEvent) => classEvents.add(ClassEvent.fromJson(cEvent)));
          } catch (e) {
            print(e.toString());
          }

          return ClassEventCalendar(kEvents: classEventToHash(classEvents));
        });
  }
}
