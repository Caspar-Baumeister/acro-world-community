import 'package:acroworld/screens/authentication_screens/register_screen/register.dart';
import 'package:acroworld/screens/authentication_screens/login_screen/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key, this.initShowSignIn}) : super(key: key);

  final bool? initShowSignIn;

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;
  // bool confirmedFriend = false;

  @override
  void initState() {
    super.initState();
    if (widget.initShowSignIn != null) {
      showSignIn = widget.initShowSignIn!;
    }
  }

  // void confirmFriend() {
  //   setState(() {
  //     confirmedFriend = true;
  //   });
  // }

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      // if (confirmedFriend) {
      return Register(toggleView: toggleView);
      // } else {
      //   return FriendCode(confirmFriend: confirmFriend, toggleView: toggleView);
      // }
    }
  }
}
