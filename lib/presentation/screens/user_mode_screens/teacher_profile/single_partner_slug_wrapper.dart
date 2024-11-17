import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/screens/profile_base_screen.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class PartnerSlugWrapper extends StatelessWidget {
  const PartnerSlugWrapper({super.key, required this.teacherSlug});
  final String teacherSlug;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    if (userProvider.activeUser?.id == null) {
      return const LoadingPage();
    }
    return Query(
      options: QueryOptions(
          document: Queries.getTeacherBySlug,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {
            'teacher_slug': teacherSlug,
            "user_id": userProvider.activeUser!.id
          }),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          print("error in TeacherProfileQueryWrapper query");
          CustomErrorHandler.captureException(result?.exception.toString());
          return ErrorPage(error: result.exception.toString());
        } else if (userProvider.activeUser?.id == null) {
          return const ErrorPage(error: "no active user");
        } else if (result.isLoading) {
          return const LoadingPage();
        } else if (result.data != null && result.data?["teachers"] != null) {
          try {
            TeacherModel teacher =
                TeacherModel.fromJson(result.data!["teachers"].first);
            return ProfileBaseScreen(
              teacher: teacher,
              userId: userProvider.activeUser!.id!,
            );
          } catch (e) {
            CustomErrorHandler.captureException(e.toString(),
                stackTrace: StackTrace.current);
            return ErrorPage(error: e.toString());
          }
        } else {
          return const LoadingPage();
        }
      },
    );
  }
}
