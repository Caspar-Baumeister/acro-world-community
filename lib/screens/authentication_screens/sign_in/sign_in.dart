import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/gql_exceptions.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/forgot_password_screen/forgot_password.dart';
import 'package:acroworld/screens/home_screens/home_scaffold.dart';
import 'package:acroworld/services/notification_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_builder.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({required this.toggleView, super.key});
  final Function toggleView;

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
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
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    isKeyboardOpen ? 0 : MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: isKeyboardOpen
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Image(
                          image: AssetImage('assets/logo/yoga2 transp.png'),
                          height: 100,
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        autofocus: true,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: buildInputDecoration(labelText: 'Email'),
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'Enter an email'
                            : null,
                      ),
                      errorEmail != ""
                          ? Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 10),
                              child: Text(
                                errorEmail,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 20.0),
                      TextFormField(
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
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
                          onFieldSubmitted: (_) async {
                            if (loading == false) {
                              setState(() {
                                loading = true;
                              });

                              await onSignin();
                              setState(() {
                                loading = false;
                              });
                            }
                          }),
                      errorPassword != ""
                          ? Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 10),
                              child: Text(
                                errorPassword,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 20.0),
                      StandardButton(
                        text: "Login",
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await onSignin();
                          setState(() {
                            loading = false;
                          });
                        },
                        loading: loading,
                        isFilled: true,
                        buttonFillColor: COLOR7,
                      ),
                      error != ""
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 10),
                              child: Text(
                                error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0)
                            .copyWith(top: 8, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword(
                                            initialEmail: emailController?.text,
                                          )),
                                );
                              },
                              child: Text(
                                "Forgot password",
                                style: H14W4.copyWith(color: LINK_COLOR),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await customLaunch(AppEnvironment.dashboardUrl);
                              },
                              child: Text(
                                "Partner dashboard",
                                style: H14W4.copyWith(color: LINK_COLOR),
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () => widget.toggleView(),
                        child: const Text("Register", style: BUTTON_TEXT),
                      ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // triggert when login is pressed
  Future<void> onSignin() async {
    setState(() {
      error = '';
      errorEmail = '';
      errorPassword = '';
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    // get the token trough the credentials
    // (invalid credentials) return false
    await TokenSingletonService()
        .login(emailController!.text, passwordController!.text)
        .then((response) {
      if (response["errors"] != null) {
        final errorMap = parseGraphQLError(response);

        setState(() {
          errorEmail = errorMap['emailError'] ?? "";
          errorPassword = errorMap['passwordError'] ?? "";
          error = errorMap['error'] ?? "";
        });
      } else if (response["error"] == false) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUserFromToken().then((value) {
          if (value) {
            NotificationService().updateToken();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScaffold()),
            );
          } else {
            print("failed token");
            TokenSingletonService().getToken().then((value) => print(value));
            setState(() {
              error = 'We could not log you in. Please try again later';
            });
          }
        });
      } else {
        setState(() {
          error = 'An unexpected error occured. Please try again later';
        });
      }
    });
  }
}
