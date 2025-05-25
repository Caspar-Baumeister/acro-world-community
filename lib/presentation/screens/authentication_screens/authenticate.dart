import 'package:acroworld/presentation/screens/authentication_screens/sign_in/sign_in.dart';
import 'package:acroworld/presentation/screens/authentication_screens/signup_screen/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key, this.initShowSignIn, this.redirectAfter});

  final bool? initShowSignIn;
  final String? redirectAfter;

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
    print("With redirect: ${widget.redirectAfter}");
    if (showSignIn) {
      return SignIn(
          toggleView: toggleView, redirectAfter: widget.redirectAfter);
    } else {
      return SignUp(
          toggleView: toggleView, redirectAfter: widget.redirectAfter);
    }
  }
}
