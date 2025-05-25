// lib/routing/app_router.dart

import 'package:acroworld/presentation/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/presentation/screens/account_settings/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/presentation/screens/authentication_screens/confirm_email/confirm_email_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/email_verification_page/email_verification_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/forgot_password_screen/forgot_password.dart';
import 'package:acroworld/presentation/screens/authentication_screens/forgot_password_success_screen/forgot_password_success.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/create_creator_profile_page.dart.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/class_booking_summary_page/class_booking_summary_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/edit_class_description.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/create_and_edit_event_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/question_page.dart/question_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/creator_profile_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/dashboard_page/dashboard_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/invites_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/my_events_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/stripe_pages/stripe_callback_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/user_answer_page/user_answer_page.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/essentials/essentials.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/location_search_screen/place_search_screen.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/activities_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/discover_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/filter_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/map_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/single_partner_slug_wrapper.dart';
import 'package:acroworld/presentation/shells/main_page_shell.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(this.ref) {
    // Listen to the AsyncValue<AuthState> from authProvider
    ref.listen<AsyncValue<AuthState>>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }
  final Ref ref;
}

// Expose it as a plain Riverpod provider:
final goRouterRefreshProvider = Provider<AuthChangeNotifier>(
  (ref) => AuthChangeNotifier(ref),
);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      navigatorKey: rootNavigatorKey,
      refreshListenable: ref.watch(goRouterRefreshProvider),
      initialLocation: '/discover',
      redirect: (BuildContext _, GoRouterState state) {
        final auth = ref.read(authProvider);
        final loc = state.matchedLocation; // the “clean” path, no query
        final from =
            state.uri.queryParameters['from']; // maybe “…?from=/event/…”

        final loggingIn = loc == '/auth';

        return auth.when(
          loading: () => null,
          error: (_, __) => '/auth-error',
          data: (authState) {
            // 1) Not logged in → guard all non-/auth, non-/forgot routes
            if (authState.status == AuthStatus.unauthenticated &&
                !loggingIn &&
                !loc.startsWith('/forgot-password')) {
              final encoded = Uri.encodeComponent('$loc?${state.uri.query}');
              return '/auth?from=$encoded';
            }
            // 2) Just logged in and you’re on the “/auth” page → go back to `from` or to discover
            if (authState.status == AuthStatus.authenticated && loggingIn) {
              return from != null ? Uri.decodeComponent(from) : '/discover';
            }
            // 3) No redirect
            return null;
          },
        );
      },
      routes: [
        ShellRoute(
            builder: (ctx, state, child) {
              return MainPageShell(child: child);
            },
            routes: [
              GoRoute(
                path: '/discover',
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
                  routes: [
                    GoRoute(
                      path: '/place-search',
                      name: placeSearchRoute,
                      builder: (context, state) => const PlaceSearchScreen(),
                    )
                  ]),
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
            ]),
        ////////////////////
        /// CREATOR MODE ///
        ////////////////////
        ShellRoute(
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
                  routes: [
                    GoRoute(
                      // add queryParams to the path with ?isEditing
                      path: '/edit-creator-profile',
                      name: editCreatorProfileRoute,
                      builder: (ctx, state) {
                        final isEditing =
                            state.uri.queryParameters['isEditing'] == 'true';
                        return CreateCreatorProfilePage(isEditing: isEditing);
                      },
                    ),
                  ]),
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
                routes: [
                  GoRoute(
                    path: '/create-edit-event',
                    name: createEditEventRoute,
                    builder: (ctx, state) {
                      // default to create; to edit, pass isEditing=true in queryParams
                      final isEditing =
                          state.pathParameters['isEditing'] == 'true';
                      return CreateAndEditEventPage(isEditing: isEditing);
                    },
                    routes: [
                      GoRoute(
                        path: '/edit-description',
                        name: editDescriptionRoute,
                        builder: (ctx, state) {
                          final initialText =
                              state.pathParameters['initialText'] ?? '';
                          // You’ll still need a way to supply onTextUpdated; consider using a provider or passing a callback in extra.
                          return EditClassDescriptionPage(
                            initialText: initialText,
                            onTextUpdated: (newText) {/* … */},
                          );
                        },
                      ),
                      GoRoute(
                        path: '/question',
                        name: questionRoute,
                        builder: (ctx, state) => const QuestionPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
        GoRoute(
          builder: (context, state) => const FilterPage(),
          path: '/filter',
          name: filterRoute,
        ),
        GoRoute(
          path: '/account-settings',
          name: accountSettingsRoute,
          pageBuilder: (ctx, state) =>
              NoTransitionPage(child: const AccountSettingsPage()),
        ),

        GoRoute(
          path: '/edit-userdata',
          name: editUserDataRoute,
          builder: (context, state) => const EditUserdataPage(),
        ),
        GoRoute(
          path: '/verify-email',
          name: verifyEmailRoute,
          builder: (context, state) => const ConfirmEmailPage(),
        ),

        GoRoute(
          path: '/essentials',
          name: essentialsRoute,
          pageBuilder: (ctx, state) =>
              NoTransitionPage(child: const EssentialsPage()),
        ),
        GoRoute(
          path: '/map',
          name: mapRoute,
          pageBuilder: (ctx, state) => NoTransitionPage(child: const MapPage()),
        ),

        GoRoute(
          path: '/auth',
          name: authRoute,
          builder: (ctx, state) {
            final from = state.uri.queryParameters['from'];
            return Authenticate(
              initShowSignIn: true,
              redirectAfter: from, // ← pass it in
            );
          },
        ),

        /// AUTHENTICATION

        GoRoute(
          path: '/confirm-email',
          name: confirmEmailRoute,
          builder: (ctx, state) => const ConfirmEmailPage(),
        ),

        GoRoute(
          path: '/email-verification/:code',
          name: emailVerificationRoute,
          builder: (ctx, state) => EmailVerificationPage(
            code: state.pathParameters['code'],
          ),
        ),
        // ForgotPassword
        GoRoute(
          path: '/forgot-password',
          name: forgotPasswordRoute,
          builder: (ctx, state) {
            final email = state.uri.queryParameters['email'];
            return ForgotPassword(initialEmail: email);
          },
        ),
        GoRoute(
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
            final slug = state.pathParameters['urlSlug']!;
            final classEventId = state.uri.queryParameters['event'];
            return SingleEventQueryWrapper(
              urlSlug: slug,
              classEventId: classEventId,
            );
          },
        ),

        GoRoute(
          path: '/create-creator-profile',
          name: createCreatorProfileRoute,
          builder: (ctx, state) => const CreateCreatorProfilePage(),
        ),

        GoRoute(
          path: '/stripe-callback',
          name: stripeCallbackRoute,
          builder: (ctx, state) => StripeCallbackPage(
            stripeId: state.pathParameters['stripeId'],
          ),
        ),

        GoRoute(
          path: "/class-booking-summary/:classEventId",
          name: classBookingSummaryRoute,
          pageBuilder: (ctx, state) => NoTransitionPage(
            child: ClassBookingSummaryPage(
              classEventId: state.pathParameters['classEventId']!,
            ),
          ),
        ),

        GoRoute(
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
            path: '/loading',
            name: loadingRoute,
            builder: (ctx, state) => LoadingPage()),

        // error page
        GoRoute(
            path: '/auth-error',
            name: errorRoute,
            builder: (ctx, state) {
              final error = state.uri.queryParameters['error'];
              return ErrorPage(
                error: error ?? 'An unknown error occurred.',
              );
            }),
      ]);
});

// lib/routing/app_router.dart
