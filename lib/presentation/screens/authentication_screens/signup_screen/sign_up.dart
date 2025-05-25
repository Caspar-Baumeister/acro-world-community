import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/exceptions/gql_exceptions.dart';
import 'package:acroworld/presentation/components/buttons/link_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/authentication_screens/signup_screen/widgets/agbsCheckBox.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({required this.toggleView, this.redirectAfter, super.key});
  final VoidCallback toggleView;
  final String? redirectAfter;

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _formKey = GlobalKey<FormState>();

  String error = '';
  String errorName = '';
  String errorEmail = '';
  String errorPassword = '';
  String errorPasswordConfirm = '';

  bool isAgb = false;
  bool isNewsletter = false;

  bool passwordObscure = true;
  bool passwordConfirmObscure = true;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      error = '';
      errorName = '';
      errorEmail = '';
      errorPassword = '';
      errorPasswordConfirm = '';
    });

    if (!_formKey.currentState!.validate()) return;
    if (passwordController.text != passwordConfirmController.text) {
      setState(() => errorPasswordConfirm = 'Passwords do not match');
      return;
    }
    if (!isAgb) {
      setState(() => error = 'Please accept the terms and conditions');
      return;
    }

    try {
      await ref.read(authProvider.notifier).register(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
            isNewsletter: isNewsletter,
          );
    } on AuthException catch (e) {
      setState(() {
        errorName = e.fieldErrors['name'] ?? '';
        errorEmail = e.fieldErrors['email'] ?? '';
        errorPassword = e.fieldErrors['password'] ?? '';
        error = e.globalError;
      });
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      setState(() =>
          error = 'An unexpected error occurred. Please try again later.');
    }
  }

  Widget _form(BuildContext context) {
    final authAsync = ref.watch(authProvider);
    final isLoading = authAsync.isLoading;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: Responsive.isMobile(context)
                ? BoxConstraints(
                    minHeight:
                        isKeyboardOpen ? 0 : MediaQuery.of(context).size.height,
                  )
                : BoxConstraints(),
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
                      image: AssetImage('assets/logo/logo_transparent.png'),
                      height: 100,
                    ),
                  ),
                  InputFieldComponent(
                    controller: nameController,
                    autofillHints: const [AutofillHints.name],
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    labelText: 'Name',
                    validator: (val) =>
                        (val == null || val.isEmpty) ? 'Enter your name' : null,
                  ),
                  if (errorName.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(errorName,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0)),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  InputFieldComponent(
                    controller: emailController,
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    labelText: 'Email',
                    validator: (val) =>
                        (val == null || val.isEmpty) ? 'Enter an email' : null,
                  ),
                  if (errorEmail.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(errorEmail,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0)),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  InputFieldComponent(
                    controller: passwordController,
                    obscureText: passwordObscure,
                    labelText: 'Password',
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.next,
                    suffixIcon: IconButton(
                      icon: Icon(passwordObscure
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => passwordObscure = !passwordObscure),
                    ),
                    validator: (val) => (val == null || val.isEmpty)
                        ? 'Enter a password'
                        : null,
                  ),
                  if (errorPassword.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(errorPassword,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0)),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  InputFieldComponent(
                    controller: passwordConfirmController,
                    obscureText: passwordConfirmObscure,
                    labelText: 'Confirm password',
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(passwordConfirmObscure
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() =>
                          passwordConfirmObscure = !passwordConfirmObscure),
                    ),
                    validator: (val) => (val == null || val.isEmpty)
                        ? 'Re-enter your password'
                        : null,
                  ),
                  if (errorPasswordConfirm.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(errorPasswordConfirm,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0)),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  AGBCheckbox(
                    isAgb: isAgb,
                    setAgb: (val) => setState(() => isAgb = val),
                  ),
                  const SizedBox(height: 20.0),
                  NewsletterCheckbox(
                    isNewsletter: isNewsletter,
                    setNewsletter: (val) => setState(() => isNewsletter = val),
                  ),
                  const SizedBox(height: 20.0),
                  StandartButton(
                    text: "Register",
                    onPressed: isLoading ? () {} : _onRegister,
                    loading: isLoading,
                    isFilled: true,
                    buttonFillColor: CustomColors.primaryColor,
                  ),
                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ),
                  const SizedBox(height: 20),
                  LinkButtonComponent(
                    text: "Login",
                    onPressed: widget.toggleView,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: _form(context),
        desktop: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(32.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 32.0),
                child: _form(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
