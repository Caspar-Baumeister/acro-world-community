import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/review_model.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Provider for fetching user's comment for a specific teacher
final userCommentProvider =
    FutureProvider.family<ReviewModel?, String>((ref, teacherId) async {
  final client = GraphQLClientSingleton().client;
  final currentUser = ref.read(userRiverpodProvider).value;

  if (currentUser == null) return null;

  final result = await client.query(QueryOptions(
    document: Queries.getUserCommentForTeacher,
    variables: {
      'teacher_id': teacherId,
      'user_id': currentUser.id!,
    },
  ));

  if (result.hasException) {
    throw Exception('Failed to fetch user comment: ${result.exception}');
  }

  final comments = result.data?['comments'] as List<dynamic>? ?? [];
  if (comments.isEmpty) return null;

  return ReviewModel.fromJson(comments.first);
});

// Provider for fetching comments for a specific teacher
final commentsProvider =
    FutureProvider.family<List<ReviewModel>, String>((ref, teacherId) async {
  final client = GraphQLClientSingleton().client;

  final result = await client.query(QueryOptions(
    document: Queries.getCommentsForTeacher,
    variables: {
      'teacher_id': teacherId,
      'limit': 20,
      'offset': 0,
    },
  ));

  if (result.hasException) {
    throw Exception('Failed to fetch comments: ${result.exception}');
  }

  final comments = result.data?['comments'] as List<dynamic>? ?? [];
  return comments.map((comment) => ReviewModel.fromJson(comment)).toList();
});

// Provider for comment statistics
final commentStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, teacherId) async {
  final client = GraphQLClientSingleton().client;

  final result = await client.query(QueryOptions(
    document: Queries.getCommentsStatsForTeacher,
    variables: {
      'teacher_id': teacherId,
    },
  ));

  if (result.hasException) {
    throw Exception('Failed to fetch comment stats: ${result.exception}');
  }

  final aggregate = result.data?['comments_aggregate']?['aggregate'];
  return {
    'count': aggregate?['count'] ?? 0,
    'averageRating': aggregate?['avg']?['rating'] ?? 0.0,
  };
});

// Notifier for managing comment operations
class CommentsNotifier extends StateNotifier<AsyncValue<List<ReviewModel>>> {
  CommentsNotifier(this._client, this._ref) : super(const AsyncValue.loading());

  final GraphQLClient _client;
  final Ref _ref;
  String? _currentTeacherId;

