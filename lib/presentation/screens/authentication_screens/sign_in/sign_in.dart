import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/exceptions/gql_exceptions.dart';
import 'package:acroworld/presentation/components/buttons/link_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({required this.toggleView, super.key});
  final VoidCallback toggleView;

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String errorEmail = '';
  String errorPassword = '';
  bool isObscure = true;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // Navigate when authProvider becomes authenticated
    ref.listen<AsyncValue<AuthState>>(authProvider, (prev, next) {
      next.when(
        data: (auth) {
          if (auth.status == AuthStatus.authenticated) {
            context.pushNamed(discoverRoute);
          }
        },
        loading: () {},
        error: (_, __) {},
      );
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> onSignin() async {
    // Clear previous errors
    setState(() {
      error = '';
      errorEmail = '';
      errorPassword = '';
    });

    if (!_formKey.currentState!.validate()) return;

    try {
      // Delegate login to your AuthNotifier.signIn
      await ref
          .read(authProvider.notifier)
          .signIn(emailController.text, passwordController.text);
      // Redirect will happen in the ref.listen above
    } on AuthException catch (e) {
      // Show field & global errors
      setState(() {
        errorEmail = e.fieldErrors['email'] ?? '';
        errorPassword = e.fieldErrors['password'] ?? '';
        error = e.globalError;
      });
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      setState(() {
        error = 'An unexpected error occurred. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);
    final isLoading = authAsync.isLoading;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

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
                          image: AssetImage(
                            'assets/logo/logo_transparent.png',
                          ),
                          height: 100,
                        ),
                      ),

                      // Email field
                      InputFieldComponent(
                        controller: emailController,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        labelText: 'Email',
                        autoFocus: true,
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'Enter an email'
                            : null,
                      ),
                      if (errorEmail.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              errorEmail,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20.0),

                      // Password field
                      InputFieldComponent(
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        obscureText: isObscure,
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () =>
                              setState(() => isObscure = !isObscure),
                        ),
                        onFieldSubmitted: (_) {
                          if (!isLoading) onSignin();
                        },
                      ),
                      if (errorPassword.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              errorPassword,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20.0),

                      // Login button
                      StandardButton(
                        text: "Login",
                        onPressed: isLoading ? () {} : onSignin,
                        loading: isLoading,
                        isFilled: true,
                        buttonFillColor: CustomColors.primaryColor,
                      ),

                      if (error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 20)
                            .copyWith(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => context.goNamed(
                                forgotPasswordRoute,
                                pathParameters: {"email": emailController.text},
                              ),
                              child: Text(
                                "Forgot password",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: CustomColors.linkTextColor),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Register link
                      LinkButtonComponent(
                        text: "Register",
                        onPressed: widget.toggleView,
                      ),

                      const SizedBox(height: 40),
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
}
