import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/user_service.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConfirmEmailPage extends ConsumerStatefulWidget {
  const ConfirmEmailPage({super.key});

  @override
  ConsumerState<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends ConsumerState<ConfirmEmailPage> {
  int _timer = 0;
  Timer? _countdownTimer;
  bool _isResendDisabled = false;
  bool _isRefreshing = false;

  final codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    final success = await UserService().sendEmailVerification();
    if (success) _startTimer();
  }

  Future<void> _resendVerificationEmail() async {
    final success = await UserService().resendEmailVerification();
    if (success) _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _timer = 10;
      _isResendDisabled = true;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timer > 0) {
        setState(() => _timer--);
      } else {
        t.cancel();
        setState(() => _isResendDisabled = false);
      }
    });
  }

  Future<void> _refreshStatus() async {
    setState(() => _isRefreshing = true);
    try {
      // Force a refetch of the userProvider
      final updatedUser = await ref.refresh(userRiverpodProvider.future);
      if (updatedUser?.isEmailVerified == true) {
        // Clear cache and go to profile
        ref.invalidate(userRiverpodProvider);
        context.goNamed(profileRoute);
        return;
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  Future<void> _verifyCode() async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      showErrorToast("Please enter the code from the email");
      return;
    }

    setState(() => _isRefreshing = true);
    try {
      final ok = await UserService().verifyCode(code);
      if (ok == true) {
        showSuccessToast("Email verified successfully");
        // Invalidate so new "verified" user is fetched downstream

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Check if we can pop this route
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            // If we can't pop, navigate to home
            context.go('/');
          }

          ref.invalidate(userRiverpodProvider);
          ref.invalidate(userNotifierProvider);
        });
      } else {
        showErrorToast("Wrong verification code");
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      showErrorToast("Error verifying email");
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ModernSkeleton(width: 200, height: 20),
              SizedBox(height: 16),
              ModernSkeleton(width: 300, height: 100),
            ],
          ),
        ),
      ),
      error: (err, st) {
        CustomErrorHandler.captureException(err.toString(), stackTrace: st);
        return Scaffold(
          body: Center(child: Text("Failed to load user: $err")),
        );
      },
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('auth');
          });
          return const SizedBox.shrink();
        }

        return BasePage(
          appBar: const CustomAppbarSimple(title: "Confirm Email"),
          child: RefreshIndicator(
            onRefresh: _refreshStatus,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mark_email_read,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      "Check Your Inbox",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Text(
                      "We've sent a confirmation link to ${user.email}. Please click the link to verify your email.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Code Input
                    InputFieldComponent(
                      controller: codeController,
                      labelText: "Enter confirmation code",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _verifyCode(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.content_paste,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                        onPressed: () async {
                          final clip = await Clipboard.getData('text/plain');
                          if (clip?.text != null) {
                            codeController.text = clip!.text!;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Confirm Button
                    ModernButton(
                      text: "Confirm Email",
                      onPressed: _isRefreshing ? null : _verifyCode,
                      isLoading: _isRefreshing,
                      isFilled: true,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 12),
                    // Resend Button
                    ModernButton(
                      text: _isResendDisabled
                          ? "Resend possible in $_timer s"
                          : "Resend Email",
                      onPressed: _isResendDisabled
                          ? () => showErrorToast(
                              "Please wait $_timer more seconds before resending")
                          : _resendVerificationEmail,
                      isOutlined: true,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 12),
                    // Refresh Status Button
                    ModernButton(
                      text: "Refresh Status",
                      onPressed: _isRefreshing ? null : _refreshStatus,
                      isLoading: _isRefreshing,
                      isFilled: false,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 32),
                    // Help Text
                    Text(
                      "Didn't receive the email? Check your spam folder or try resending.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
