import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/teacher/teacher_body.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TeacherQuery extends StatelessWidget {
  const TeacherQuery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

        if (result.isLoading) {
          return const Loading();
        }

        VoidCallback runRefetch = (() {
          try {
            refetch!();
          } catch (e) {
            print(e.toString());
            // print(e);
          }
        });

        List<TeacherModel> teachers = [];

        result.data!["teachers"]
            .forEach((teacher) => teachers.add(TeacherModel.fromJson(teacher)));

        print(teachers[0].toString());

        // for (Map<String, dynamic> json in result.data!["teachers"]) {
        //   teachers.add(TeacherModel.fromJson(json));
        // }

        return RefreshIndicator(
          onRefresh: (() async => runRefetch()),
          child: TeacherBody(
            teachers: teachers,
          ),
        );
      },
    );
  }
}
