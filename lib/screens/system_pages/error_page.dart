
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.error}) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "An unexpected error occured. Consider updating your current app version. Error: $error",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ErrorScreenWidget extends StatelessWidget {
  const ErrorScreenWidget({Key? key, required this.error}) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "An unexpected error occured. Consider updating your current app version. Error: $error",
        textAlign: TextAlign.center,
      ),
    );
  }
}
