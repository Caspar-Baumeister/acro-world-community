import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/user_communities/user_communities.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({required this.toggleView, Key? key}) : super(key: key);
  final Function toggleView;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

  bool loading = false;

  bool isObscure = true;

  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    print("new build");
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.grey[400],
              elevation: 0.0,
              title: const Text('Login to Acro World'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: emailController,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: buildInputDecoration(labelText: 'Email'),
                      validator: (val) => (val == null || val.isEmpty)
                          ? 'Enter an email'
                          : null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: isObscure,
                      decoration: buildInputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          )),
                      onFieldSubmitted: (_) => onSignin(),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[400])),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => onSignin()),
                    error != ""
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
  }

  // triggert when login is pressed
  void onSignin() async {
    setState(() {
      error = '';
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    // get the token trough the credentials
    // (invalid credentials) return false
    String? _token = await Database()
        .loginApi(emailController?.text ?? "", passwordController?.text ?? "");

    if (_token == null) {
      setState(() {
        error = 'Could not sign in with those credentials';
        loading = false;
      });

      return;
    }

    // safe the credentials to shared preferences
    CredentialPreferences.setEmail(emailController?.text ?? "");
    CredentialPreferences.setPassword(passwordController?.text ?? "");

    Provider.of<UserProvider>(context, listen: false).token = _token;

    // safe the user to provider
    Provider.of<UserProvider>(context, listen: false).setUserFromToken();

    // send to UserCommunities
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const UserCommunities()));

    setState(() {
      loading = false;
    });
  }
}
