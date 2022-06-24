import 'package:acroworld/screens/authenticate/friend_code/friend_code.dart';
import 'package:acroworld/screens/authenticate/register/register.dart';
import 'package:acroworld/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  bool confirmedFriend = false;

  void confirmFriend() {
    setState(() {
      confirmedFriend = true;
    });
  }

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      if (confirmedFriend) {
        return Register(toggleView: toggleView);
      } else {
        return FriendCode(confirmFriend: confirmFriend, toggleView: toggleView);
      }
    }
  }
}
