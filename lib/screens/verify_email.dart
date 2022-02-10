import 'dart:async';

import 'package:acroworld/screens/home/home.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
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
    return isVerified
        ? Home()
        : Scaffold(
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: Image(
                      image: AssetImage("assets/muscleup_drawing.png"),
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Verify your email",
                      style: MAINTEXT,
                    ),
                    const SizedBox(height: 90),
                    ElevatedButton(
                        onPressed: () => FirebaseAuth.instance.currentUser!
                            .sendEmailVerification(),
                        child: const Text(
                          "Send again",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(primary: Colors.black)),
                    const SizedBox(height: 90),
                    GestureDetector(
                      onTap: () => FirebaseAuth.instance.signOut(),
                      child: const Text("Log out", style: MAINTEXT),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
