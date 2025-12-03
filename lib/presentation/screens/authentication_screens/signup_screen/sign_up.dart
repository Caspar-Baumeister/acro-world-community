import 'dart:typed_data';

import 'package:acroworld/exceptions/auth_exception.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/link_button.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/components/input/user_image_picker.dart';
// TODO: UNCOMMENT WHEN READY TO IMPLEMENT IMAGE UPLOAD DURING REGISTRATION
// import 'package:acroworld/presentation/components/input/user_image_picker.dart';
import 'package:acroworld/presentation/screens/authentication_screens/signup_screen/widgets/agbsCheckBox.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/services/user_image_service.dart';
// TODO: UNCOMMENT WHEN READY TO IMPLEMENT IMAGE UPLOAD DURING REGISTRATION
// import 'package:acroworld/services/user_image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  bool isAgb = false;
  bool isNewsletter = false;

  bool passwordObscure = true;
  bool passwordConfirmObscure = true;

  // Image upload state
  Uint8List? _selectedImageBytes;
  bool _isUploadingImage = false;

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
    });

    if (!_formKey.currentState!.validate()) return;
    if (passwordController.text != passwordConfirmController.text) {
      setState(() => error = 'Passwords do not match');
      return;
    }
    if (!isAgb) {
      setState(() => error = 'Please accept the terms and conditions');
      return;
    }

    try {
      String? imageUrl;

      // 1. Upload profile image first if selected
      if (_selectedImageBytes != null) {
        setState(() {
          _isUploadingImage = true;
        });

        try {
          // Generate a temporary user ID for the image path
          // This will be used to create a unique path for the image
          final tempUserId = DateTime.now().millisecondsSinceEpoch.toString();
          final imagePath = 'user-images/$tempUserId/profile.png';

          // Upload image directly to Firebase Storage
          final imageUploadService = ImageUploadService();
          imageUrl = await imageUploadService.uploadImage(
            _selectedImageBytes!,
            path: imagePath,
          );
          print('📝 DEBUG: SignUp - Image uploaded successfully: $imageUrl');
        } catch (e) {
          // Don't fail registration if image upload fails
          print('Warning: Failed to upload profile image: $e');
          imageUrl = null;
        } finally {
          if (mounted) {
            setState(() {
              _isUploadingImage = false;
            });
          }
        }
      }

      // 2. Register the user with the image URL (if uploaded successfully)
      await ref.read(authProvider.notifier).register(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
            isNewsletter: isNewsletter,
            imageUrl: imageUrl,
          );

      if (!mounted) return;

      // 3. Navigate to next screen
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
      setState(() {
        error = e.error;
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
                : const BoxConstraints(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: isKeyboardOpen
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: const Image(
                        image: AssetImage('assets/logo/logo_transparent.png'),
                        height: 100,
                      ),
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
                  const SizedBox(height: 20.0),

                  // Profile Image Section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        Text(
                          'Profile Picture (Optional)',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                        ),
                        const SizedBox(height: 12.0),
                        UserImagePickerComponent(
                          currentImageUrl: null,
                          onImageSelected: (imageBytes) {
                            setState(() {
                              _selectedImageBytes = imageBytes;
                            });
                          },
                          onImageRemoved: () {
                            setState(() {
                              _selectedImageBytes = null;
                            });
                          },
                          size: 80,
                          showEditIcon: true,
                          showRemoveButton: true,
                          isLoading: _isUploadingImage,
                        ),
                        if (_selectedImageBytes != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Image selected',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                      ],
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
                  ModernButton(
                    text: _isUploadingImage ? "Uploading Image..." : "Register",
                    onPressed:
                        (isLoading || _isUploadingImage) ? null : _onRegister,
                    isLoading: isLoading || _isUploadingImage,
                    isFilled: true,
                  ),
                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        error,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.error),
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
      appBar: Responsive.isMobile(context)
          ? AppBar(
              title: const Text("Sign Up"),
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
