import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/discover_page_route.dart';
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
      await appLinks.getInitialAppLink().then(
            (Uri? initialLink) => initialLink != null
                ? handleDeepLink(context, initialLink)
                : null,
          );
    } catch (e, s) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
    }

    _linkSubscription = appLinks.allUriLinkStream.listen(
      (link) => handleDeepLink(context, link),
      onError: (err) {
        CustomErrorHandler.captureException(err.toString());
      },
    );
  }

  void handleDeepLink(BuildContext context, Uri uri) {
    print("Deep link: $uri");

    if (uri.path.contains("/event/")) {
      uri.queryParametersAll.forEach((key, value) {
        print("key: $key, value: $value");
      });

      print("urlSlug: ${uri.queryParameters["urlSlug"]}");
      print("eventId: ${uri.queryParameters["eventId"]}");

      // get the url slug and the class event id from the uri parameters
      final String? urlSlug = uri.queryParameters["urlSlug"];
      final String? classEventId = uri.queryParameters["eventId"];

      if (urlSlug == null) {
        Navigator.of(context).push(DiscoverPageRoute());
        return;
      }
      Navigator.of(context).push(SingleEventIdWrapperPageRoute(
          urlSlug: urlSlug, classEventId: classEventId));
    }
  }
}
