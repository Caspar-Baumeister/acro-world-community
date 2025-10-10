// lib/routing/app_router.dart

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/presentation/screens/account_settings/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/presentation/screens/authentication_screens/confirm_email/confirm_email_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/forgot_password_screen/forgot_password.dart';
import 'package:acroworld/presentation/screens/authentication_screens/forgot_password_success_screen/forgot_password_success.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/create_creator_profile_page.dart.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/class_booking_summary_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/create_and_edit_event_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/creator_profile_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/dashboard_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/invites_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/my_events_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/stripe_pages/stripe_callback_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/user_answer_page/user_answer_page.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/favorites_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/location_search_screen/place_search_screen.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/activities_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/discover_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/filter_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/map_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/search/event_search_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/search/teacher_search_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/splash_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/single_partner_slug_wrapper.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/tickets_page.dart';
import 'package:acroworld/presentation/shells/main_page_shell.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1) The “root” key: for your full‐screen, outside‐the‐shell routes
final rootNavigatorKey = GlobalKey<NavigatorState>();

final userShellKey = GlobalKey<NavigatorState>();
final creatorShellKey = GlobalKey<NavigatorState>();

// class AuthChangeNotifier extends ChangeNotifier {
//   AuthChangeNotifier(this.ref) {
//     // Listen to the AsyncValue<AuthState> from authProvider
//     ref.listen<AsyncValue<AuthState>>(
//       authProvider,
//       (_, __) => notifyListeners(),
//     );
//   }
//   final Ref ref;
// }

