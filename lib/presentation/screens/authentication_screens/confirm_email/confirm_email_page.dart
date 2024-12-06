import 'dart:async';

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/profile_page_route.dart';
import 'package:acroworld/services/user_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool isLoaded = false;

  TextEditingController codeController = TextEditingController();

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
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // inputfield for code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: InputFieldComponent(
                              controller: codeController,
                              footnoteText: "Enter the code from the email",
                              isFootnoteError: false,
                            ),
                          ),
                          SizedBox(width: AppPaddings.small),
                          // button with paste icon to paste code from clipboard
                          IconButton(
                            icon: const Icon(Icons.paste),
                            onPressed: () async {
                              codeController.text =
                                  await Clipboard.getData('text/plain')
                                      .then((value) => value?.text ?? "");
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppPaddings.medium),
                      // button to confirm email with code
                      StandardButton(
                        text: "Confirm email",
                        isFilled: true,
                        onPressed: () async {
                          setState(() {
                            isLoaded = true;
                          });
                          await verifyCode();
                          setState(() {
                            isLoaded = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
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

  // function when verification code is entered
  Future<void> verifyCode() async {
    if (codeController.text.isEmpty) {
      showErrorToast("Please enter the code from the email");
      return;
    }
    try {
      UserService().verifyCode(codeController.text).then((value) {
        if (value == null || value == false) {
          // error toast
          showErrorToast("Wrong verification code");
        } else {
          // success toast
          showSuccessToast("Email verified successfully");
          // Send to profile page
          Navigator.of(context).push(ProfilePageRoute());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<UserProvider>(context, listen: false)
                .setUserFromToken();
          });
        }
      });
    } catch (e) {
      CustomErrorHandler.captureException(e.toString());
      showErrorToast("Error verifying email");
    }
  }
}
