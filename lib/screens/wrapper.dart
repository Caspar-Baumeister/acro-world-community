import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/verify_email_guard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// listens to the Firebase User provider.
// if a user is logged in, show home. Otherwise authentication
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this is a firebase user object listened to by authchange stream in main
    final User? user = Provider.of<User?>(context);

    // if (user != null) print(user.email ?? "no email");
    // if (user != null) print(user.displayName ?? "no displayName");
    // if (user != null) print(user.uid);

    // return either Home or Authenticate Widget
    return (user != null) ? const VerifyEmailGuard() : const Authenticate();
  }
}