// Expose it as a plain Riverpod provider:
// final goRouterRefreshProvider = Provider<AuthChangeNotifier>(
//   (ref) => AuthChangeNotifier(ref),
// );

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      navigatorKey: rootNavigatorKey,
      // refreshListenable: ref.watch(goRouterRefreshProvider),
      initialLocation: kIsWeb ? null : '/splash',
      errorBuilder: (context, state) {
        // Get the error message from the state
        final error = state.error?.toString() ?? 'An unknown error occurred';

        // Return the error page with the error message
        return ErrorPage(error: error);
      },
      routes: [
        // splash screen

        ShellRoute(
            navigatorKey: userShellKey,
            builder: (ctx, state, child) {
              return MainPageShell(child: child);
            },
            routes: [
              GoRoute(
                path: '/',
                name: discoverRoute,
                pageBuilder: (ctx, state) => NoTransitionPage(
                  child: const DiscoverPage(),
                ),
              ),
              GoRoute(
                path: '/activity',
                name: activitiesRoute,
                pageBuilder: (ctx, state) =>
                    NoTransitionPage(child: const ActivitiesPage()),
              ),
              GoRoute(
                path: '/community',
                name: communityRoute,
                pageBuilder: (ctx, state) =>
                    NoTransitionPage(child: const TeacherPage()),
              ),
              GoRoute(
                path: '/profile',
                name: profileRoute,
                pageBuilder: (ctx, state) =>
                    NoTransitionPage(child: const ProfilePage()),
              ),
              GoRoute(
                path: '/tickets',
                name: ticketsRoute,
                pageBuilder: (ctx, state) =>
                    NoTransitionPage(child: const TicketsPage()),
              ),
              GoRoute(
                path: '/favorites',
                name: favoritesRoute,
                pageBuilder: (ctx, state) =>
                    NoTransitionPage(child: const FavoritesPage()),
              ),
              GoRoute(
                path: '/event-search',
                name: eventSearchRoute,
                pageBuilder: (ctx, state) =>
                    NoTransitionPage(child: const EventSearchPage()),
              ),
              GoRoute(
                path: '/teacher-search',
                name: teacherSearchRoute,
                pageBuilder: (ctx, state) =>
                    NoTransitionPage(child: const TeacherSearchPage()),
              ),
            ]),
        ////////////////////
        /// CREATOR MODE ///
        ////////////////////
        ShellRoute(
            navigatorKey: creatorShellKey,
            builder: (ctx, state, child) {
              return MainPageShell(child: child);
            },
            routes: [
              GoRoute(
                path: '/creator-profile',
                name: creatorProfileRoute,
                pageBuilder: (ctx, state) => NoTransitionPage(
                  child: const CreatorProfilePage(),
                ),
              ),
              GoRoute(
                path: '/creator-dashboard',
                name: creatorDashboardRoute,
                pageBuilder: (ctx, state) => NoTransitionPage(
                  child: const DashboardPage(),
                ),
              ),
              // invitePage
              GoRoute(
                path: '/invite',
                name: invitesRoute,
                pageBuilder: (ctx, state) => NoTransitionPage(
                  child: const InvitesPage(),
                ),
              ),
              GoRoute(
                path: '/my-events',
                name: myEventsRoute,
                pageBuilder: (ctx, state) => NoTransitionPage(
                  child: const MyEventsPage(),
                ),
              ),
            ]),
        GoRoute(
            path: '/splash',
            name: splashRoute,
            builder: (ctx, state) {
              // This is just a placeholder; you can replace it with your actual splash screen
              return const SplashScreen();
            }),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          // add queryParams to the path with ?isEditing
          path: '/edit-creator-profile',
          name: editCreatorProfileRoute,
          builder: (ctx, state) {
            final isEditing = state.uri.queryParameters['isEditing'] == 'true';
            return CreateCreatorProfilePage(isEditing: isEditing);
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/place-search',
          name: placeSearchRoute,
          builder: (context, state) => const PlaceSearchScreen(),
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/create-edit-event',
          name: createEditEventRoute,
          builder: (ctx, state) {
            // default to create; to edit, pass isEditing=true in queryParams
            final isEditing = state.uri.queryParameters['isEditing'] == 'true';
            final eventSlug = state.uri.queryParameters['eventSlug'];
            return CreateAndEditEventPage(
              isEditing: isEditing,
              eventSlug: eventSlug,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const FilterPage(),
          path: '/filter',
          name: filterRoute,
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/account-settings',
          name: accountSettingsRoute,
          pageBuilder: (ctx, state) =>
              NoTransitionPage(child: const AccountSettingsPage()),
        ),

        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/edit-userdata',
          name: editUserDataRoute,
          builder: (context, state) => const EditUserdataPage(),
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/verify-email',
          name: verifyEmailRoute,
          builder: (context, state) => const ConfirmEmailPage(),
        ),

        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/map',
          name: mapRoute,
          pageBuilder: (ctx, state) => NoTransitionPage(child: const MapPage()),
        ),

        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/auth',
          name: authRoute,
          builder: (ctx, state) {
            final from = state.uri.queryParameters['from'];
            final initShowSignIn =
                state.uri.queryParameters['initShowSignIn'] == 'true';
            return Authenticate(
              initShowSignIn: initShowSignIn,
              redirectAfter: from,
            );
          },
        ),

        /// AUTHENTICATION

        // ForgotPassword
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/forgot-password',
          name: forgotPasswordRoute,
          builder: (ctx, state) {
            final email = state.uri.queryParameters['email'];
            return ForgotPassword(initialEmail: email);
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/forgot-password-success',
          name: forgotPasswordSuccessRoute,
          builder: (ctx, state) => ForgotPasswordSuccess(
            email: state.uri.queryParameters['email'] ?? '',
          ),
        ),

        /// PARTNER / TEACHER PROFILE BY SLUG
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/partner/:slug',
          name: partnerSlugRoute,
          builder: (ctx, state) {
            final slug = state.pathParameters['slug']!;
            return PartnerSlugWrapper(teacherSlug: slug);
          },
        ),

        /// SINGLE CLASS / EVENT WRAPPER
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/event/:urlSlug',
          name: singleEventWrapperRoute,
          builder: (ctx, state) {
            CustomErrorHandler.logDebug("full path: ${state.uri.toString()}");
            final slug = state.pathParameters['urlSlug']!;
            final classEventId = state.uri.queryParameters['event'];
            return SingleEventQueryWrapper(
              urlSlug: slug,
              classEventId: classEventId,
            );
          },
        ),

        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/create-creator-profile',
          name: createCreatorProfileRoute,
          builder: (ctx, state) => const CreateCreatorProfilePage(),
        ),

        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/stripe-callback',
          name: stripeCallbackRoute,
          builder: (ctx, state) => StripeCallbackPage(
            stripeId: state.pathParameters['stripeId'],
          ),
        ),

        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: "/class-booking-summary/:classEventId",
          name: classBookingSummaryRoute,
          pageBuilder: (ctx, state) => NoTransitionPage(
            child: ClassBookingSummaryPage(
              classEventId: state.pathParameters['classEventId']!,
            ),
          ),
        ),

        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/user-answer',
          name: userAnswerRoute,
          builder: (ctx, state) {
            final userId = state.pathParameters['userId']!;
            final classEventId = state.pathParameters['classEventId']!;
            return UserAnswerPage(userId: userId, classEventId: classEventId);
          },
        ),
        //loading page
        GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: '/loading',
            name: loadingRoute,
            builder: (ctx, state) => LoadingPage()),

        // error page
        GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: '/auth-error',
            name: errorRoute,
            builder: (ctx, state) {
              final error = state.uri.queryParameters['error'];
              return AuthErrorPage(
                error: error ?? 'An unknown error occurred.',
              );
            }),
      ]);
});

// create AuthErrorPage with displaying error message and a button to go back to the auth page
class AuthErrorPage extends StatelessWidget {
  final String error;

  const AuthErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error),
            const SizedBox(height: 16),
            ModernButton(
              onPressed: () {
                context.go('/auth');
              },
              text: 'Go to Auth Page',
            ),
          ],
        ),
      ),
    );
  }
}
