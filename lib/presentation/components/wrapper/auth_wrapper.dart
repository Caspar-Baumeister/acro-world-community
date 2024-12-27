import 'package:acroworld/presentation/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/discover_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/loading_page.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/deeplinking/deeplinking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// tries to identify the user and sets the user provider active user
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    // IMPORTANT: initDeepLinks *after* the widget is created,
    // so we have a valid BuildContext.
    deepLinkService.initDeepLinks(context);
  }

  @override
  void dispose() {
    deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: identifyAndSetUser(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while the async operation is ongoing
          return const LoadingPage();
        }

        if (snapshot.hasError) {
          // Optionally handle errors, perhaps navigate to an error screen
          return ErrorPage(error: "auth_wrapper error: ${snapshot.error}");
        }

        if (snapshot.data != null && snapshot.data == true) {
          // Token is present, user is logged in
          return const DiscoverPage(); //UpdateFcmToken(); // Replace with your actual home screen
        } else {
          // No token found, user is not logged in
          return const Authenticate(); // Replace with your actual login screen
        }
      },
    );
  }

  Future<bool> identifyAndSetUser(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = await TokenSingletonService().getToken().then((value) {
      return value;
    });

    if (token != null) {
      // TODO decide if this maybe only happens if neccesarry to safe loading time
      bool userSet = await userProvider.setUserFromToken();

      if (userSet) {
        // NotificationService().updateToken();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
