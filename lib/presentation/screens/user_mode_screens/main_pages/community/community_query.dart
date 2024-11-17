import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_body.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class TeacherQuery extends StatefulWidget {
  const TeacherQuery({
    super.key,
    required this.search,
    required this.isFollowed,
  });

  final String search;
  final bool isFollowed;

  @override
  State<TeacherQuery> createState() => _TeacherQueryState();
}

class _TeacherQueryState extends State<TeacherQuery> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    // if user is not logged in query getTeacherForListWithoutUserID
    // else if widget.isFollowed query getFollowedTeacherForList
    // else query getTeacherForList

    QueryOptions? queryOptions;
    if (userProvider.activeUser?.id == null) {
      queryOptions = QueryOptions(
          document: Queries.getTeacherForListWithoutUserID,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {"search": "%${widget.search}%"});
    } else if (widget.isFollowed) {
      queryOptions = QueryOptions(
          document: Queries.getFollowedTeacherForList,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {
            "user_id": userProvider.activeUser!.id!,
            "search": "%${widget.search}%"
          });
    } else {
      queryOptions = QueryOptions(
          document: Queries.getTeacherForList,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {
            "user_id": userProvider.activeUser!.id!,
            "search": "%${widget.search}%"
          });
    }

    return Query(
      options: queryOptions,
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return ErrorWidget(result.exception.toString());
        }
        VoidCallback runRefetch = (() {
          try {
            refetch!();
          } catch (e, s) {
            CustomErrorHandler.captureException(e.toString(), stackTrace: s);
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
            color: CustomColors.primaryColor,
            onRefresh: (() async => runRefetch()),
            child: CommunityBody(
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
