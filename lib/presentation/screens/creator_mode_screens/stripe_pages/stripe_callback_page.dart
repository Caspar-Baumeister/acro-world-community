import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/creator_provider.dart'; // old ChangeNotifier
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/user_role_provider.dart'; // old ChangeNotifier
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'
    as provider; // alias the provider package

class StripeCallbackPage extends ConsumerStatefulWidget {
  final String? stripeId;
  const StripeCallbackPage({super.key, this.stripeId});

  @override
  ConsumerState<StripeCallbackPage> createState() => _StripeCallbackPageState();
}

class _StripeCallbackPageState extends ConsumerState<StripeCallbackPage> {
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyStripeAccount();
    });
  }

  Future<void> _verifyStripeAccount() async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);

    try {
      final client = GraphQLClientSingleton();
      final isStripeVerified =
          await StripeRepository(apiService: client).verifyStripeAccount();

      // refresh client if needed
      client.updateClient(true);

      // use the old UserRoleProvider
      provider.Provider.of<UserRoleProvider>(context, listen: false)
          .setIsCreator(true);

      // invalidate & refetch Riverpod user
      ref.invalidate(userRiverpodProvider);
      ref.invalidate(userNotifierProvider);

      // use the old CreatorProvider
      provider.Provider.of<CreatorProvider>(context, listen: false)
          .setCreatorFromToken();

      // TODO - set creator to true and index to 3

      if (isStripeVerified) {
        showSuccessToast("Your Stripe account has been verified");
      } else {
        showInfoToast("Stripe account setup aborted");
      }

      if (mounted) {
        context.goNamed(creatorProfileRoute);
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      showErrorToast(
        "Error verifying Stripe account, please contact support",
      );
      if (mounted) {
        context.goNamed(creatorProfileRoute);
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddings.extraLarge,
                  vertical: AppPaddings.extraLarge,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isVerifying) const CircularProgressIndicator(),
                    const SizedBox(height: 30),
                    Text(
                      "Verifying Stripe account for id: "
                      "${widget.stripeId ?? "N/A"}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "If it’s taking too long, pull down to retry.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
