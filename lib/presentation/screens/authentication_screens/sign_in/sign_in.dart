import 'package:acroworld/exceptions/auth_exception.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/link_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({required this.toggleView, this.redirectAfter, super.key});

  final VoidCallback toggleView;
  final String? redirectAfter;

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

  bool isObscure = true;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!mounted) return;
    setState(() {
      error = '';
    });

    if (!_formKey.currentState!.validate()) return;

    try {
      await ref
          .read(authProvider.notifier)
          .signIn(emailController.text, passwordController.text);

      if (!mounted) return;

      if (widget.redirectAfter != null) {
        context.go(widget.redirectAfter!);
      } else {
        if (Navigator.canPop(context)) {
          context.pop();
        } else {
          context.go('/');
        }
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.error;
      });
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      if (!mounted) return;
      setState(() {
        error = 'An unexpected error occurred. Please try again later.';
      });
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
                : const BoxConstraints(),
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
                    const SizedBox(height: 20.0),
                    InputFieldComponent(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      obscureText: isObscure,
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => isObscure = !isObscure),
                      ),
                      onFieldSubmitted: (_) {
                        if (!isLoading) _onSignIn();
                      },
                    ),
                    const SizedBox(height: 20.0),
                    StandartButton(
                      text: "Login",
                      onPressed: isLoading ? () {} : _onSignIn,
                      loading: isLoading,
                      isFilled: true,
                    ),
                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          error,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error)
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20)
                          .copyWith(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                forgotPasswordRoute,
                                queryParameters: {
                                  "email": emailController.text,
                                },
                              );
                            },
                            child: Text(
                              "Forgot password",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ],
                      ),
                    ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              title: const Text("Sign In"),
              centerTitle: true,
            )
          : null,
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
