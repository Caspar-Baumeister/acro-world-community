import 'package:acroworld/screens/authentication_screens/register_screen/register_body.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({required this.toggleView, Key? key}) : super(key: key);

  final Function toggleView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          titleSpacing: 20.0,
          elevation: 0.0,
          title: const Text('Register to AcroWorld'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(right: 20),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => toggleView(),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: const RegisterBody());
  }
}
