import 'package:acroworld/screens/authentication_screens/login_screen/sign_in.dart';
import 'package:acroworld/screens/authentication_screens/register_screen/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key, this.initShowSignIn}) : super(key: key);

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
