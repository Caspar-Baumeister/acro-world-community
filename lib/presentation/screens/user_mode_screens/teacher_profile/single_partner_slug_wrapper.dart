import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/screens/profile_base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PartnerSlugWrapper extends ConsumerWidget {
  const PartnerSlugWrapper({super.key, required this.teacherSlug});
  final String teacherSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Query(
      options: QueryOptions(
        document: Queries.getTeacherBySlug,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'teacher_slug': teacherSlug,
          // Remove the user_id parameter
        },
      ),
      builder: (result, {refetch, fetchMore}) {
        if (result.hasException) {
          CustomErrorHandler.captureException(
            result.exception.toString(),
          );
          return ErrorPage(
            error: result.exception.toString(),
          );
        }
        if (result.isLoading) {
          return const LoadingPage();
        }
        final list = result.data?['teachers'] as List<dynamic>?;
        if (list == null || list.isEmpty) {
          return const ErrorPage(
            error: "Teacher not found",
          );
        }
        try {
          final teacher =
              TeacherModel.fromJson(list.first as Map<String, dynamic>);
          return ProfileBaseScreen(
            teacher: teacher,
          );
        } catch (e, st) {
          CustomErrorHandler.captureException(
            e.toString(),
            stackTrace: st,
          );
          return ErrorPage(error: e.toString());
        }
      },
    );
  }
}
