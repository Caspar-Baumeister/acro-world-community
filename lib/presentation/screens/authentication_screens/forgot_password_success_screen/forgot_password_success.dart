import 'dart:async';

import 'package:acroworld/data/graphql/http_api_urls.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordSuccess extends StatefulWidget {
  const ForgotPasswordSuccess({super.key, required this.email});

  final String email;

  @override
  ForgotPasswordSuccessState createState() => ForgotPasswordSuccessState();
}

class ForgotPasswordSuccessState extends State<ForgotPasswordSuccess> {
  // Step 2
  Timer? countdownTimer;
  Duration myDuration = const Duration(hours: 1);
  String error = '';

  bool loading = false;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  /// Timer related methods ///
  // Step 3
  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(hours: 1));
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    // Step 7
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        titleSpacing: 20.0,
        title: const Text('Successfully reset password'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "We send you an email, you now have one hour to clickl on the link in that email and choose a new one",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            '$hours:$minutes:$seconds',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 50),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "The link is only valid for one hour, but you can request a new link at any time.",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15.0),
          StandartButton(
            text: "send new email",
            onPressed: () {
              onForgotPassword();
            },
            loading: loading,
            isFilled: true,
          ),
          error != ""
              ? Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 10),
                  child: Text(
                    error,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  onForgotPassword() async {
    setState(() {
      loading = true;
    });
    final response = await DatabaseService().forgotPassword(
      widget.email,
    );

    if (response?["data"]["reset_password"]?["success"] == true) {
      resetTimer();
      startTimer();
    } else {
      setState(() {
        error = "Something went wrong. Try again later";
      });
    }
    setState(() {
      loading = false;
    });
  }
}
