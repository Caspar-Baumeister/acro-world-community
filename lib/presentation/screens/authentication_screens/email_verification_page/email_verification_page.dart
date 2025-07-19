import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/user_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  final String? code;
  const EmailVerificationPage({super.key, required this.code});

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  bool _isVerifying = false;
  final codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Delay to allow widget tree to finish building before navigation
    WidgetsBinding.instance.addPostFrameCallback((_) => _verifyCode());
  }

  Future<void> _verifyCode() async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);

    // No code → bail out
    if (widget.code == null || widget.code!.isEmpty) {
      showErrorToast("Invalid verification code");
      if (mounted) context.goNamed(profileRoute);
      setState(() => _isVerifying = false);
      return;
    }

    try {
      final verified = await UserService().verifyCode(widget.code!);
      if (verified != true) {
        showErrorToast("Error verifying email");
        if (mounted) context.goNamed(verifyEmailRoute);
      } else {
        showSuccessToast("Email verified successfully");
        // Invalidate the user so downstream UIs refetch with updated isEmailVerified
        ref.invalidate(userRiverpodProvider);
        if (mounted) context.goNamed(profileRoute);
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      showErrorToast("Error verifying email");
      if (mounted) context.goNamed(verifyEmailRoute);
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _onRefresh() => _verifyCode();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: const CustomAppbarSimple(title: "Email Verification"),
      makeScrollable: false,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
