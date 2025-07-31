import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/standard_app_bar/standard_app_bar.dart';
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
        body: Center(child: CircularProgressIndicator()),
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

        return Scaffold(
          appBar: StandardAppBar(title: "Confirm Email"),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshStatus,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingLarge,
                        vertical: AppDimensions.spacingLarge,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ─── ICON & COPY ───────────────────────────────
                          Column(
                            children: [
                              Icon(
                                Icons.mark_email_unread,
                                size: 64,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Check Your Inbox",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  "We've sent a confirmation link to "
                                  "${user.email}. Please click the link to verify your email.",
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // ─── CODE INPUT ────────────────────────────────
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                controller: codeController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(letterSpacing: 8),
                                decoration: InputDecoration(
                                  hintText: "Enter confirmation code",
                                  hintStyle: const TextStyle(
                                    letterSpacing: 8,
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.content_paste,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6)),
                                onPressed: () async {
                                  final clip =
                                      await Clipboard.getData('text/plain');
                                  codeController.text = clip?.text ?? '';
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ─── BUTTONS ───────────────────────────────────
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Confirm
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: _verifyCode,
                                child: _isRefreshing
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "Confirm Email",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                              ),
                              const SizedBox(height: 12),

                              // Resend
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: _isResendDisabled
                                    ? () => showErrorToast(
                                        "Please wait $_timer more seconds before resending")
                                    : _resendVerificationEmail,
                                child: Text(
                                  _isResendDisabled
                                      ? "Resend in $_timer s"
                                      : "Resend Email",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Refresh
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: _refreshStatus,
                                child: _isRefreshing
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "Refresh Status",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),
                          // NOTE
                          Text(
                            "Didn't receive the email? Check your spam folder or try resending.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
