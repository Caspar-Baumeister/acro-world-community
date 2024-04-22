import 'package:acroworld/components/buttons/link_button.dart';
import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/input/input_field_component.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/calendar_page_route.dart';
import 'package:acroworld/screens/authentication_screens/signup_screen/widgets/agbsCheckBox.dart';
import 'package:acroworld/services/notification_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({required this.toggleView, super.key});
  final Function toggleView;

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String errorName = "";
  String errorEmail = "";
  String errorPassword = "";
  String errorPasswordConfirm = "";

  bool isAgb = false;
  bool isNewsletter = false;

  void setNewsletter(bool b) {
    setState(() {
      isNewsletter = b;
    });
  }

  void setAgb(bool b) {
    setState(() {
      isAgb = b;
    });
  }

  bool loading = false;

  bool passwordObscure = true;
  bool passwordConfirmObscure = true;

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? passwordConfirmController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    passwordConfirmController = TextEditingController();
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
                    InputFieldComponent(
                        controller: nameController!,
                        autoFocus: true,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        labelText: 'Name'),
                    errorName != ""
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 8.0, left: 10),
                            child: Text(
                              errorName,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 20.0),
                    InputFieldComponent(
                        controller: emailController!,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        labelText: 'Email'),
                    errorEmail != ""
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 8.0, left: 10),
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
                      obscureText: passwordObscure,
                      labelText: 'Password',
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
                    errorPassword != ""
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 12.0, left: 10),
                            child: Text(
                              errorPassword,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 20.0),
                    InputFieldComponent(
                      controller: passwordConfirmController!,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      obscureText: passwordConfirmObscure,
                      labelText: 'Confirm password',
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
                      onFieldSubmitted: (_) => loading ? null : onRegister(),
                    ),
                    errorPasswordConfirm != ""
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 12.0, left: 10),
                            child: Text(
                              errorPasswordConfirm,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 20.0),
                    AGBCheckbox(isAgb: isAgb, setAgb: setAgb),
                    const SizedBox(height: 20.0),
                    NewsletterCheckbox(
                        isNewsletter: isNewsletter,
                        setNewsletter: setNewsletter),
                    const SizedBox(height: 20.0),
                    StandardButton(
                      text: "Register",
                      onPressed: () => onRegister(),
                      loading: loading,
                      isFilled: true,
                      buttonFillColor: CustomColors.primaryColor,
                    ),
                    error != ""
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 10),
                            child: Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 20),
                    LinkButtonComponent(
                      text: "Login",
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
    );
  }

  onRegister() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      error = '';
      errorEmail = '';
      errorPassword = '';
      errorName = '';
      errorPasswordConfirm = '';
      loading = true;
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      setState(() {
        loading = false;
      });
      return;
    }
    // check if password and password confirm are the same
    if (passwordController?.text != passwordConfirmController?.text) {
      print("yes this happend");
      setState(() {
        errorPasswordConfirm = "Passwords are not the same";
        loading = false;
      });
      return;
    }

    // check if agb is checked
    if (!isAgb) {
      setState(() {
        error = "Please accept the terms and conditions";
        loading = false;
      });
      return;
    }

    // check if emaailcontroller, passwordcontroller and namecontroller are not null
    if (emailController?.text == null ||
        passwordController?.text == null ||
        nameController?.text == null) {
      setState(() {
        error = "We're sorry there are some problems in the controller";
        loading = false;
      });
      return;
    }

    await TokenSingletonService()
        .register(emailController!.text, passwordController!.text,
            nameController!.text,
            isNewsletterEnabled: isNewsletter)
        .then((response) {
      if (response["errors"]?[0]["extensions"]?["exception"]?["errorInfo"]
              ?["message"] !=
          null) {
        setState(() {
          error = response["errors"]?[0]["extensions"]?["exception"]
              ?["errorInfo"]?["message"];
        });
      } else if (response["errors"]?[0]["message"] != null) {
        setState(() {
          error = response["errors"]?[0]["message"];
        });
      } else if (response["error"] == false) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUserFromToken().then((value) {
          if (value) {
            NotificationService().updateToken();
            Navigator.of(context).push(
              CalendarPageRoute(),
            );
          } else {
            setState(() {
              error = 'An unexpected error occured. Please try again later';
            });
          }
        });
      } else {
        setState(() {
          error = 'An unexpected error occured. Please try again later';
        });
      }
    });

    setState(() {
      loading = false;
    });
  }
}
