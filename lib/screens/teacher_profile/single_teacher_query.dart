import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:acroworld/screens/teacher_profile/screens/profile_base_screen.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class SingleTeacherQuery extends StatelessWidget {
  const SingleTeacherQuery({super.key, required this.teacherId});
  final String teacherId;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Query(
      options: QueryOptions(
          document: Queries.getTeacherById,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {
            'teacher_id': teacherId,
            "user_id": userProvider.activeUser!.id
          }),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          print("error in TeacherProfileQueryWrapper query");
          print(result.exception);
          return ErrorPage(error: result.exception.toString());
        } else if (userProvider.activeUser?.id == null) {
          return const ErrorPage(error: "no active user");
        } else if (result.isLoading) {
          return const LoadingPage();
        } else if (result.data != null &&
            result.data?["teachers_by_pk"] != null) {
          TeacherModel teacher =
              TeacherModel.fromJson(result.data?["teachers_by_pk"]);

          return ProfileBaseScreen(
            teacher: teacher,
            userId: userProvider.activeUser!.id!,
          );
        } else {
          return const LoadingPage();
        }
      },
    );
  }
}