  Future<void> loadComments(String teacherId) async {
    _currentTeacherId = teacherId;
    state = const AsyncValue.loading();

    try {
      final result = await _client.query(QueryOptions(
        document: Queries.getCommentsForTeacher,
        variables: {
          'teacher_id': teacherId,
          'limit': 20,
          'offset': 0,
        },
      ));

      if (result.hasException) {
        state = AsyncValue.error(result.exception!, StackTrace.current);
        return;
      }

      final comments = result.data?['comments'] as List<dynamic>? ?? [];
      final reviewModels =
          comments.map((comment) => ReviewModel.fromJson(comment)).toList();
      state = AsyncValue.data(reviewModels);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addOrUpdateComment(String content, int rating, String teacherId,
      {String? commentId}) async {
    // Refresh user data to get the most up-to-date information including image URL
    _ref.invalidate(userRiverpodProvider);

    // Get current user from the user provider
    final currentUser = _ref.read(userRiverpodProvider).value?.id;

    if (currentUser == null) {
      state = AsyncValue.error('User not authenticated', StackTrace.current);
      return;
    }

    try {
      QueryResult result;

      if (commentId != null) {
        // Update existing comment
        final updateVariables = {
          'id': commentId,
          'content': content,
          'rating': rating,
        };

        print('🔄 [UPDATE COMMENT] Starting update mutation:');
        print('  📝 Comment ID: $commentId');
        print('  💬 Content: "$content"');
        print('  ⭐ Rating: $rating');
        print('  📋 Variables: $updateVariables');
        print('  📄 Mutation: ${Mutations.updateCommentMutation}');

        result = await _client.mutate(MutationOptions(
          document: Mutations.updateCommentMutation,
          variables: updateVariables,
        ));

        print('✅ [UPDATE COMMENT] Mutation completed:');
        print('  🚨 Has Exception: ${result.hasException}');
        if (result.hasException) {
          print('  ❌ Exception: ${result.exception}');
        }
        print('  📊 Data: ${result.data}');
      } else {
        // Create new comment
        final insertVariables = {
          'content': content,
          'rating': rating,
          'teacher_id': teacherId,
          'user_id': currentUser,
        };

        print('🆕 [CREATE COMMENT] Starting insert mutation:');
        print('  💬 Content: "$content"');
        print('  ⭐ Rating: $rating');
        print('  👨‍🏫 Teacher ID: $teacherId');
        print('  👤 User ID: $currentUser');
        print('  📋 Variables: $insertVariables');
        print('  📄 Mutation: ${Mutations.insertCommentMutation}');

        result = await _client.mutate(MutationOptions(
          document: Mutations.insertCommentMutation,
          variables: insertVariables,
        ));

        print('✅ [CREATE COMMENT] Mutation completed:');
        print('  🚨 Has Exception: ${result.hasException}');
        if (result.hasException) {
          print('  ❌ Exception: ${result.exception}');
        }
        print('  📊 Data: ${result.data}');
      }

      if (result.hasException) {
        state = AsyncValue.error(result.exception!, StackTrace.current);
        return;
      }

      // Reload comments to include the new/updated one
      if (_currentTeacherId == teacherId) {
        await loadComments(teacherId);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Keep the old method for backward compatibility
  Future<void> addComment(String content, int rating, String teacherId) async {
    await addOrUpdateComment(content, rating, teacherId);
  }

  Future<void> updateComment(
      String commentId, String content, int rating) async {
    try {
      final updateVariables = {
        'id': commentId,
        'content': content,
        'rating': rating,
      };

      print('🔄 [STANDALONE UPDATE] Starting standalone update mutation:');
      print('  📝 Comment ID: $commentId');
      print('  💬 Content: "$content"');
      print('  ⭐ Rating: $rating');
      print('  📋 Variables: $updateVariables');

      final result = await _client.mutate(MutationOptions(
        document: Mutations.updateCommentMutation,
        variables: updateVariables,
      ));

      print('✅ [STANDALONE UPDATE] Mutation completed:');
      print('  🚨 Has Exception: ${result.hasException}');
      if (result.hasException) {
        print('  ❌ Exception: ${result.exception}');
      }
      print('  📊 Data: ${result.data}');

      if (result.hasException) {
        state = AsyncValue.error(result.exception!, StackTrace.current);
        return;
      }

      // Reload comments to reflect the update
      if (_currentTeacherId != null) {
        await loadComments(_currentTeacherId!);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      final deleteVariables = {
        'id': commentId,
      };

      print('🗑️ [DELETE COMMENT] Starting delete mutation:');
      print('  📝 Comment ID: $commentId');
      print('  📋 Variables: $deleteVariables');

      final result = await _client.mutate(MutationOptions(
        document: Mutations.deleteCommentMutation,
        variables: deleteVariables,
      ));

      print('✅ [DELETE COMMENT] Mutation completed:');
      print('  🚨 Has Exception: ${result.hasException}');
      if (result.hasException) {
        print('  ❌ Exception: ${result.exception}');
      }
      print('  📊 Data: ${result.data}');

      if (result.hasException) {
        state = AsyncValue.error(result.exception!, StackTrace.current);
        return;
      }

      // Reload comments to reflect the deletion
      if (_currentTeacherId != null) {
        await loadComments(_currentTeacherId!);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Provider for the comments notifier
final commentsNotifierProvider =
    StateNotifierProvider<CommentsNotifier, AsyncValue<List<ReviewModel>>>(
        (ref) {
  final client = GraphQLClientSingleton().client;
  return CommentsNotifier(client, ref);
});
