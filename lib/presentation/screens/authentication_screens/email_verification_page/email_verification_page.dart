// Replace with your actual imports
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/user_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// A page that verifies a user's email using a provided [code].
class EmailVerificationPage extends StatefulWidget {
  final String? code;

  const EmailVerificationPage({
    super.key,
    required this.code,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  /// Indicates if the email verification is currently in progress
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _verifyCode();
  }

  /// Verifies the user's email via [UserService].
  /// If verification succeeds, navigates to ProfilePage.
  /// Otherwise, navigates to ConfirmEmailPage for re-attempt or guidance.
  Future<void> _verifyCode() async {
    // If already verifying, skip
    print(
        "Verifying email with code: ${widget.code}, isVerifying: $_isVerifying");
    if (_isVerifying) return;

    setState(() => _isVerifying = true);

    // If no code is provided, immediately fail and navigate
    if (widget.code == null || widget.code!.isEmpty) {
      showErrorToast("Invalid verification code");
      if (mounted) {
        context.goNamed(profileRoute);
      }
      setState(() => _isVerifying = false);
      return;
    }

    try {
      final verified = await UserService().verifyCode(widget.code!);
      print("Email verification result: $verified");
      if (verified == null || verified == false) {
        // Verification failed
        showErrorToast("Error verifying email");
        if (mounted) {
          // Navigate to ConfirmEmailPage for re-attempt
          context.goNamed(confirmEmailRoute);
        }
      } else {
        // Verification success
        showSuccessToast("Email verified successfully");
        if (mounted) {
          // Update the user data after successful verification
          Provider.of<UserProvider>(context, listen: false).setUserFromToken();
          // Navigate to ProfilePage
          context.goNamed(profileRoute);
        }
      }
    } catch (e, stackTrace) {
      // Log the error for further inspection
      CustomErrorHandler.captureException(e, stackTrace: stackTrace);

      // Show user-friendly error
      showErrorToast("Error verifying email");
      if (mounted) {
        context.goNamed(confirmEmailRoute);
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  /// Allows the user to re-trigger the verification via pull-to-refresh.
  Future<void> _onRefresh() => _verifyCode();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: const CustomAppbarSimple(title: "Email Verification"),
      makeScrollable: false,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        // Wrapping in a scroll view so that pull-to-refresh works
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // Force at least full screen height so pull-to-refresh always works
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isVerifying) const CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Text("Verifying email..."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
