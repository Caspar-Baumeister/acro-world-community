import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/input/input_field_component.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/screens/authentication_screens/forgot_password_success_screen/forgot_password_success.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController emailController;
  bool loading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        titleSpacing: 20.0,
        title: const Text('Forgot password'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                  "Enter your email address and we'll send you a link to reset your password."),
            ),
            const SizedBox(height: 15),
            InputFieldComponent(
              controller: emailController,
              autoFocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              labelText: 'Email',
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'Enter an email' : null,
              onFieldSubmitted: (value) => onForgotPassword(),
            ),
            const SizedBox(height: 20.0),
            StandardButton(
              text: "Send email",
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
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  onForgotPassword() async {
    setState(() {
      loading = true;
    });
    final response = await DatabaseService().forgotPassword(
      emailController.text,
    );

    if (response?["data"]["reset_password"]?["success"] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  ForgotPasswordSuccess(email: emailController.text)),
        );
      });
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
