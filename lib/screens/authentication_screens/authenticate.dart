import 'package:acroworld/screens/authentication_screens/sign_in/sign_in.dart';
import 'package:acroworld/screens/authentication_screens/signup_screen/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key, this.initShowSignIn});

  final bool? initShowSignIn;

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  @override
  void initState() {
    super.initState();
    if (widget.initShowSignIn != null) {
      showSignIn = widget.initShowSignIn!;
    }
  }

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
