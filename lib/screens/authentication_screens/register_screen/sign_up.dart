import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/register_screen/widgets/agbsCheckBox.dart';
import 'package:acroworld/screens/authentication_screens/update_fcm_token/update_fcm_token.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_builder.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({required this.toggleView, Key? key}) : super(key: key);
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
    UserProvider userProvider = Provider.of<UserProvider>(context);

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
                    TextFormField(
                      controller: nameController,
                      autofocus: true,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: buildInputDecoration(labelText: 'Name'),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Enter a name' : null,
                    ),
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
                    TextFormField(
                      controller: emailController,
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
                            padding: const EdgeInsets.only(top: 8.0, left: 10),
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
                      obscureText: passwordObscure,
                      decoration: buildInputDecoration(
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
                          )),
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
                    TextFormField(
                      controller: passwordConfirmController,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      obscureText: passwordConfirmObscure,
                      decoration: buildInputDecoration(
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
                                passwordConfirmObscure =
                                    !passwordConfirmObscure;
                              });
                            },
                          )),
                      onFieldSubmitted: (_) =>
                          loading ? null : onRegister(userProvider),
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
                    // add agbs checkbox
                    AGBCheckbox(isAgb: isAgb, setAgb: setAgb),
                    const SizedBox(height: 20.0),
                    StandartButton(
                      text: "Register",
                      onPressed: () => onRegister(userProvider),
                      loading: loading,
                      isFilled: true,
                      buttonFillColor: COLOR7,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0)
                          .copyWith(top: 8, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
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
    );
  }

  onRegister(UserProvider userProvider) async {
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

    // register response
    final response = await Database().registerApi(
        emailController!.text, passwordController!.text, nameController!.text);

    // error handling
    String errorResponse =
        "We're sorry there are some problems. Please try again later";
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
    // no error and token exist set all errors to empty
    setState(() {
      error = '';
      errorEmail = '';
      errorPassword = '';
      errorName = '';
      errorPasswordConfirm = '';
    });

    // no error and token exist
    String token = response["data"]["register"]["token"];

    userProvider.token = token;
    bool setUserFromTokeResponse = await userProvider.setUserFromToken();

    if (!setUserFromTokeResponse) {
      errorResponse = "We are not able to create an user";
      setState(() {
        error = errorResponse;
        loading = false;
      });
      return;
    }

    // safe the credentials to shared preferences
    CredentialPreferences.setEmail(emailController?.text ?? "");
    CredentialPreferences.setPassword(passwordController?.text ?? "");

    // send to UserCommunities
    // send to UserCommunities
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const UpdateFcmToken()
            //UpdateFcmToken()
            ),
      );
    });

    setState(() {
      loading = false;
    });
  }
}
