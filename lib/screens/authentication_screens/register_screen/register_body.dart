import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/register_screen/widgets/check_box.dart';
import 'package:acroworld/screens/user_communities/user_communities.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  // final AuthService _auth = AuthService();

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String name = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';
  bool isAgbs = false;

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
              child: SingleChildScrollView(
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
                      validator: (val) => (val == null || val.isEmpty)
                          ? 'Enter an email'
                          : null,
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
                      validator: (val) => (val != password)
                          ? 'Passwords are not the same'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CheckBox(
                            onTap: () => setState(() {
                                  isAgbs = !isAgbs;
                                }),
                            isChecked: isAgbs),
                        const SizedBox(width: 8),
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                  text: "I agree with the ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "agbs.",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (!await launchUrl(AGB_URL)) {
                                        throw 'Could not launch';
                                      }
                                    }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () async {
                        onRegister();
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  onRegister() async {
    setState(() {
      error = '';
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    if (!isAgbs) {
      setState(() {
        error = 'you have to agree with the agbs';
      });
      return;
    }
    setState(() {
      loading = true;
    });

    // register response
    final response = await Database().registerApi(email, password, name);

    // error handling
    String errorResponse = "try it again later";
    if (response["errors"] != null) {
      if (response["errors"][0] != null &&
          response["errors"][0]["message"] != null) {
        errorResponse = response["errors"][0]["message"].toString();
      }
      setState(() {
        error = errorResponse;
        loading = false;
      });
      return;
    } else if (response["data"] == null ||
        response["data"]["register"] == null ||
        response["data"]["register"]["token"] == null) {
      setState(() {
        error = errorResponse;
        loading = false;
      });
      return;
    }

    // error to null

    // no error and token exist
    String _token = response["data"]["register"]["token"];

    Provider.of<UserProvider>(context, listen: false).token = _token;

    // safe the user to provider
    Provider.of<UserProvider>(context, listen: false).setUserFromToken();

    // safe the credentials to shared preferences
    CredentialPreferences.setEmail(email);
    CredentialPreferences.setPassword(password);

    // send to UserCommunities
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const UserCommunities()));

    setState(() {
      loading = false;
    });
  }
}
