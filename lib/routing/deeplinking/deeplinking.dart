import 'dart:async';

import 'package:acroworld/core/exceptions/error_handler.dart';
import 'package:acroworld/routing/routes/page_routes/partner_slug_page_route%20copy.dart';
import 'package:acroworld/routing/routes/page_routes/single_class_id_wrapper_page_route.dart';
//import app_links
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

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
                ? handleDeepLink(context, initialLink)
                : null,
          );
    } catch (e, s) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
    }

    _linkSubscription = appLinks.uriLinkStream.listen(
      (link) => handleDeepLink(context, link),
      onError: (err) {
        CustomErrorHandler.captureException(err.toString());
      },
    );
  }

  void handleDeepLink(BuildContext context, Uri uri) {
    print("Deep link: $uri");

    if (uri.path.contains("/event/")) {
      String? urlSlug = uri.pathSegments[1];
      String? classEventId =
          uri.pathSegments.length > 2 ? uri.pathSegments[2] : null;
      Navigator.of(context).push(SingleEventIdWrapperPageRoute(
          urlSlug: urlSlug, classEventId: classEventId));
    } else if (uri.path.contains("/partner/")) {
      String? partnerSlug = uri.pathSegments[1];

      Navigator.of(context).push(PartnerSlugPageRoute(urlSlug: partnerSlug));
    }
  }
}
