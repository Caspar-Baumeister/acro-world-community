import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/main.dart'; // contains navigatorKey
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/routes/page_routes/creator_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/creator_profile_page_route.dart';
import 'package:acroworld/routing/routes/page_routes/partner_slug_page_route copy.dart';
import 'package:acroworld/routing/routes/page_routes/single_class_id_wrapper_page_route.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeepLinkService {
  StreamSubscription<Uri?>? _linkSubscription;
  Uri? _initialLink;

  /// Call this once, typically from your top-level widget's [initState].
  Future<void> initDeepLinks(BuildContext context) async {
    final appLinks = AppLinks(
        // Optionally specify custom configurations if needed:
        // onAppLink: (Uri uri, String stringUri) {
        //   debugPrint('onAppLink: $uri');
        // },
        );

    // 1) Handle the initial link (cold start) but DO NOT navigate yet.
    //    Store it in `_initialLink`.
    try {
      _initialLink = await appLinks.getInitialLink();
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    // 2) Listen for any subsequent links while the app is running.
    _linkSubscription = appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          print("Deep linkSubscription: $uri");
          // Immediately handle new link (runtime)
          _handleDeepLink(context, uri, isInitial: false);
        }
      },
      onError: (err) {
        CustomErrorHandler.captureException(err.toString(),
            stackTrace: StackTrace.current);
      },
    );

    // 3) Defer handling the initial link until after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialLink != null) {
        _handleDeepLink(context, _initialLink!, isInitial: true);
        _initialLink = null;
      }
    });
  }

  /// Clean up the listener when you don't need it anymore
  void dispose() {
    _linkSubscription?.cancel();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Main Deep Link dispatcher
  // ─────────────────────────────────────────────────────────────────────────────
  void _handleDeepLink(BuildContext context, Uri uri,
      {bool isInitial = false}) {
    debugPrint("Deep link: $uri, isInitial=$isInitial");

    // Parse your paths
    if (uri.path.contains("/stripe-callback")) {
      final stripeId = uri.queryParameters["stripeId"];
      print("stripe deeplinking called with stripeId: $stripeId");
      _navigateToStripeCallbackPage(stripeId);
    } else if (uri.path.contains("/email-verification-callback")) {
      final code = uri.queryParameters["code"];
      print("email verification deeplinking called with code: $code");
      _navigateToEmailVerificationPage(code);
    } else if (uri.pathSegments.contains("event")) {
      // e.g. https://acroworld.net/app/event/<slug>/<classEventId>
      final urlSlug =
          (uri.pathSegments.length >= 2) ? uri.pathSegments[1] : null;
      final classEventId =
          (uri.pathSegments.length >= 3) ? uri.pathSegments[2] : null;
      _navigateToSingleEventIdWrapperPage(urlSlug, classEventId);
    } else if (uri.path.contains("/partner/")) {
      final partnerSlug =
          (uri.pathSegments.length >= 2) ? uri.pathSegments[1] : null;
      _navigateToPartnerSlugPage(partnerSlug);
    } else if (uri.path.contains("/app/classes/") &&
        uri.path.contains("/events/") &&
        uri.path.contains("/bookings")) {
      final eventId =
          (uri.pathSegments.length >= 5) ? uri.pathSegments[4] : null;
      _navigateToBookingPage(context, eventId);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Navigation methods using the global navigatorKey
  // ─────────────────────────────────────────────────────────────────────────────
  void _navigateToStripeCallbackPage(String? stripeId) {
    final nav = navigatorKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
    print("Navigating to StripeCallbackPageRoute with stripeId: $stripeId");
    print("navigatorKey: $nav");
    nav?.push(StripeCallbackPageRoute(stripeId: stripeId));
  }

  void _navigateToEmailVerificationPage(String? code) {
    final nav = navigatorKey.currentState;
    print("Navigator in email verifying deeplink: $nav");
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
    nav?.push(EmailVerificationPageRoute(code: code));
  }

  void _navigateToSingleEventIdWrapperPage(
      String? urlSlug, String? classEventId) {
    final nav = navigatorKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
    nav?.push(SingleEventIdWrapperPageRoute(
      urlSlug: urlSlug,
      classEventId: classEventId,
    ));
  }

  void _navigateToPartnerSlugPage(String? partnerSlug) {
    final nav = navigatorKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
    if (partnerSlug != null && nav != null) {
      nav.push(PartnerSlugPageRoute(urlSlug: partnerSlug));
    }
  }

  void _navigateToBookingPage(BuildContext context, String? eventId) async {
    final nav = navigatorKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }

    if (eventId != null && nav != null) {
      try {
        // Switch GraphQL to "creator mode" if needed
        final graphQLSingleton = GraphQLClientSingleton();
        graphQLSingleton.updateClient(true);

        // Navigate to Creator Profile, then to Booking Summary
        nav.push(CreatorProfilePageRoute());
        nav.push(ClassBookingSummaryPageRoute(classEventId: eventId));

        // Switch provider role AFTER navigation is done
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<UserRoleProvider>(context, listen: false)
              .setIsCreator(true);
        });
      } catch (e) {
        showErrorToast("Could not switch to creator mode");
      }
    }
  }
}
