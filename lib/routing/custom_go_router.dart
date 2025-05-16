// lib/routing/app_router.dart

import 'package:acroworld/exceptions/error_handler.dart';
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
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/single_partner_slug_wrapper.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/routing/creator_page_scaffold.dart';
import 'package:acroworld/routing/main_page_scaffold.dart';
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
  final authAsync = ref.watch(authProvider);
  return GoRouter(
      refreshListenable: ref.watch(goRouterRefreshProvider),
      initialLocation: '/discover',
      redirect: (_, state) => authAsync.when<String?>(
            loading: () => '/loading',
            error: (err, st) {
              CustomErrorHandler.captureException(
                err.toString(),
                stackTrace: st,
              );
              return '/loading';
            },
            data: (auth) {
              print("auth status: ${auth.status}");
              if (auth.status == AuthStatus.unauthenticated &&
                  state.uri.toString() != '/auth') {
                return '/auth';
              }
              // if (auth.status == AuthStatus.authenticated &&
              //     state.uri.toString() == '/auth') {
              //   return '/';
              // }
              return null;
            },
          ),
      routes: [
        ShellRoute(
            builder: (ctx, state, child) {
              return MainPageScaffold(child: child);
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
                  routes: [
                    GoRoute(
                      path: '/edit-userdata',
                      name: editUserDataRoute,
                      builder: (context, state) => const EditUserdataPage(),
                    ),
                  ]),
            ]),
        ////////////////////
        /// CREATOR MODE ///
        ////////////////////
        ShellRoute(
            builder: (ctx, state, child) {
              return CreatorPageScaffold(child: child);
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
                      path: '/edit-creator-profile',
                      name: editCreatorProfileRoute,
                      builder: (ctx, state) =>
                          const CreateCreatorProfilePage(isEditing: true),
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
          builder: (ctx, state) => const Authenticate(),
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
            path: '/forgot-password/:email',
            name: forgotPasswordRoute,
            builder: (ctx, state) => ForgotPassword(
                  initialEmail: state.pathParameters['email'],
                )),
        GoRoute(
          path: '/forgot-password-success/:email',
          name: forgotPasswordSuccessRoute,
          builder: (ctx, state) => ForgotPasswordSuccess(
            email: state.pathParameters['email']!,
          ),
        ),

        /// PARTNER / TEACHER PROFILE BY SLUG
        GoRoute(
          path: '/partner/:slug',
          name: partnerSlugRoute,
          builder: (ctx, state) {
            final slug = state.pathParameters['slug']!;
            return PartnerSlugWrapper(teacherSlug: slug);
          },
        ),

        /// SINGLE CLASS / EVENT WRAPPER
        GoRoute(
          path: '/event/:urlSlug/:classEventId',
          name: singleEventWrapperRoute,
          builder: (ctx, state) {
            return SingleEventQueryWrapper(
              urlSlug: state.pathParameters['urlSlug'],
              classEventId: state.pathParameters['classEventId'],
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
      ]);
});

// lib/routing/app_router.dart
