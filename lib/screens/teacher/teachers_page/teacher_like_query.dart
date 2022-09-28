// wrap around teacher but after teacher query
// fetches all the teacher ids that I liked (to color them different and run dislike if clicked again)
// include eventbus that is triggert if you like or dislike a teacher

import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/teacher/teachers_page/teacher_body.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class TeacherLikeQuery extends StatelessWidget {
  const TeacherLikeQuery({Key? key, required this.teachers}) : super(key: key);

  final List<TeacherModel> teachers;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Query(
        options: QueryOptions(
            document: Queries.getTeachersILike,
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {"user_id": userProvider.activeUser!.id!}),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          VoidCallback runRefetch = (() {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
              // print(e);
            }
          });
          if (result.hasException) {
            // TODO SHOW EXEPTION SCREEN
            return RefreshIndicator(
                onRefresh: () async => runRefetch(),
                child: Text(result.exception.toString()));
          }

          if (result.isLoading) {
            return const Loading();
          }

          List<String> teachersILike = [];

          result.data!["teacher_likes"]
              .forEach((teacher) => teachersILike.add(teacher["teacher_id"]));

          print(teachersILike);

          return TeacherBody(teachers: teachers, teachersILike: teachersILike);
        });
  }
}
