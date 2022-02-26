import 'package:acroworld/screens/authenticate/register/register_body.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({required this.toggleView, Key? key}) : super(key: key);

  final Function toggleView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[400],
          elevation: 0.0,
          title: const Text('Register for Acro World'),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: const Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => toggleView(),
            ),
          ],
        ),
        body: const RegisterBody());
  }
}
