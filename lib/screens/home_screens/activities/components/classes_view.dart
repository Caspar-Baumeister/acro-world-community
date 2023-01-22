import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/screens/classes/widgets/class_event_expanded_tile.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassesView extends StatelessWidget {
  const ClassesView({Key? key, required this.place, required this.day})
      : super(key: key);
  final Place? place;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    QueryOptions queryOptions;
    String selector;
    if (place == null) {
      queryOptions = QueryOptions(
        document: Queries.getClasses,
        fetchPolicy: FetchPolicy.networkOnly,
      );
      selector = 'classes';
    } else {
      queryOptions = QueryOptions(
        document: Queries.getClassesByLocation,
        variables: {
          'latitude': place!.latLng.latitude,
          'longitude': place!.latLng.longitude
        },
        fetchPolicy: FetchPolicy.networkOnly,
      );
      selector = 'classes_by_location_v1';
    }
    return Query(
        options: queryOptions,
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(child: LoadingWidget());
          }

          Future<void> runRefetch() async {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
            }
          }

          // TODO the query fetches for all dates. Implement an where(date equal to day)

          // List<ClassModel> classes = [];
          List<ClassEvent> classEvents = [];

          if (result.data!.keys.contains(selector) &&
              result.data![selector] != null) {
            result.data![selector].forEach((clas) {
              // classes.add(ClassModel.fromJson(clas));
              if (clas["class_events"] != null &&
                  clas["class_events"].isNotEmpty) {
                clas["class_events"].forEach((element) {
                  ClassEvent classEvent = ClassEvent.fromJson(element,
                      classModel: ClassModel.fromJson(clas),
                      teacherList: clas["class_teachers"]);

                  if (isSameDate(classEvent.date, day)) {
                    classEvents.add(classEvent);
                  }
                });
              }
            });
          }

          classEvents.sort((a, b) => b.date.isBefore(a.date) ? 1 : 0);
          return RefreshIndicator(
            onRefresh: () => runRefetch(),
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: classEvents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: ClassEventExpandedTile(
                      classEvent: classEvents[index],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
