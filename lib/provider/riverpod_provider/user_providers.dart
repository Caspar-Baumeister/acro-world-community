import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final userRiverpodProvider = FutureProvider.autoDispose<User?>((ref) async {
  // 1️⃣ Watch auth state
  final auth = ref.watch(authProvider);
  // If not authenticated, clear any cached data and return null
  if (auth.value?.status != AuthStatus.authenticated ||
      auth.value?.token == null) {
    return null;
  }

  // 2️⃣ Fetch “me” from GraphQL
  try {
    final client = GraphQLClientSingleton().client;
    final result = await client.query(
      QueryOptions(
        document: Queries.getMe,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      // If token is bad, force logout
      await ref.read(authProvider.notifier).signOut();
      CustomErrorHandler.captureException(
        result.exception.toString(),
        stackTrace: result.exception!.originalStackTrace,
      );
      return null;
    }

    final list = result.data?['me'] as List<dynamic>?;
    if (list == null || list.isEmpty) {
      // No “me” → sign out
      await ref.read(authProvider.notifier).signOut();
      return null;
    }

    // 3️⃣ Parse and return the User

    return User.fromJson(list.first as Map<String, dynamic>);
  } catch (e, st) {
    CustomErrorHandler.captureException(e.toString(), stackTrace: st);
    return null;
  }
});

class UserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() => ref.watch(userRiverpodProvider.future);

  /// Apply arbitrary field updates
  Future<bool> updateFields(Map<String, dynamic> updates) async {
    final current = state.value;
    if (current == null || updates.isEmpty) return false;

    state = const AsyncValue.loading();

    try {
      final res = await GraphQLClientSingleton().client.mutate(MutationOptions(
            document: gql(Mutations.updateUser),
            variables: {'id': current.id, 'changes': updates},
          ));

      if (res.hasException) {
        throw res.exception!;
      }

      final updatedJson =
          res.data!['update_users_by_pk'] as Map<String, dynamic>;
      final updatedUser = User.fromJson(updatedJson);

      state = AsyncValue.data(updatedUser);
      return true;
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      state = AsyncValue.data(current);
      return false;
    }
  }
}

final userNotifierProvider =
    AsyncNotifierProvider<UserNotifier, User?>(UserNotifier.new);
