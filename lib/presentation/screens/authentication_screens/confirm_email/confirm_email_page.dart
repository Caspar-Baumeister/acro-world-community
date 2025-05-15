import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/user_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
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
        ref.invalidate(userRiverpodProvider);
        context.goNamed(profileRoute);
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
        // If not signed in or somehow no user, go back to auth
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('auth');
          });
          return const SizedBox.shrink();
        }

        return BasePage(
          appBar: const CustomAppbarSimple(title: "Confirm your email"),
          makeScrollable: false,
          child: RefreshIndicator(
            onRefresh: _refreshStatus,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPaddings.large,
                vertical: AppPaddings.large,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'We have sent you an email to ${user.email}. '
                    'Click on the confirmation link in the email to continue. '
                    'You need to confirm the email before you can create events.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: CustomColors.secondaryTextColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: InputFieldComponent(
                          controller: codeController,
                          footnoteText: "Enter the code from the email",
                          isFootnoteError: false,
                        ),
                      ),
                      const SizedBox(width: AppPaddings.small),
                      IconButton(
                        icon: const Icon(Icons.paste),
                        onPressed: () async {
                          final clip = await Clipboard.getData('text/plain');
                          codeController.text = clip?.text ?? '';
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppPaddings.medium),
                  StandartButton(
                    text: "Confirm email",
                    isFilled: true,
                    loading: _isRefreshing,
                    onPressed: _verifyCode,
                  ),
                  const SizedBox(height: AppPaddings.medium),
                  if (_isResendDisabled)
                    Text(
                      'Wait $_timer seconds before you can resend the email.',
                      style: const TextStyle(
                          color: CustomColors.secondaryTextColor),
                    ),
                  const SizedBox(height: AppPaddings.small),
                  StandartButton(
                    text: "Resend email",
                    onPressed: _isResendDisabled
                        ? () => showErrorToast(
                            "Please wait $_timer more seconds before resending")
                        : _resendVerificationEmail,
                  ),
                  const SizedBox(height: AppPaddings.small),
                  StandartButton(
                    text: "Refresh status",
                    loading: _isRefreshing,
                    onPressed: _refreshStatus,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
