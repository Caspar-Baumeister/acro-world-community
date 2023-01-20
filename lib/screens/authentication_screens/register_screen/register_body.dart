import 'package:acroworld/components/custom_button.dart';
import 'package:acroworld/components/text_wIth_leading_icon.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/screens/authentication_screens/update_fcm_token/update_fcm_token.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  String error = '';

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
                    const SizedBox(height: 20.0),
                    Center(
                        child: CustomButton(
                      "Register",
                      () async => onRegister(),
                      loading: loading,
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
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Why AcroWorld",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "The one and only Acroyoga app you need.",
                        style: TextStyle(fontSize: 12),
                        maxLines: 5,
                      ),
                      SizedBox(height: 15),
                      TextWIthLeadingIcon(
                        icon: ImageIcon(
                          AssetImage("assets/check.png"),
                          color: Colors.green,
                        ),
                        text: Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text(
                            "With one click you will always know where and when classes and jams are taking place in your area.",
                            // "Stay in touch with the community with the best from Whatsapp and Facebook groups tailored to acro",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextWIthLeadingIcon(
                        icon: ImageIcon(
                          AssetImage("assets/check.png"),
                          color: Colors.green,
                        ),
                        text: Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text(
                            "Find out not only who the best teachers in your area are, but also exactly what they offer",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextWIthLeadingIcon(
                        icon: ImageIcon(
                          AssetImage("assets/check.png"),
                          color: Colors.green,
                        ),
                        text: Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text(
                            "Find out what acroyoga related events are taking place around the world",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextWIthLeadingIcon(
                        icon: ImageIcon(
                          AssetImage("assets/check.png"),
                          color: Colors.green,
                        ),
                        text: Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text(
                            "Keep in touch with your Acroyoga community. Find out who is participating where and when and discover the local communities when you are away from home.",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  )),
            ],
          ),
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
    String _token = response["data"]["register"]["token"];

    Provider.of<UserProvider>(context, listen: false).token = _token;

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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const UpdateFcmToken()));

    setState(() {
      loading = false;
    });
  }
}
