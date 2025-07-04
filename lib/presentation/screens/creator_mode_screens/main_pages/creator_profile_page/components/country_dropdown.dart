import 'package:acroworld/presentation/components/searchable_dropdown.dart';
import 'package:acroworld/utils/helper_functions/country_helpers.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class CountryPicker extends StatelessWidget {
  final String? selectedCountryCode;
  final Function(String? code, String? name) onCountrySelected;

  const CountryPicker({
    super.key,
    required this.selectedCountryCode,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    // Build a list of DropdownItem from your allCountries map
    final items = allCountries.entries
        .map((e) => DropdownItem(
              key: e.key,
              label: e.value,
              leading: Flag.fromString(e.key, width: 32, height: 24),
            ))
        .toList();

    return SearchableDropdown(
      items: items,
      selectedKey: selectedCountryCode,
      hintText: 'Select a country',
      onChanged: (code) {
        final name = code == null ? null : allCountries[code];
        onCountrySelected(code, name);
      },
      footnoteText: 'Choose your country',
    );
  }
}
