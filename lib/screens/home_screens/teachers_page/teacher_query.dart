import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/teachers_page/teacher_body.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class TeacherQuery extends StatefulWidget {
  const TeacherQuery({
    Key? key,
    required this.search,
    required this.isFollowed,
  }) : super(key: key);

  final String search;
  final bool isFollowed;

  @override
  State<TeacherQuery> createState() => _TeacherQueryState();
}

class _TeacherQueryState extends State<TeacherQuery> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Query(
      options: widget.isFollowed
          ? QueryOptions(
              document: Queries.getFollowedTeacherForList,
              fetchPolicy: FetchPolicy.networkOnly,
              variables: {
                  "user_id": userProvider.activeUser!.id!,
                  "search": "%${widget.search}%"
                })
          : QueryOptions(
              document: Queries.getTeacherForList,
              fetchPolicy: FetchPolicy.networkOnly,
              variables: {
                  "user_id": userProvider.activeUser!.id!,
                  "search": "%${widget.search}%"
                }),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return ErrorWidget(result.exception.toString());
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
        if (result.hasException) {
          return ErrorWidget(result.exception.toString());
        }
        if (result.data?["teachers"] != null ||
            result.data?["me"]?[0]?["followed_teacher"] != null) {
          List<TeacherModel> teachers = [];

          if (widget.isFollowed &&
              result.data?["me"]?[0]?["followed_teacher"] != null) {
            result.data!["me"]![0]!["followed_teacher"]!.forEach((teacher) =>
                teachers.add(TeacherModel.fromJson(teacher["teacher"])));
          }
          if (!widget.isFollowed && result.data?["teachers"] != null) {
            result.data!["teachers"].forEach(
                (teacher) => teachers.add(TeacherModel.fromJson(teacher)));
          }

          return RefreshIndicator(
            color: PRIMARY_COLOR,
            onRefresh: (() async => runRefetch()),
            child: TeacherBody(
              teachers: teachers,
            ),
          );
        } else {
          return ErrorWidget(
              "something went wrong when fetching teacher, please try again later");
        }
      },
    );
  }
}
