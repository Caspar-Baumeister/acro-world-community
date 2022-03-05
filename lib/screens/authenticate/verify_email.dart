import 'package:acroworld/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ),
              const SizedBox(height: 90),
              const Text(
                "this step is only to protect the app from spammers and thus protect ourself for unpredictable service costs",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ],
      ),
    );
  }
}
