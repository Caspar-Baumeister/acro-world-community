import 'package:acroworld/components/buttons/link_button.dart';
import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/input/input_field_component.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/exceptions/gql_exceptions.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes_user/discover_page_route.dart';
import 'package:acroworld/screens/authentication_screens/forgot_password_screen/forgot_password.dart';
import 'package:acroworld/services/notification_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
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
                          image: AssetImage('assets/logo/logo_transparent.png'),
                          height: 100,
                        ),
                      ),
                      InputFieldComponent(
                        controller: emailController!,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        labelText: 'Email',
                        autoFocus: true,
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
                      InputFieldComponent(
                          controller: passwordController!,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          obscureText: isObscure,
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
                          ),
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
                        buttonFillColor: CustomColors.primaryColor,
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
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: CustomColors.linkTextColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      LinkButtonComponent(
                        text: "Register",
                        onPressed: () => widget.toggleView(),
                      ),
                      const SizedBox(height: 10),
                      LinkButtonComponent(
                          text: "Partner Dashboard",
                          onPressed: () async =>
                              await customLaunch(AppEnvironment.dashboardUrl)),
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
    try {
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
          // TODO: no logic with ui
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUserFromToken().then((value) {
            if (value) {
              NotificationService().updateToken();
              Navigator.of(context).push(
                DiscoverPageRoute(),
              );
            } else {
              setState(() {
                error = 'We could not log you in. Please try again later';
              });
            }
          });
        } else {
          CustomErrorHandler.captureException(response.toString(),
              stackTrace: StackTrace.current);
          setState(() {
            error = 'An unexpected error occured. Please try again later';
          });
        }
      });
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      setState(() {
        error = 'An unexpected error occured. Please try again later';
      });
    }
  }
}
