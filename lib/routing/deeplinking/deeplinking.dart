import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class Deeplinking {
  StreamSubscription? _linkSubscription;

  void terminate() {
    _linkSubscription?.cancel();
  }

  Future<void> initialize(BuildContext context) async {
    try {
      await getInitialLink().then(
        (String? initialLink) => initialLink != null
            ? handleDeepLink(context, Uri.parse(initialLink))
            : null,
      );
    } catch (e, s) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
    }

    _linkSubscription = linkStream.listen(
      (link) => link != null ? handleDeepLink(context, Uri.parse(link)) : null,
      onError: (err) {
        CustomErrorHandler.captureException(err.toString());
      },
    );
  }

  void handleDeepLink(BuildContext context, Uri uri) {
    print("Deep link: $uri");

    // if (authProvider.authState == AuthStates.unauthenticated) {
    //   Navigator.of(context).push(LandingPageRoute());
    // } else if (authProvider.authState == AuthStates.unConfirmed) {
    //   Navigator.of(context).push(ConfirmEmailPageRoute());

    print("uri.path: ${uri.path}");
    // if (uri.path.contains("/register")) {
    //   IntentRouter.route(context, Intents.frontend_auth_register);
    // } else if (uri.path.contains("/user/missingData")) {
    //   IntentRouter.route(context, Intents.frontend_auth_fillUserData);
    // } else if (uri.path.contains("/account/2fa/enable")) {
    //   IntentRouter.route(context, Intents.frontend_auth_account_2fa_create);
    // } else if (uri.path.contains("/invest")) {
    //   IntentRouter.route(context, Intents.frontend_token_index);
    // } else if (uri.path.contains("/mall")) {
    //   IntentRouter.route(context, Intents.frontend_mall);
    // } else if (uri.path.contains("/shop")) {
    //   IntentRouter.route(context, Intents.frontend_shop_index);
    // } else if (uri.path.contains("/orders")) {
    //   IntentRouter.route(context, Intents.frontend_shop_orders);
    // } else if (uri.path.contains("/growmotion")) {
    //   IntentRouter.route(context, Intents.frontend_growmotion);
    // } else if (uri.path.contains("/shop/product/")) {
    //   final String? slug = uri.queryParameters["slug"];
    //   if (slug != null) {
    //     IntentRouter.route(context, Intents.frontend_shop_product,
    //         routeParam: 'slug=$slug');
    //   }
    // } else if (uri.path.contains("/blog")) {
    //   IntentRouter.route(context, Intents.frontend_news_index);
    // } else if (uri.path.contains("/blog/")) {
    //   final String? slug = uri.queryParameters["slug"];
    //   if (slug != null) {
    //     IntentRouter.route(context, Intents.frontend_news_show,
    //         routeParam: 'slug=$slug');
    //   }
    // } else if (uri.path.contains("/werben")) {
    //   IntentRouter.route(context, Intents.frontend_referral);
    // } else if (uri.path.contains("/wallet")) {
    //   final String? mainTab = uri.queryParameters["mainTab"];
    //   final String? subTab = uri.queryParameters["subTab"];
    //   if (mainTab != null) {
    //     if (subTab != null) {
    //       IntentRouter.route(context, Intents.frontend_wallet_withTabs,
    //           routeParam: 'mainTab=$mainTab;subTab=$subTab');
    //     } else {
    //       IntentRouter.route(context, Intents.frontend_wallet_withTabs,
    //           routeParam: 'mainTab=$mainTab');
    //     }
    //   } else {
    //     IntentRouter.route(context, Intents.frontend_user_wallet);
    //   }
    // } else if (uri.path.contains("/account")) {
    //   IntentRouter.route(context, Intents.frontend_user_account);
    // } else if (uri.path.contains("/transactions")) {
    //   IntentRouter.route(context, Intents.frontend_user_showTransHistory);
    // } else if (uri.path.contains("/KYC/userData")) {
    //   IntentRouter.route(context, Intents.frontend_user_kyc_showUserData);
    // } else if (uri.path.contains("/KYC/questions")) {
    //   IntentRouter.route(
    //       context, Intents.frontend_user_kyc_showUserCheckboxes);
    // } else if (uri.path.contains("/club/home")) {
    //   IntentRouter.route(context, Intents.frontend_user_club);
    // } else if (uri.path.contains("/club/") &&
    //     uri.queryParameters["slug"] != null) {
    //   final String? slug = uri.queryParameters["slug"];

    //   IntentRouter.route(context, Intents.frontend_user_club_show,
    //       routeParam: '$slug');
    // } else if (uri.path.contains("/projekte/") &&
    //     uri.queryParameters["slug"] != null) {
    //   final String? slug = uri.queryParameters["slug"];

    //   IntentRouter.route(context, Intents.frontend_user_blog_show,
    //       routeParam: '$slug');
    // } else if (uri.path.contains("/invest/dashboard")) {
    //   IntentRouter.route(context, Intents.frontend_user_token_wallet);
    // } else if (uri.path.contains("/invest/wallet")) {
    //   IntentRouter.route(context, Intents.frontend_user_token_wallet);
    // } else if (uri.path.contains("/invest/purchase")) {
    //   IntentRouter.route(context, Intents.frontend_user_token_purchase);
    // } else if (uri.path.contains("/account/2fa/recovery")) {
    //   IntentRouter.route(context, Intents.frontend_auth_account_2fa_show);
    // } else if (uri.path.contains("/account/2fa/disable")) {
    //   IntentRouter.route(context, Intents.frontend_auth_account_2fa_disable);
    // } else if (uri.path.contains("/login/")) {
    //   IntentRouter.route(context, Intents.frontend_auth_social_login);
    // } else if (uri.path.contains("/AGB")) {
    //   IntentRouter.route(context, Intents.frontend_pages_terms);
    // } else if (uri.path.contains("/terms")) {
    //   IntentRouter.route(context, Intents.frontend_pages_terms);
    // } else if (uri.path.contains("/dsgvo")) {
    //   IntentRouter.route(context, Intents.frontend_pages_dsgvo);
    // } else if (uri.path.contains("/datenschutz")) {
    //   IntentRouter.route(context, Intents.frontend_pages_dsgvo);
    // } else if (uri.path.contains("/impressum")) {
    //   IntentRouter.route(context, Intents.frontend_pages_impressum);
    // } else if (uri.path.contains("/contact")) {
    //   IntentRouter.route(context, Intents.frontend_pages_contact);
    // }
    // // TODO add back in
    // //RECOVER PASSWORD
    // else if (uri.path.contains("/password/reset/")) {
    //   print("reset");
    //   List<String> pathParts = uri.path.split("/");
    //   final String token = pathParts[3];
    //   final String userEmail = uri.queryParameters["email"]!;
    //   print("userId: $token");
    //   print("userEmail: $userEmail");
    //   // context.router
    //   //     .push(ResetPasswordPageRoute(email: userEmail, token: token));
    // } // TODO add back in
    // // VERIFY EMAIL
    // else if (uri.path.contains("/email/verify/")) {
    //   List<String> pathParts = uri.path.split("verify/")[1].split("/");
    //   print("verify email: " +
    //       pathParts[0].toString() +
    //       '|' +
    //       pathParts[1].toString());

    //   // Map<String, dynamic> response =
    //   //     await verifyEmail(pathParts[0], pathParts[1]);

    //   // if (response["error"] == false) {
    //   //   CustomToast.showSuccessToast(
    //   //       "Email verified successfully. You can now login.");
    //   // } else {
    //   //   CustomToast.showErrorToast(response["errormsg"]);
    //   //   CustomException(response["errormsg"], StackTrace.current).handleError();
    //   // }
    //   Navigator.of(context).push(LandingPageRoute());
    // }
  }
}
