// lib/routing/app_router.dart

import 'package:acroworld/presentation/screens/account_settings/account_settings_page.dart';
import 'package:acroworld/presentation/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/essentials/essentials.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/activities_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/community_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/discover_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/filter_page/filter_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/profile_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/map/map_page.dart';
import 'package:acroworld/presentation/shells/shell_bottom_navigation_bar.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/routing/transitions%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(initialLocation: '/auth', routes: [
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
              ]),
        ]),

    /// AUTHENTICATION
    ShellRoute(
        pageBuilder: (context, state, child) =>
            setupPageBuilder(context, state, child),
        routes: [
          GoRoute(
            path: '/auth',
            name: authRoute,
            builder: (ctx, state) => const Authenticate(),
          ),

          // GoRoute(
          //   path: '/confirm-email',
          //   name: confirmEmailRoute,
          //   builder: (ctx, state) => const ConfirmEmailPage(),
          // ),

          // GoRoute(
          //   path: '/email-verification/:code',
          //   name: emailVerificationRoute,
          //   builder: (ctx, state) => EmailVerificationPage(
          //     code: state.pathParameters['code'],
          //   ),
          // ),
          // // ForgotPassword
          // GoRoute(
          //     path: '/forgot-password/:email',
          //     name: forgotPasswordRoute,
          //     builder: (ctx, state) => ForgotPassword(
          //           initialEmail: state.pathParameters['email'],
          //         )),
          // GoRoute(
          //   path: '/forgot-password-success/:email',
          //   name: forgotPasswordSuccessRoute,
          //   builder: (ctx, state) => ForgotPasswordSuccess(
          //     email: state.pathParameters['email']!,
          //   ),
          // ),

          // /// PARTNER / TEACHER PROFILE BY SLUG
          // GoRoute(
          //   path: '/partner/:slug',
          //   name: partnerSlugRoute,
          //   builder: (ctx, state) {
          //     final slug = state.pathParameters['slug']!;
          //     return PartnerSlugWrapper(teacherSlug: slug);
          //   },
          // ),

          // /// SINGLE CLASS / EVENT WRAPPER
          // GoRoute(
          //   path: '/event/:urlSlug/:classEventId',
          //   name: singleEventWrapperRoute,
          //   builder: (ctx, state) {
          //     return SingleEventQueryWrapper(
          //       urlSlug: state.pathParameters['urlSlug'],
          //       classEventId: state.pathParameters['classEventId'],
          //     );
          //   },
          // ),

          // GoRoute(
          //   path: '/create-creator-profile',
          //   name: createCreatorProfileRoute,
          //   builder: (ctx, state) => const CreateCreatorProfilePage(),
          // ),

          // GoRoute(
          //   path: '/stripe-callback',
          //   name: stripeCallbackRoute,
          //   builder: (ctx, state) => StripeCallbackPage(
          //     stripeId: state.pathParameters['stripeId'],
          //   ),
          // ),

          // ////////////////////
          // /// CREATOR MODE ///
          // ////////////////////

          // GoRoute(
          //   path: '/creator-profile',
          //   name: creatorProfileRoute,
          //   pageBuilder: (ctx, state) => NoTransitionPage(
          //     child: const CreatorProfilePage(),
          //   ),
          // ),
          // GoRoute(
          //     path: '/creator-dashboard',
          //     name: creatorDashboardRoute,
          //     pageBuilder: (ctx, state) => NoTransitionPage(
          //           child: const CreatorProfilePage(),
          //         ),
          //     routes: [
          //       GoRoute(
          //         path: '/edit-creator-profile',
          //         name: editCreatorProfileRoute,
          //         builder: (ctx, state) =>
          //             const CreateCreatorProfilePage(isEditing: true),
          //       ),
          //     ]),
          // // invitePage
          // GoRoute(
          //   path: '/invite',
          //   name: invitesRoute,
          //   builder: (ctx, state) => InvitesPage(),
          // ),
          // GoRoute(
          //   path: '/my-events',
          //   name: myEventsRoute,
          //   builder: (ctx, state) => const MyEventsPage(),
          //   routes: [
          //     GoRoute(
          //       path: '/create-edit-event',
          //       name: createEditEventRoute,
          //       builder: (ctx, state) {
          //         // default to create; to edit, pass isEditing=true in queryParams
          //         final isEditing =
          //             state.pathParameters['isEditing'] == 'true';
          //         return CreateAndEditEventPage(isEditing: isEditing);
          //       },
          //       routes: [
          //         GoRoute(
          //           path: '/edit-description',
          //           name: editDescriptionRoute,
          //           builder: (ctx, state) {
          //             final initialText =
          //                 state.pathParameters['initialText'] ?? '';
          //             // You’ll still need a way to supply onTextUpdated; consider using a provider or passing a callback in extra.
          //             return EditClassDescriptionPage(
          //               initialText: initialText,
          //               onTextUpdated: (newText) {/* … */},
          //             );
          //           },
          //         ),
          //         GoRoute(
          //           path: '/question',
          //           name: questionRoute,
          //           builder: (ctx, state) => const QuestionPage(),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),

          // GoRoute(
          //   path: '/user-answer',
          //   name: userAnswerRoute,
          //   builder: (ctx, state) {
          //     final userId = state.pathParameters['userId']!;
          //     final classEventId = state.pathParameters['classEventId']!;
          //     return UserAnswerPage(
          //         userId: userId, classEventId: classEventId);
          //   },
          // ),
        ])
  ]);
});

// lib/routing/app_router.dart

/// Wraps your shell and keeps track of which tab is active by
/// inspecting the current GoRouter location.
class MainPageScaffold extends StatelessWidget {
  final Widget child;
  const MainPageScaffold({super.key, required this.child});

  // your top‐level tab destinations:
  static const _paths = [
    '/discover',
    '/activity',
    '/community',
    '/profile',
  ];

  int _computeIndex(String location) {
    print("try to compute index for $location");
    // pick the first matching prefix in order:
    for (var i = 0; i < _paths.length; i++) {
      if (location.startsWith(_paths[i])) return i;
    }
    return 0; // default to first
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: ShellBottomNavigationBar(
        onItemPressed: (index) {
          context.go(_paths[index]);
        },
      ),
    );
  }
}
