import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/screens/authentication_screens/choose_gender_screen/choose_gender.dart';
import 'package:acroworld/screens/authentication_screens/register_screen/widgets/agbsCheckBox.dart';
import 'package:acroworld/screens/authentication_screens/register_screen/widgets/register_info.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  RegisterBodyState createState() => RegisterBodyState();
}

class RegisterBodyState extends State<RegisterBody> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  String error = '';

  bool isAgb = false;

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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: buildInputDecoration(labelText: 'name'),
                      validator: (val) => (val == null || val.isEmpty)
                          ? 'Name cannot be empty'
                          : null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: buildInputDecoration(labelText: 'email'),
                      validator: (val) => (val == null || val.isEmpty)
                          ? 'Enter an email'
                          : null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
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
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordConfirmController,
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
                      validator: (val) => (val != passwordController?.text)
                          ? 'Passwords are not the same'
                          : null,
                    ),
                    const SizedBox(height: 20.0),
                    AGBCheckbox(
                        isAgb: isAgb,
                        setAgb: (b) => setState(
                              () {
                                isAgb = b;
                              },
                            )),
                    const SizedBox(height: 20.0),
                    Center(
                        child: StandartButton(
                      text: "Register",
                      onPressed: () async => onRegister(),
                      loading: loading,
                      isFilled: true,
                    )),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(color: PRIMARY_COLOR),
          const SizedBox(height: 15),
          const RegisterInfo()
        ],
      ),
    );
  }

  onRegister() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      error = '';
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    if (!isAgb) {
      setState(() {
        error = 'You need to accept the agbs';
      });
      return;
    }
    setState(() {
      loading = true;
    });

    // register response
    final response = await Database().registerApi(emailController?.text ?? "",
        passwordController?.text ?? "", nameController?.text ?? "");

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

    // error to null

    // no error and token exist
    String token = response["data"]["register"]["token"];

    Provider.of<UserProvider>(context, listen: false).token = token;

    // safe the user to provider
    bool setUserFromTokeResponse =
        await Provider.of<UserProvider>(context, listen: false)
            .setUserFromToken();
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChooseGender()
          //UpdateFcmToken()
          ),
    );

    setState(() {
      loading = false;
    });
  }
}
