import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/error_page.dart';
import 'package:acroworld/screens/loading_page.dart';
import 'package:acroworld/screens/teacher_profile/screens/profile_base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class TeacherProfileQueryWrapper extends StatelessWidget {
  const TeacherProfileQueryWrapper({Key? key, required this.teacherId})
      : super(key: key);

  final String teacherId;

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
            }
          });
          if (result.hasException) {
            // TODO SHOW EXEPTION SCREEN
            return ErrorPage(error: result.exception.toString());
          }

          if (result.isLoading) {
            return LoadingPage(
              onRefresh: () async => runRefetch(),
            );
          }

          List<String> teachersILike = [];

          result.data!["teacher_likes"]
              .forEach((teacher) => teachersILike.add(teacher["teacher_id"]));
          return Query(
            options: QueryOptions(
                document: Queries.getTeacherById,
                fetchPolicy: FetchPolicy.networkOnly,
                variables: {'teacher_id': teacherId}),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                print("error in TeacherProfileQueryWrapper query");
                print(result.exception);
                return ErrorPage(error: result.exception.toString());
              } else if (result.isLoading) {
                return const LoadingPage();
              } else if (result.data != null &&
                  result.data?["teachers_by_pk"] != null) {
                TeacherModel teacher =
                    TeacherModel.fromJson(result.data?["teachers_by_pk"]);

                return ProfileBaseScreen(
                    teacher: teacher,
                    isLiked: teachersILike.contains(teacherId));
              } else {
                return const LoadingPage();
              }
            },
          );
        });
  }
}
