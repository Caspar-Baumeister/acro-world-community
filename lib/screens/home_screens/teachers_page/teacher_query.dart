import 'dart:async';

import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/teachers_page/teacher_body.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:acroworld/screens/no_wifi_page.dart';

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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Query(
      options: QueryOptions(
          document: Queries.getTeacherForList,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {"user_id": userProvider.activeUser!.id!}),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return const NoWifePage(
            followUpWidget: TeacherQuery(),
          );
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
        if (result.data?["teachers"] == null) {
          return ErrorWidget("Something went wrong, try again later");
        }

        List<TeacherModel> teachers = [];

        result.data!["teachers"]
            .forEach((teacher) => teachers.add(TeacherModel.fromJson(teacher)));

        return RefreshIndicator(
          color: PRIMARY_COLOR,
          onRefresh: (() async => runRefetch()),
          child: TeacherBody(teachers: teachers),
        );
      },
    );
  }
}
