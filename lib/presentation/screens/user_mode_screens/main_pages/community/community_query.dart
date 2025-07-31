import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_body.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TeacherQuery extends ConsumerWidget {
  const TeacherQuery({
    super.key,
    required this.search,
    required this.isFollowed,
  });

  final String search;
  final bool isFollowed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(userRiverpodProvider);

    return authAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) {
        CustomErrorHandler.captureException(e.toString(), stackTrace: st);
        return const Center(child: Text("Error loading user"));
      },
      data: (user) {
        final userId = user?.id;
        QueryOptions options;

        if (userId == null) {
          options = QueryOptions(
            document: Queries.getTeacherForListWithoutUserID,
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {"search": "%$search%"},
          );
        } else if (isFollowed) {
          options = QueryOptions(
            document: Queries.getFollowedTeacherForList,
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {
              "user_id": userId,
              "search": "%$search%",
            },
          );
        } else {
          options = QueryOptions(
            document: Queries.getTeacherForList,
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {
              "user_id": userId,
              "search": "%$search%",
            },
          );
        }

        return Query(
          options: options,
          builder: (result, {refetch, fetchMore}) {
            if (result.hasException) {
              return Center(
                child: Text("Error: ${result.exception.toString()}"),
              );
            }

            if (result.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingWidget(onRefresh: () async {
                    try {
                      refetch!();
                    } catch (e, st) {
                      CustomErrorHandler.captureException(
                        e.toString(),
                        stackTrace: st,
                      );
                    }
                  }),
                ],
              );
            }

            final data = result.data;
            List<TeacherModel> teachers = [];

            if (isFollowed) {
              final list =
                  data?["me"]?[0]?["followed_teacher"] as List<dynamic>?;
              if (list != null) {
                for (final item in list) {
                  teachers.add(TeacherModel.fromJson(item["teacher"]));
                }
              }
            } else {
              final list = data?["teachers"] as List<dynamic>?;
              if (list != null) {
                for (final item in list) {
                  teachers.add(TeacherModel.fromJson(item));
                }
              }
            }

            return RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              onRefresh: () async {
                try {
                  refetch!();
                } catch (e, st) {
                  CustomErrorHandler.captureException(
                    e.toString(),
                    stackTrace: st,
                  );
                }
              },
              child: CommunityBody(teachers: teachers),
            );
          },
        );
      },
    );
  }
}
