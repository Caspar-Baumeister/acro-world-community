import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final classFavoritesProvider =
    AsyncNotifierProvider<ClassFavoritesNotifier, Map<String, bool>>(
        ClassFavoritesNotifier.new);

class ClassFavoritesNotifier extends AsyncNotifier<Map<String, bool>> {
  @override
  Future<Map<String, bool>> build() async {
    final auth = ref.watch(authProvider);
    if (auth.value?.status != AuthStatus.authenticated) {
      return {};
    }
    return _fetchFavorites();
  }

  Future<Map<String, bool>> _fetchFavorites() async {
    try {
      final client = GraphQLClientSingleton().client;
      final result = await client.query(
        QueryOptions(
          document: gql('''
            query {
              me {
                class_favorits {
                  class_id
                }
              }
            }
          '''),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'GraphQL error fetching favorites: ${result.exception}',
          stackTrace: StackTrace.current,
        );
        throw result.exception!;
      }

      final favorites = <String, bool>{};
      final favList = result.data?['me']?[0]?['class_favorits'] ?? [];
      for (final fav in favList) {
        favorites[fav['class_id']] = true;
      }
      return favorites;
    } catch (e, st) {
      CustomErrorHandler.captureException(
        'Unexpected error in _fetchFavorites: ${e.toString()}',
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> toggleFavorite(String classId) async {
    try {
      final currentUser = ref.read(userRiverpodProvider).value;
      if (currentUser == null) {
        CustomErrorHandler.captureException(
          'Attempted to toggle favorite without authenticated user: userId is null',
        );
        return;
      }

      // Get current state safely
      final currentState = state.value ?? {};
      final newValue = !(currentState[classId] ?? false);

      // Optimistic update
      state = AsyncData({
        ...currentState,
        classId: newValue,
      });

      final client = GraphQLClientSingleton().client;
      final result = await client.mutate(
        MutationOptions(
          document: newValue
              ? Mutations.favoritizeClass
              : Mutations.unFavoritizeClass,
          variables: {
            'class_id': classId,
            if (!newValue) 'user_id': currentUser.id,
          },
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(
          'GraphQL error toggling favorite: ${result.exception}',
          stackTrace: StackTrace.current,
        );
        state = AsyncData(currentState); // Revert to previous state
        throw result.exception!;
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(
        'Unexpected error in toggleFavorite: ${e.toString()}',
        stackTrace: st,
      );
      rethrow;
    }
  }

  bool isFavorited(String classId) {
    return state.value?[classId] ?? false;
  }
}
