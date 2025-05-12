import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? token;
  const AuthState._({required this.status, this.token});
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.authenticated(this.token) : status = AuthStatus.authenticated;
  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        token = null;
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // initial loading…
    final tok = await TokenSingletonService().getToken();
    if (tok != null) {
      return AuthState.authenticated(tok);
    } else {
      return const AuthState.unauthenticated();
    }
  }

  Future<void> signOut() async {
    // show loading while we clear
    state = const AsyncValue.loading();

    // Invalidate any user-profile providers that watch auth
    ref.invalidate(userRiverpodProvider);
    ref.invalidate(userNotifierProvider);

    // remove token
    await TokenSingletonService().logout();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }

  Future<void> authenticate(String token) async {
    // show loading while we clear
    state = AsyncValue.data(AuthState.authenticated(token));
  }
}

/// 3) The provider you consume
final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
