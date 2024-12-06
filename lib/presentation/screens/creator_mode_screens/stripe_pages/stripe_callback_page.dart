import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/creator_profile_page_route.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StripeCallbackPage extends StatefulWidget {
  const StripeCallbackPage({super.key, this.stripeId});

  final String? stripeId;

  @override
  State<StripeCallbackPage> createState() => _StripeCallbackPageState();
}

class _StripeCallbackPageState extends State<StripeCallbackPage> {
  // Add initstate to check for code and verify. Then send to either confirmation page or profile

  @override
  void initState() {
    super.initState();
    // Check for code and verify
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verifyStripeAccount();
    });
  }

  //verifyStripeAccount
  Future<void> verifyStripeAccount() async {
    try {
      StripeRepository(apiService: GraphQLClientSingleton())
          .verifyStripeAccount()
          .then((value) {
        if (value == false) {
          // error toast

          showInfoToast("Stripe account set up aborted");
          // Send to confirmation page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(CreatorProfilePageRoute());
          });
        } else {
          // success toast
          showSuccessToast("Your stripe account has been verified");
          // Send to profile page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(CreatorProfilePageRoute());
            Provider.of<UserProvider>(context, listen: false)
                .setUserFromToken();
            Provider.of<CreatorProvider>(context, listen: false)
                .setCreatorFromToken();
          });
        }
      });
    } catch (e) {
      CustomErrorHandler.captureException(e.toString());
      showErrorToast("Error verifying stripe account, please contact support");
      // Send to confirmation page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(CreatorProfilePageRoute());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        makeScrollable: false,
        child: Center(
          child: RefreshIndicator(
            onRefresh: verifyStripeAccount,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddings.extraLarge),
                  child: Text(
                    "Verifying Stripe account for id ${widget.stripeId}",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
