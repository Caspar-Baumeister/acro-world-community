import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/events/widgets/slider_row_event_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class GetMyTeacherQueryWrapper extends StatelessWidget {
  const GetMyTeacherQueryWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return Query(
      options: QueryOptions(
          document: Queries.getFollowedTeachers,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'user_id': userProvider.activeUser!.id}),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        Future<void> runRefetch() async {
          try {
            refetch!();
          } catch (e) {
            print(e.toString());
          }
        }

        if (queryResult.hasException) {
          return ErrorWidget(queryResult.exception.toString());
        } else if (queryResult.isLoading) {
          return LoadingWidget(
            onRefresh: () => runRefetch(),
          );
        } else if (queryResult.data != null &&
            queryResult.data?["teachers"] != null) {
          List<TeacherModel> followedTeacher = [];

          if (queryResult.data?["teachers"].isNotEmpty) {
            followedTeacher = List<TeacherModel>.from(queryResult
                .data?["teachers"]
                .map((json) => TeacherModel.fromJson(json)));
          }

          List<EventModel> returnEvents = [];
          if (followedTeacher.isNotEmpty) {
            returnEvents =
                eventFilterProvider.activeEvents.where((EventModel event) {
              if (event.name == "Acro-Weekend Kiel") {}
              if (event.teachers == null || event.teachers!.isEmpty) {
                return false;
              }

              for (TeacherModel eventTeacher in event.teachers!) {
                for (TeacherModel followTeacher in followedTeacher) {
                  if (eventTeacher.id == followTeacher.id) {
                    return true;
                  }
                }
              }
              return false;
            }).toList();
          }

          return returnEvents.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SliderRowEventDashboard(
                    onViewAll: () => eventFilterProvider
                        .changeAllFollowedTeachers(followedTeacher),
                    header: "With your teacher",
                    events: returnEvents,
                  ),
                )
              : Container();
        } else {
          return Container();
        }
      },
    );
  }
}
