import 'dart:async';

import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/profile_page_route.dart';
import 'package:acroworld/services/user_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({super.key});

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  int _timer = 0;
  Timer? _countdownTimer;
  bool _isResendDisabled = false;
  bool isRefreshingStatusLoading = false;

  @override
  void initState() {
    super.initState();
    sendVerificationEmail();
  }

  Future<bool> sendVerificationEmail() async {
    bool success = await UserService().sendEmailVerification();
    if (success) {
      startTimer();
    }
    return success;
  }

  void startTimer() {
    setState(() {
      _timer = 10;
      _isResendDisabled = true;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timer > 0) {
          _timer--;
        } else {
          _isResendDisabled = false;
          _countdownTimer?.cancel();
        }
      });
    });
  }

  Future<void> refreshStatus(UserProvider userProvider) async {
    setState(() {
      isRefreshingStatusLoading = true;
    });
    userProvider.checkEmailVerification().then((value) {
      if (value == true) {
        return Navigator.of(context).pushAndRemoveUntil(
          ProfilePageRoute(),
          (Route<dynamic> route) => false,
        );
      }
    }).then((value) {
      setState(() {
        isRefreshingStatusLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return BasePage(
      appBar: const CustomAppbarSimple(title: "Confirm your email"),
      makeScrollable: false,
      child: RefreshIndicator(
        onRefresh: () async => refreshStatus(userProvider),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPaddings.large,
            vertical: AppPaddings.large,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'We have sent you an email to ${userProvider.activeUser?.email.toString()}. Click on the confirmation link in the email to continue. You need to confirm the email before you can create events.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: CustomColors.secondaryTextColor),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              if (_isResendDisabled)
                Text(
                  'Wait $_timer seconds before you can resend the email.',
                  style:
                      const TextStyle(color: CustomColors.secondaryTextColor),
                ),
              const Padding(
                padding: EdgeInsets.only(bottom: AppPaddings.large),
              ),
              StandardButton(
                text: "Resend email",
                onPressed: _isResendDisabled
                    ? () => showErrorToast(
                        "Please wait $_timer more seconds before sending another verification email")
                    : () async {
                        bool success = await sendVerificationEmail();
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Failed to send email. Please try again later.')),
                          );
                        }
                      },
              ),
              const SizedBox(height: AppPaddings.medium),
              StandardButton(
                text: "Refresh status",
                onPressed: () async => refreshStatus(userProvider),
                loading: isRefreshingStatusLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
