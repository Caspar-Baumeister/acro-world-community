import 'package:acroworld/components/custom_button.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/update_fcm_token/update_fcm_token.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/utils/helper_functions/helper_builder.dart';
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
  String errorEmail = "";
  String errorPassword = "";

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        titleSpacing: 20.0,
        title: const Text('Login to AcroWorld'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(right: 20),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () => widget.toggleView(),
              child: const Text(
                "Register",
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Enter an email' : null,
              ),
              errorEmail != ""
                  ? Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 8.0, left: 10),
                      child: Text(
                        errorEmail,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    )
                  : Container(),
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
                        isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    )),
                onFieldSubmitted: (_) => loading ? null : onSignin(),
              ),
              errorPassword != ""
                  ? Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 12.0, left: 10),
                      child: Text(
                        errorPassword,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 20.0),
              CustomButton("Login", () => onSignin(), loading: loading)
              // OutlinedButton(
              //   style: OutlinedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(18),
              //     ),
              //   ),
              //   onPressed: () => onSignin(),
              //   child: const Text(
              //     "Sign In",
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w700,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              ,
              error != ""
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 10),
                      child: Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
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
      errorEmail = '';
      errorPassword = '';
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    // get the token trough the credentials
    // (invalid credentials) return false
    dynamic response = await Database()
        .loginApi(emailController?.text ?? "", passwordController?.text ?? "");

    print(response);

    if (response?["errors"]?[0]["extensions"]?["exception"]?["thrownValue"]
            ?["code"] ==
        "auth/invalid-email") {
      setState(() {
        errorEmail = "incorrect email";
        loading = false;
      });
      return;
    } else if (response?["errors"]?[0]["extensions"]?["exception"]
            ?["thrownValue"]?["code"] ==
        "auth/wrong-password") {
      setState(() {
        loading = false;
        errorPassword = "incorrect password";
      });
      return;
    }

    String? _token = response?["data"]?["login"]?["token"];

    if (_token == null) {
      if (response?["errors"]?[0]["extensions"]?["exception"]?["thrownValue"]
              ?["message"] !=
          null) {
        setState(() {
          error = response?["errors"]?[0]["extensions"]?["exception"]
              ?["thrownValue"]?["message"];
          loading = false;
        });
      } else {
        setState(() {
          error = 'make sure you have a connection to the internet';
          loading = false;
        });
      }

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
        .push(MaterialPageRoute(builder: (context) => const UpdateFcmToken()));

    setState(() {
      loading = false;
    });
  }
}
