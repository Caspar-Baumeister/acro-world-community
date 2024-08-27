import 'package:acroworld/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/profile_page_route.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:acroworld/services/user_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key, required this.code});

  final String? code;

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  // Add initstate to check for code and verify. Then send to either confirmation page or profile

  @override
  void initState() {
    super.initState();
    // Check for code and verify
  }

  //verifyCode
  Future<void> verifyCode() async {
    if (widget.code == null) {
      // error toast
      showErrorToast("Invalid verification code");
      // Send to profile page
      Navigator.of(context).push(ProfilePageRoute());
      return;
    }
    UserService().verifyCode(widget.code!).then((value) {
      if (!value) {
        // error toast
        showErrorToast("Error verifying email");
        // Send to confirmation page
        Navigator.of(context).push(ConfirmEmailPageRoute());
      } else {
        // success toast
        showSuccessToast("Email verified successfully");
        // Send to profile page
        Navigator.of(context).push(ProfilePageRoute());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<UserProvider>(context, listen: false).setUserFromToken();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        appBar: const CustomAppbarSimple(
          title: "Email Verification",
        ),
        child: Center(
          child: RefreshIndicator(
            onRefresh: verifyCode,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Verifying email..."),
              ],
            ),
          ),
        ));
  }
}
