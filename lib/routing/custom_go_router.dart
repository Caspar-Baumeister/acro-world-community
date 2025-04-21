import 'package:acroworld/presentation/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/creator_profile_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/activities_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/discover_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authCheckProvider = FutureProvider<bool>(
  (ref) async {
    final token = await TokenSingletonService().getToken();
    if (token == null) return false;
    return ref.read(userProvider.notifier).setUserFromToken();
  },
);

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this.ref) {
    ref.listen(authCheckProvider, (_, __) => notifyListeners());
  }

  final Ref ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (_, state) {
      // still loading?
      if (auth.isLoading) return '/splash';

      // done loading, but no token → login
      if (auth.asData?.value == false && state.matchedLocation != '/login') {
        return '/login';
      }

      // have token but on login → home
      if (auth.asData?.value == true && state.matchedLocation == '/login') {
        return '/';
      }

      // insert your role+permissions guards here…
      // e.g. if (role==Teacher && path=='/user') return '/';
      return null;
    },
    routes: [
      /// AUTHENTICATION PAGES
      GoRoute(
        name: splashRoute,
        path: '/splash',
        builder: (_, __) => const LoadingPage(),
      ),
      GoRoute(
        path: '/auth',
        name: authRoute,
        builder: (context, state) => const Authenticate(),
      ),

      /// MAIN USER PAGES
      GoRoute(
        path: '/discover',
        name: discoverRoute,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const DiscoverPage()),
      ),
      GoRoute(
        path: '/activity',
        name: activitiesRoute,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const ActivitiesPage()),
      ),
      GoRoute(
        path: '/community',
        name: communityRoute,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const TeacherPage()),
      ),
      // Profile
      GoRoute(
        path: '/profile',
        name: profileRoute,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const ProfilePage()),
      ),

      /// CREATOR PAGES (Here the user has to be a creator (otherwise redirect to profile))

      GoRoute(
        path: '/creator-dashboard',
        name: creatorDashboardRoute,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CreatorProfilePage(),
        ),
      ),
      // ...
    ],
  );
});
