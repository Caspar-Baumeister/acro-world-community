import 'package:acroworld/services/auth.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final AuthService _auth = AuthService();

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String name = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';

  bool passwordObscure = true;
  bool passwordConfirmObscure = true;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: buildInputDecoration(labelText: 'name'),
                    validator: (val) => (val == null || val.isEmpty)
                        ? 'Name cannot be empty'
                        : null,
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: buildInputDecoration(labelText: 'email'),
                    validator: (val) =>
                        (val == null || val.isEmpty) ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: buildInputDecoration(
                      labelText: 'password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordObscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            passwordObscure = !passwordObscure;
                          });
                        },
                      ),
                    ),
                    obscureText: passwordObscure,
                    validator: (val) => (val == null || val.length < 6)
                        ? 'Enter a password 6+ chars long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: buildInputDecoration(
                      labelText: 'password confirm',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordConfirmObscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            passwordConfirmObscure = !passwordConfirmObscure;
                          });
                        },
                      ),
                    ),
                    obscureText: passwordConfirmObscure,
                    validator: (val) =>
                        (val != password) ? 'Passwords are not the same' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[400])),
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email, password, name);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = 'Please supply a valid email';
                            });
                          }
                        }
                      }),
                  const SizedBox(height: 12.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          );
  }
}
