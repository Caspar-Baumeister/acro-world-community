import 'package:acroworld/screens/authenticate/verify_email.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:acroworld/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailGuard extends StatefulWidget {
  const VerifyEmailGuard({Key? key}) : super(key: key);

  @override
  State<VerifyEmailGuard> createState() => _VerifyEmailGuardState();
}

class _VerifyEmailGuardState extends State<VerifyEmailGuard> {
  @override
  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isVerified) {
      timer?.cancel();
    }
  }

  bool isVerified = false;
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    return isVerified ? const Home() : const VerifyEmailPage();
  }
}
