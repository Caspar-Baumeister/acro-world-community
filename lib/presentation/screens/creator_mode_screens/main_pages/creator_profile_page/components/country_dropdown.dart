import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/country_helpers.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class CustomCountryDropdown extends StatelessWidget {
  final String? currentlySelected; // This should contain the full country name.
  final Function(String?, String?) onCountrySelected;
  final String hintText;
  final String? footnoteText;

  const CustomCountryDropdown({
    super.key,
    required this.currentlySelected,
    required this.onCountrySelected,
    this.hintText = 'Select a country',
    this.footnoteText,
  });

  @override
  Widget build(BuildContext context) {
    // Verify that the currently selected country (full name) exists in the country list.
    final bool isValidSelection = currentlySelected != null &&
        allCountries.containsValue(currentlySelected!);
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
      ...allCountries.entries.map((entry) {
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
                  onCountrySelected(
                      newValue,
                      allCountries.keys.firstWhere(
                        (key) => allCountries[key] == newValue,
                        orElse: () => '',
                      ));
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
