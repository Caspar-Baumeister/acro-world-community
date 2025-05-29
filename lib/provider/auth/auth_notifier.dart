import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/exceptions/auth_exception.dart';
import 'package:acroworld/exceptions/gql_exceptions.dart'; // defines AuthException
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? token;
  const AuthState._({required this.status, this.token});
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.authenticated(String tok)
      : this._(status: AuthStatus.authenticated, token: tok);
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated, token: null);
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // on app startup, check if we already have a token
    final tok = await TokenSingletonService().getToken();
    return tok != null
        ? AuthState.authenticated(tok)
        : const AuthState.unauthenticated();
  }

  /// Call this from your SignIn screen:
  Future<void> signIn(String email, String password) async {
    // 1) show loading
    state = const AsyncValue.loading();

    try {
      // 2) attempt login via your service
      final response = await TokenSingletonService().login(email, password)
          as Map<String, dynamic>;

      // 3) GraphQL‐level errors?
      if (response['errors'] != null) {
        print('GraphQL errors: ${response['errors']}');
        final errs = extractGraphqlError(response);
        state = const AsyncValue.data(AuthState.unauthenticated());
        throw AuthException(
          error: errs,
        );
      }

      // 4) server returned success?
      if (response['error'] == false) {
        // TokenSingletonService.login should have stored the token.
        final tok = await TokenSingletonService().getToken();
        print("Login succeeded, token: $tok");
        if (tok == null) {
          state = const AsyncValue.data(AuthState.unauthenticated());
          throw Exception('Login succeeded but no token was saved.');
        }

        // 6) update our auth state
        state = AsyncValue.data(AuthState.authenticated(tok));
      } else {
        state = const AsyncValue.data(AuthState.unauthenticated());
        throw AuthException(
          error: 'Login failed. Please try again.',
        );
      }
    } catch (e, st) {
      // 7) expose error to UI
      if (e is AuthException) {
        // these are already displayed inline by your SignIn widget
        // leave state as "data(unauthenticated)" and rethrow so UI can pick it up
        rethrow;
      }
      // real system error → error page
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required bool isNewsletter,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await TokenSingletonService().register(
        email,
        password,
        name,
        isNewsletterEnabled: isNewsletter,
      ) as Map<String, dynamic>;

      if (response['errors'] != null) {
        final errs = extractGraphqlError(response);
        print('GraphQL errors: ${response['errors'][0]["message"]}');
        state = const AsyncValue.data(AuthState.unauthenticated());
        throw AuthException(
          error: errs,
        );
      }

      if (response['error'] == false) {
        final tok = await TokenSingletonService().getToken();
        if (tok == null) {
          state = const AsyncValue.data(AuthState.unauthenticated());
          throw Exception('No token after register');
        }

        state = AsyncValue.data(AuthState.authenticated(tok));
      } else {
        state = const AsyncValue.data(AuthState.unauthenticated());
        throw AuthException(
          error: 'Registration failed. Please try again.',
        );
      }
    } catch (e, st) {
      if (e is AuthException) {
        // these are already displayed inline by your SignIn widget
        // leave state as "data(unauthenticated)" and rethrow so UI can pick it up
        rethrow;
      }
      // real system error → error page
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    // clear token
    await TokenSingletonService().logout();

    // flip to unauthenticated
    state = const AsyncValue.data(AuthState.unauthenticated());
  }

  /// Deletes the current user’s account, then signs out.
  Future<void> deleteAccount() async {
    // 1) show loading
    state = const AsyncValue.loading();

    try {
      // 2) run the GraphQL mutation
      final client = GraphQLClientSingleton().client;
      final res = await client.mutate(
        MutationOptions(document: Mutations.deleteAccount),
      );

      if (res.hasException) {
        throw AuthException(
          error: 'Failed to delete account',
        );
      }

      final success = res.data?['delete_account']?['success'] as bool? ?? false;
      if (!success) {
        throw AuthException(
          error: 'Failed to delete account',
        );
      }

      // 3) clear token & invalidate user
      await TokenSingletonService().logout();

      // 4) flip to unauthenticated
      state = const AsyncValue.data(AuthState.unauthenticated());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
