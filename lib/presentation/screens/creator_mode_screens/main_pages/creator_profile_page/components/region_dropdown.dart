import 'package:acroworld/data/regions.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class RegionDropdown extends StatelessWidget {
  final String countryCode;
  final String? currentlySelected;
  final Function(String?) onRegionSelected;
  final String hintText;
  final String? footnoteText;

  const RegionDropdown({
    super.key,
    required this.countryCode,
    required this.currentlySelected,
    required this.onRegionSelected,
    this.hintText = 'Select a region',
    this.footnoteText,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> regions = countryRegions[countryCode] ?? [];

    final bool isValidSelection =
        currentlySelected != null && regions.contains(currentlySelected);
    final String? selectedValue = isValidSelection ? currentlySelected : null;

    final List<DropdownMenuItem<String>> dropdownItems = [
      DropdownMenuItem<String>(
        value: null,
        enabled: false,
        child: Text(
          hintText,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
      ...regions.map((region) {
        return DropdownMenuItem<String>(
          value: region,
          child: Text(region),
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
                  onRegionSelected(newValue);
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
