import 'package:acroworld/presentation/components/input/modern_search_bar.dart' hide ModernFilterChip;
import 'package:acroworld/presentation/components/filters/modern_filter_chip.dart';
import 'package:flutter/material.dart';

class BookingsSearchAndFilter extends StatelessWidget {
  final String searchQuery;
  final String selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String>? onSearchSubmitted;

  const BookingsSearchAndFilter({
    super.key,
    required this.searchQuery,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          ModernSearchBar(
            hintText: "Search by person name or event...",
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            showFilterButton: false,
            controller: TextEditingController(text: searchQuery),
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ModernFilterChip(
                  label: "All",
                  isSelected: selectedStatus == "all",
                  onTap: () => onStatusChanged("all"),
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Confirmed",
                  isSelected: selectedStatus == "Confirmed",
                  onTap: () => onStatusChanged("Confirmed"),
                  icon: Icons.check_circle,
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Waiting",
                  isSelected: selectedStatus == "WaitingForPayment",
                  onTap: () => onStatusChanged("WaitingForPayment"),
                  icon: Icons.schedule,
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Cancelled",
                  isSelected: selectedStatus == "Cancelled",
                  onTap: () => onStatusChanged("Cancelled"),
                  icon: Icons.cancel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
