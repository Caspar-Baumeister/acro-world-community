import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final teacherLikesProvider =
    AsyncNotifierProvider<TeacherLikesNotifier, Map<String, bool>>(
  TeacherLikesNotifier.new,
);

class TeacherLikesNotifier extends AsyncNotifier<Map<String, bool>> {
  @override
  Future<Map<String, bool>> build() async {
    final auth = ref.watch(authProvider);
    if (auth.value?.status != AuthStatus.authenticated) {
      return {};
    }
    return _fetchLikedTeachers();
  }

  Future<Map<String, bool>> _fetchLikedTeachers() async {
    try {
      final client = GraphQLClientSingleton().client;
      final result = await client.query(
        QueryOptions(
          document: gql('''
            query {
              me {
                followed_teacher {
                  teacher_id
                }
              }
            }
          '''),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'GraphQL error fetching liked teachers: ${result.exception}',
          stackTrace: StackTrace.current,
        );
        throw result.exception!;
      }

      final likes = <String, bool>{};
      final likesList = result.data?['me']?[0]?['followed_teacher'] ?? [];
      for (final like in likesList) {
        likes[like['teacher_id']] = true;
      }
      return likes;
    } catch (e, st) {
      CustomErrorHandler.captureException(
        'Unexpected error in _fetchLikedTeachers: ${e.toString()}',
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> toggleTeacherLike(String teacherId) async {
    try {
      final currentUser = ref.read(userRiverpodProvider).value;
      if (currentUser == null) {
        CustomErrorHandler.captureException(
          'Attempted to toggle teacher like without authenticated user: userId is null',
        );
        return;
      }

      // Get current state safely
      final currentState = state.value ?? {};
      final newValue = !(currentState[teacherId] ?? false);

      // Optimistic update
      state = AsyncData({
        ...currentState,
        teacherId: newValue,
      });

      final client = GraphQLClientSingleton().client;
      final result = await client.mutate(
        MutationOptions(
          document: newValue ? Mutations.likeTeacher : Mutations.unlikeTeacher,
          variables: {
            'teacher_id': teacherId,
            if (!newValue) 'user_id': currentUser.id,
          },
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'GraphQL error toggling teacher like: ${result.exception}',
          stackTrace: StackTrace.current,
        );
        state = AsyncData(currentState); // Revert to previous state
        throw result.exception!;
      }

      // Show success message
      if (newValue) {
        showSuccessToast("Following partner");
      } else {
        showSuccessToast("Unfollowed partner");
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(
        'Unexpected error in toggleTeacherLike: ${e.toString()}',
        stackTrace: st,
      );
      rethrow;
    }
  }

  bool isTeacherLiked(String teacherId) {
    return state.value?[teacherId] ?? false;
  }
}
