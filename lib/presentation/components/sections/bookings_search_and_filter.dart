import 'package:acroworld/presentation/components/input/modern_search_bar.dart' hide ModernFilterChip;
import 'package:acroworld/presentation/components/filters/modern_filter_chip.dart';
import 'package:flutter/material.dart';

class BookingsSearchAndFilter extends StatefulWidget {
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
  State<BookingsSearchAndFilter> createState() => _BookingsSearchAndFilterState();
}

class _BookingsSearchAndFilterState extends State<BookingsSearchAndFilter> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(BookingsSearchAndFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          ModernSearchBar(
            hintText: "Search by person name or event...",
            onChanged: widget.onSearchChanged,
            onSubmitted: widget.onSearchSubmitted,
            showFilterButton: false,
            controller: _controller,
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ModernFilterChip(
                  label: "All",
                  isSelected: widget.selectedStatus == "all",
                  onTap: () => widget.onStatusChanged("all"),
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Confirmed",
                  isSelected: widget.selectedStatus == "Confirmed",
                  onTap: () => widget.onStatusChanged("Confirmed"),
                  icon: Icons.check_circle,
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Waiting",
                  isSelected: widget.selectedStatus == "WaitingForPayment",
                  onTap: () => widget.onStatusChanged("WaitingForPayment"),
                  icon: Icons.schedule,
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Cancelled",
                  isSelected: widget.selectedStatus == "Cancelled",
                  onTap: () => widget.onStatusChanged("Cancelled"),
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
