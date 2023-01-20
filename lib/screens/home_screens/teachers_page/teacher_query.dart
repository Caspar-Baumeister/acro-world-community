import 'dart:async';

import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/teacher_likes/change_like_on_teacher.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/HOME_SCREENS/teachers_page/teacher_like_query.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class TeacherQuery extends StatefulWidget {
  const TeacherQuery({Key? key}) : super(key: key);

  @override
  State<TeacherQuery> createState() => _TeacherQueryState();
}

class _TeacherQueryState extends State<TeacherQuery> {
  List<StreamSubscription> eventListeners = [];

  @override
  void dispose() {
    super.dispose();
    for (final eventListener in eventListeners) {
      eventListener.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context, listen: false);
    final EventBus eventBus = eventBusProvider.eventBus;

    return Query(
      options: QueryOptions(
        document: Queries.getAllTeacher,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        VoidCallback runRefetch = (() {
          try {
            refetch!();
          } catch (e) {
            print(e.toString());
          }
        });
        if (result.isLoading) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingWidget(
                onRefresh: () async => runRefetch(),
              ),
            ],
          );
        }

        eventListeners.add(eventBus.on<ChangeLikeEvent>().listen((event) {
          runRefetch();
        }));

        List<TeacherModel> teachers = [];

        result.data!["teachers"]
            .forEach((teacher) => teachers.add(TeacherModel.fromJson(teacher)));

        return RefreshIndicator(
          color: PRIMARY_COLOR,
          onRefresh: (() async => runRefetch()),
          child: TeacherLikeQuery(
            teachers: teachers,
          ),
        );
      },
    );
  }
}
