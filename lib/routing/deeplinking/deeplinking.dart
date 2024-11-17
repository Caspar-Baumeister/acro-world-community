import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
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

class Deeplinking {
  StreamSubscription? _linkSubscription;

  void terminate() {
    _linkSubscription?.cancel();
  }

  Future<void> initialize(BuildContext context) async {
    final appLinks = AppLinks();

    try {
      await appLinks.getInitialLink().then(
            (Uri? initialLink) => initialLink != null
                ? _handleDeepLink(context, initialLink)
                : null,
          );
    } catch (e, s) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
    }

    _linkSubscription = appLinks.uriLinkStream.listen(
      (link) => _handleDeepLink(context, link),
      onError: (err) {
        CustomErrorHandler.captureException(err.toString());
      },
    );
  }

  void _handleDeepLink(BuildContext context, Uri uri) {
    print("Deep link: $uri");

    // /app/classes/93afc2e6-ccbf-49cf-9120-9c8bbf1e7174/events/85c97f92-b7d0-4a07-b584-9805b65662a4/bookings
    // to navigate to the booking page of this event

    if (uri.path.contains("/stripe-callback")) {
      String? stripeId = uri.queryParameters["stripeId"];
      _navigateToStripeCallbackPage(context, stripeId);
    } else if (uri.path.contains("/email-verification-callback")) {
      String? code = uri.queryParameters["code"];
      _navigateToEmailVerificationPage(context, code);
    } else if (uri.path.contains("/event/")) {
      String? urlSlug = uri.pathSegments[1];
      String? classEventId =
          uri.pathSegments.length > 2 ? uri.pathSegments[2] : null;
      _navigateToSingleEventIdWrapperPage(context, urlSlug, classEventId);
    } else if (uri.path.contains("/partner/")) {
      String? partnerSlug = uri.pathSegments[1];
      _navigateToPartnerSlugPage(context, partnerSlug);
    } else if (uri.path.contains("/app/classes/") &&
        uri.path.contains("/events/") &&
        uri.path.contains("/bookings")) {
      // navigate to the booking page of this event
      String? eventId = uri.pathSegments[4];
      _navigateToBookingPage(context, eventId);
    }
  }

  void _navigateToStripeCallbackPage(BuildContext context, String? stripeId) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(StripeCallbackPageRoute(stripeId: stripeId));
  }

  void _navigateToEmailVerificationPage(BuildContext context, String? code) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(EmailVerificationPageRoute(code: code));
  }

  void _navigateToSingleEventIdWrapperPage(
      BuildContext context, String? urlSlug, String? classEventId) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(SingleEventIdWrapperPageRoute(
        urlSlug: urlSlug, classEventId: classEventId));
  }

  void _navigateToPartnerSlugPage(BuildContext context, String? partnerSlug) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    if (partnerSlug != null) {
      Navigator.of(context).push(PartnerSlugPageRoute(urlSlug: partnerSlug));
    }
  }

  void _navigateToBookingPage(BuildContext context, String? eventId) async {
    print("Navigating to booking page with eventId: $eventId");
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    if (eventId != null) {
      // check if teacher role is active

      // if not, try to switch to teacher role
      try {
        final graphQLSingleton = GraphQLClientSingleton();
        graphQLSingleton.updateClient(true);

        // if successful, navigate to the booking page
        Navigator.of(context).push(CreatorProfilePageRoute());
        Navigator.of(context)
            .push(ClassBookingSummaryPageRoute(classEventId: eventId));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<UserRoleProvider>(context, listen: false)
              .setIsCreator(true);
        });
      } catch (e) {
        // if not successful, show error toast
        showErrorToast("could not switch to creator mode");
      }
    }
  }
}
