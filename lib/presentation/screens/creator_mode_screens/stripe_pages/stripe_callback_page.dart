// Your imports (replace these with the actual imports in your code)
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/creator_profile_page_route.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page that verifies a Stripe account, provides feedback to the user,
/// and navigates to the Creator Profile page upon success or failure.
class StripeCallbackPage extends StatefulWidget {
  final String? stripeId;

  const StripeCallbackPage({super.key, this.stripeId});

  @override
  State<StripeCallbackPage> createState() => _StripeCallbackPageState();
}

class _StripeCallbackPageState extends State<StripeCallbackPage> {
  /// A flag to indicate whether we're currently verifying the Stripe account
  /// to avoid re-calling the API while it's in progress.
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _verifyStripeAccount();
  }

  /// Verifies the Stripe account through the [StripeRepository].
  /// On success, we show a success toast, set the user role, and navigate
  /// to the Creator Profile Page. On failure or aborted setup, we show
  /// an info toast and also navigate to the Creator Profile Page.
  Future<void> _verifyStripeAccount() async {
    print("Verifying stripe account for id: ${widget.stripeId}");
    // If we're already verifying, do nothing.
    if (_isVerifying) return;

    setState(() => _isVerifying = true);

    try {
      final graphQLSingleton = GraphQLClientSingleton();
      final isStripeVerified =
          await StripeRepository(apiService: graphQLSingleton)
              .verifyStripeAccount();

      print("inside stripe callback page isStripeVerified: $isStripeVerified");

      // Update the GraphQL client in case user details or auth tokens changed
      graphQLSingleton.updateClient(true);

      // No matter success or aborted, we mark the user as a creator in this flow
      // (adjust this logic if "aborted" means they are not a creator).
      Provider.of<UserRoleProvider>(context, listen: false).setIsCreator(true);

      if (isStripeVerified) {
        showSuccessToast("Your stripe account has been verified");

        // Update user and creator from token so the app can reflect newly minted role/status
        Provider.of<UserProvider>(context, listen: false).setUserFromToken();
        Provider.of<CreatorProvider>(context, listen: false)
            .setCreatorFromToken();
      } else {
        showInfoToast("Stripe account setup aborted");
      }

      // Navigate to the creator profile page regardless of success or aborted
      if (mounted) {
        Navigator.of(context).pushReplacement(CreatorProfilePageRoute());
      }
    } catch (e, stackTrace) {
      // Capture the exception for further analysis
      CustomErrorHandler.captureException(e, stackTrace: stackTrace);

      // Show an error toast to the user
      showErrorToast("Error verifying Stripe account, please contact support");

      // Navigate to the Creator Profile Page (or a support page) to allow the user to continue
      if (mounted) {
        Navigator.of(context).pushReplacement(CreatorProfilePageRoute());
      }
    } finally {
      // Stop the loading indicator
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  /// Allows users to manually refresh the verification if needed (pull to refresh).
  Future<void> _onRefresh() => _verifyStripeAccount();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      makeScrollable: false,
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddings.extraLarge,
                    vertical: AppPaddings.extraLarge,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Show a spinner if currently verifying
                      if (_isVerifying) const CircularProgressIndicator(),

                      const SizedBox(height: 30),

                      Text(
                        "Verifying Stripe account for id: ${widget.stripeId ?? "N/A"}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      // Optional: Provide some helpful instruction while verifying
                      const SizedBox(height: 20),
                      const Text(
                        "If the verification takes longer, you can pull down to refresh this page.",
                        textAlign: TextAlign.center,
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
  }
}
