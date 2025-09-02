import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/custom_setting_component.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/country_helpers.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatorStripeConnectButton extends ConsumerStatefulWidget {
  const CreatorStripeConnectButton({
    super.key,
  });

  @override
  ConsumerState<CreatorStripeConnectButton> createState() =>
      _CreatorStripeConnectButtonState();
}

class _CreatorStripeConnectButtonState
    extends ConsumerState<CreatorStripeConnectButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final creatorState = ref.watch(creatorProvider);
    if (loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMedium,
            vertical: AppDimensions.spacingSmall),
        child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator())),
      );
    }

    return CustomSettingComponent(
      title: "Payment",
      content: _getButtonText(creatorState),
      onPressed: () => _handleStripeConnection(context, creatorState),
    );
  }

  /// Determines the appropriate button text based on the Stripe connection status.
  String _getButtonText(CreatorState creatorState) {
    print("stripeId: ${creatorState.activeTeacher?.stripeId}");
    print("isStripeEnabled: ${creatorState.activeTeacher?.isStripeEnabled}");
    if (creatorState.activeTeacher?.stripeId == null) {
      return "Connect to Stripe";
    }
    if (creatorState.activeTeacher?.isStripeEnabled == true) {
      return "View Stripe dashboard";
    }
    return "Continue Stripe setup";
  }

  /// Handles the logic for connecting or logging into Stripe.
  Future<void> _handleStripeConnection(
      BuildContext context, CreatorState creatorState) async {
    print("Stripe connect button pressed");
    print("Stripe ID: ${creatorState.activeTeacher?.stripeId}");
    print("Stripe enabled: ${creatorState.activeTeacher?.isStripeEnabled}");

    if (creatorState.activeTeacher?.stripeId != null &&
        creatorState.activeTeacher?.isStripeEnabled != true) {
      await _createStripeUser();
      return;
    }

    if (creatorState.activeTeacher?.isStripeEnabled == true) {
      await _openStripeDashboard();
      return;
    }

    _showCountrySelectionDialog(context);
  }

  /// Shows a dialog to select the country before creating a new Stripe user.
  void _showCountrySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedCountry;
        String? selectedCurrency;
        return AlertDialog(
          title: const Text("Set up Stripe Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You're about to create a Stripe account. This is completly free. \nSet the country and currency of your business or where you usually charge.",
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Select Country",
                ),
                items: _getCountryDropdownItems(),
                onChanged: (value) => selectedCountry = value,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Select Default Currency",
                ),
                items: _getCurrencyDropdownItems(),
                onChanged: (value) => selectedCurrency = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            StandartButton(
              onPressed: () async {
                if (selectedCountry != null && selectedCurrency != null) {
                  setState(() {
                    loading = true;
                  });
                  Navigator.pop(context);
                  await _createStripeUser(
                    countryCode: selectedCountry,
                    defaultCurrency: selectedCurrency,
                  );
                  setState(() {
                    loading = false;
                  });
                } else {
                  showErrorToast("Please select both country and currency");
                }
              },
              text: "Continue",
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _getCurrencyDropdownItems() {
    const Map<String, String> currencyMap = {
      "AUD": "Australian Dollar (\$)",
      "BGN": "Bulgarian Lev (лв)",
      "CAD": "Canadian Dollar (\$)",
      "CHF": "Swiss Franc (CHF)",
      "CZK": "Czech Koruna (Kč)",
      "DKK": "Danish Krone (kr)",
      "EUR": "Euro (€)",
      "GBP": "British Pound (£)",
      "HKD": "Hong Kong Dollar (HK\$)",
      "HUF": "Hungarian Forint (Ft)",
      "JPY": "Japanese Yen (¥)",
      "MXN": "Mexican Peso (MX\$)",
      "NOK": "Norwegian Krone (kr)",
      "NZD": "New Zealand Dollar (\$)",
      "PLN": "Polish Złoty (zł)",
      "RON": "Romanian Leu (lei)",
      "SEK": "Swedish Krona (kr)",
      "SGD": "Singapore Dollar (\$)",
      "USD": "United States Dollar (\$)",
    };

    return currencyMap.entries
        .map((entry) => DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value),
            ))
        .toList();
  }

  /// Generates the list of available country dropdown items with flags.
  List<DropdownMenuItem<String>> _getCountryDropdownItems() {
    return stripeSupportedCountries.entries
        .map((entry) => DropdownMenuItem(
              value: entry.key,
              child: Row(
                children: [
                  Flag.fromString(entry.key,
                      height: 20, width: 30, fit: BoxFit.fill),
                  const SizedBox(width: 10),
                  Text(entry.value),
                ],
              ),
            ))
        .toList();
  }

  /// Creates a new Stripe user and opens the Stripe dashboard link if successful.
  Future<void> _createStripeUser(
      {String? countryCode, String? defaultCurrency}) async {
    final stripeUrl = await ref.read(creatorProvider.notifier).createStripeUser(
        countryCode: countryCode, defaultCurrency: defaultCurrency);
    if (stripeUrl != null) {
      customLaunch(stripeUrl);
    } else {
      showErrorToast("Failed to open Stripe dashboard");
    }
  }

  /// Retrieves and opens the Stripe login link, or shows an error if unavailable.
  Future<void> _openStripeDashboard() async {
    final loginUrl =
        await ref.read(creatorProvider.notifier).getStripeLoginLink();
    if (loginUrl != null) {
      customLaunch(loginUrl);
    } else {
      showErrorToast("Not implemented yet");
    }
  }
}
