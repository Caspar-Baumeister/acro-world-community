import 'package:acroworld/data/regions.dart';
import 'package:acroworld/presentation/components/searchable_dropdown.dart';
import 'package:flutter/material.dart';

class RegionPicker extends StatelessWidget {
  final String countryCode;
  final String? selectedRegion;
  final ValueChanged<String?> onRegionSelected;

  const RegionPicker({
    super.key,
    required this.countryCode,
    required this.selectedRegion,
    required this.onRegionSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Grab the region list for this country
    final regions = countryRegions[countryCode] ?? [];

    // Convert to DropdownItem (no leading widget)
    final items = regions.map((r) => DropdownItem(key: r, label: r)).toList();

    return SearchableDropdown(
      items: items,
      selectedKey: selectedRegion,
      hintText: 'Select a region',
      onChanged: onRegionSelected,
      footnoteText: 'Choose your region',
    );
  }
}
