import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/HOME_SCREENS/home_scaffold.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:acroworld/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// tries to identify the user and sets the user provider active user
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO make an route guard out of this for deeplinking later
    // TODO or we make the app usable without login

    return FutureBuilder(
      future: identifyAndSetUser(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while the async operation is ongoing
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Optionally handle errors, perhaps navigate to an error screen
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.data != null && snapshot.data == true) {
          // Token is present, user is logged in
          return const HomeScaffold(); //UpdateFcmToken(); // Replace with your actual home screen
        } else {
          // No token found, user is not logged in
          return const Authenticate(); // Replace with your actual login screen
        }
      },
    );
  }

  Future<bool> identifyAndSetUser(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = await AuthProvider().getToken();
    if (token != null) {
      // TODO decide if this maybe only happens if neccesarry to safe loading time
      bool userSet = await userProvider.setUserFromToken();

      if (userSet) {
        NotificationService().updateToken(userProvider.client);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}