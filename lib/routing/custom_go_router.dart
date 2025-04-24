// lib/routing/app_router.dart

import 'package:acroworld/presentation/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/presentation/screens/authentication_screens/confirm_email/confirm_email_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/email_verification_page/email_verification_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/forgot_password_screen/forgot_password.dart';
import 'package:acroworld/presentation/screens/authentication_screens/forgot_password_success_screen/forgot_password_success.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/create_creator_profile_page.dart.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/edit_class_description.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/create_and_edit_event_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/question_page.dart/question_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/creator_profile_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/invites_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/my_events_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/stripe_pages/stripe_callback_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/user_answer_page/user_answer_page.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/essentials/essentials.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/activities_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/discover_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/filter_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/map_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/single_partner_slug_wrapper.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// final authCheckProvider = FutureProvider<bool>(
//   (ref) async {
//     final token = await TokenSingletonService().getToken();
//     if (token == null) return false;
//     return ref.read(userProvider.notifier).setUserFromToken();
//   },
// );

// class GoRouterRefreshNotifier extends ChangeNotifier {
//   GoRouterRefreshNotifier(this.ref) {
//     ref.listen(authCheckProvider, (_, __) => notifyListeners());
//   }

//   final Ref ref;
// }

final rootNavigatorKey = GlobalKey<NavigatorState>();

final shellNavigatorDiscover =
    GlobalKey<NavigatorState>(debugLabel: 'shellDiscover');
final shellNavigatorActivity =
    GlobalKey<NavigatorState>(debugLabel: 'shellActivity');
final shellNavigatorCommunity =
    GlobalKey<NavigatorState>(debugLabel: 'shellCommunity');
final shellNavigatorProfile =
    GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final routerProvider = Provider<GoRouter>((ref) {
  // final role = ref.watch(authCheckProvider);

  return GoRouter(
      // TODO implement redirect on role change and refresh
      initialLocation: '/auth',
      routes: [
        /// MAIN USER
        StatefulShellRoute.indexedStack(
            builder: (context, state, child) => ShellMainPage(child: child),
            pageBuilder: (context, state, child) =>
                shellPageBuilder(context, state, ShellMainPage(child: child)),
            branches: [
              StatefulShellBranch(
                  navigatorKey: shellNavigatorDiscover,
                  routes: [
                    GoRoute(
                      path: '/discover',
                      name: discoverRoute,
                      pageBuilder: (ctx, state) => NoTransitionPage(
                        child: const DiscoverPage(),
                      ),
                      routes: [
                        /// SUBROUTES
                        GoRoute(
                          path: '/filter',
                          name: filterRoute,
                          pageBuilder: (ctx, state) =>
                              NoTransitionPage(child: const FilterPage()),
                        ),
                      ],
                    ),
                  ]),
              StatefulShellBranch(
                  navigatorKey: shellNavigatorActivity,
                  routes: [
                    GoRoute(
                        path: '/activity',
                        name: activitiesRoute,
                        pageBuilder: (ctx, state) =>
                            NoTransitionPage(child: const ActivitiesPage()),
                        routes: [
                          GoRoute(
                            path: '/map',
                            name: mapRoute,
                            pageBuilder: (ctx, state) =>
                                NoTransitionPage(child: const MapPage()),
                          ),
                        ]),
                  ]),
              StatefulShellBranch(
                  navigatorKey: shellNavigatorCommunity,
                  routes: [
                    GoRoute(
                      path: '/community',
                      name: communityRoute,
                      pageBuilder: (ctx, state) =>
                          NoTransitionPage(child: const TeacherPage()),
                    ),
                  ]),
              StatefulShellBranch(
                navigatorKey: shellNavigatorProfile,
                routes: [
                  GoRoute(
                      path: '/profile',
                      name: profileRoute,
                      pageBuilder: (ctx, state) =>
                          NoTransitionPage(child: const ProfilePage()),
                      routes: [
                        GoRoute(
                          path: '/account-settings',
                          name: accountSettingsRoute,
                          pageBuilder: (ctx, state) => NoTransitionPage(
                              child: const AccountSettingsPage()),
                        ),
                        GoRoute(
                          path: '/essentials',
                          name: essentialsRoute,
                          pageBuilder: (ctx, state) =>
                              NoTransitionPage(child: const EssentialsPage()),
                        ),
                      ]),

                  /// AUTHENTICATION
                  ShellRoute(
                    pageBuilder: (context, state, child) =>
                        setupPageBuilder(context, state, Scaffold(body: child)),
                    routes: [
                      GoRoute(
                        path: '/auth',
                        name: authRoute,
                        builder: (ctx, state) => const Authenticate(),
                      ),

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
                        builder: (ctx, state) =>
                            const CreateCreatorProfilePage(),
                      ),

                      GoRoute(
                        path: '/stripe-callback',
                        name: stripeCallbackRoute,
                        builder: (ctx, state) => StripeCallbackPage(
                          stripeId: state.pathParameters['stripeId'],
                        ),
                      ),

                      ////////////////////
                      /// CREATOR MODE ///
                      ////////////////////

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
                                child: const CreatorProfilePage(),
                              ),
                          routes: [
                            GoRoute(
                              path: '/edit-creator-profile',
                              name: editCreatorProfileRoute,
                              builder: (ctx, state) =>
                                  const CreateCreatorProfilePage(
                                      isEditing: true),
                            ),
                          ]),
                      // invitePage
                      GoRoute(
                        path: '/invite',
                        name: invitesRoute,
                        builder: (ctx, state) => InvitesPage(),
                      ),
                      GoRoute(
                        path: '/my-events',
                        name: myEventsRoute,
                        builder: (ctx, state) => const MyEventsPage(),
                        routes: [
                          GoRoute(
                            path: '/create-edit-event',
                            name: createEditEventRoute,
                            builder: (ctx, state) {
                              // default to create; to edit, pass isEditing=true in queryParams
                              final isEditing =
                                  state.pathParameters['isEditing'] == 'true';
                              return CreateAndEditEventPage(
                                  isEditing: isEditing);
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

                      GoRoute(
                        path: '/user-answer',
                        name: userAnswerRoute,
                        builder: (ctx, state) {
                          final userId = state.pathParameters['userId']!;
                          final classEventId =
                              state.pathParameters['classEventId']!;
                          return UserAnswerPage(
                              userId: userId, classEventId: classEventId);
                        },
                      ),
                    ],
                  ),
                ],
              )
            ])
      ]);
});

// final authCheckProvider = FutureProvider<bool>(
//   (ref) async {
//     final token = await TokenSingletonService().getToken();
//     if (token == null) return false;
//     return ref.read(userProvider.notifier).setUserFromToken();
//   },
// );
