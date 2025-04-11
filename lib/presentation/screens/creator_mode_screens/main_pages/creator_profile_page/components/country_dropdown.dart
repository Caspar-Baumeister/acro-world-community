import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class CustomCountryDropdown extends StatelessWidget {
  final String? currentlySelected; // This should contain the full country name.
  final ValueChanged<String> onCountrySelected;
  final String hintText;
  final String? footnoteText;

  const CustomCountryDropdown({
    super.key,
    required this.currentlySelected,
    required this.onCountrySelected,
    this.hintText = 'Select a country',
    this.footnoteText,
  });

  // Map of country code to full country name.
  static const Map<String, String> _countryMap = {
    "AU": "Australia",
    "AT": "Austria",
    "BE": "Belgium",
    "BG": "Bulgaria",
    "BR": "Brazil",
    "CA": "Canada",
    "HR": "Croatia",
    "CY": "Cyprus",
    "CZ": "Czech Republic",
    "DK": "Denmark",
    "EE": "Estonia",
    "FI": "Finland",
    "FR": "France",
    "DE": "Germany",
    "GR": "Greece",
    "HK": "Hong Kong",
    "HU": "Hungary",
    // "IN": "India",       // India is not yet supported by Stripe (preview)
    // "ID": "Indonesia",   // Indonesia is not yet supported by Stripe (preview)
    "IE": "Ireland",
    "IT": "Italy",
    "JP": "Japan",
    "LV": "Latvia",
    "LI": "Liechtenstein",
    "LT": "Lithuania",
    "LU": "Luxembourg",
    "MY": "Malaysia",
    "MT": "Malta",
    "MX": "Mexico",
    "NL": "Netherlands",
    "NZ": "New Zealand",
    "NG": "Nigeria",
    "NO": "Norway",
    "PL": "Poland",
    "PT": "Portugal",
    "RO": "Romania",
    "SG": "Singapore",
    "SK": "Slovakia",
    "SI": "Slovenia",
    "ZA": "South Africa",
    "ES": "Spain",
    "SE": "Sweden",
    "CH": "Switzerland",
    "TH": "Thailand",
    "AE": "United Arab Emirates",
    "GB": "United Kingdom",
    "US": "United States",
  };

  @override
  Widget build(BuildContext context) {
    // Verify that the currently selected country (full name) exists in the country list.
    final bool isValidSelection = currentlySelected != null &&
        _countryMap.containsValue(currentlySelected!);
    final String? selectedValue = isValidSelection ? currentlySelected : null;

    // Build the list of dropdown items.
    final List<DropdownMenuItem<String>> dropdownItems = [
      DropdownMenuItem<String>(
        value: null,
        enabled: false,
        child: Text(
          hintText,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
      ..._countryMap.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.value, // The full country name is stored.
          child: Row(
            children: [
              // Display the flag using the country code.
              Flag.fromString(
                entry.key,
                width: 32,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(entry.value),
            ],
          ),
        );
      }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: CustomColors.primaryTextColor),
            alignLabelWithHint: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppPaddings.medium)
                    .copyWith(bottom: AppPaddings.tiny),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              hint: Text(hintText),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onCountrySelected(newValue);
                }
              },
              items: dropdownItems,
            ),
          ),
        ),
        if (footnoteText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10),
            child: Text(
              footnoteText!,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: CustomColors.primaryTextColor,
                  ),
            ),
          )
      ],
    );
  }
}
