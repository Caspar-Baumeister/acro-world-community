import 'package:acroworld/presentation/components/input/modern_search_bar.dart' hide ModernFilterChip;
import 'package:acroworld/presentation/components/filters/modern_filter_chip.dart';
import 'package:flutter/material.dart';

class EmailInvitationsSearchAndFilter extends StatefulWidget {
  final String searchQuery;
  final String selectedFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String>? onSearchSubmitted;

  const EmailInvitationsSearchAndFilter({
    super.key,
    required this.searchQuery,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onSearchSubmitted,
  });

  @override
  State<EmailInvitationsSearchAndFilter> createState() => _EmailInvitationsSearchAndFilterState();
}

class _EmailInvitationsSearchAndFilterState extends State<EmailInvitationsSearchAndFilter> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(EmailInvitationsSearchAndFilter oldWidget) {
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
            hintText: "Search by teacher name or event...",
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
                  isSelected: widget.selectedFilter == "all",
                  onTap: () => widget.onFilterChanged("all"),
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Accepted",
                  isSelected: widget.selectedFilter == "accepted",
                  onTap: () => widget.onFilterChanged("accepted"),
                  icon: Icons.check_circle,
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Pending",
                  isSelected: widget.selectedFilter == "pending",
                  onTap: () => widget.onFilterChanged("pending"),
                  icon: Icons.schedule,
                ),
                const SizedBox(width: 8),
                ModernFilterChip(
                  label: "Rejected",
                  isSelected: widget.selectedFilter == "rejected",
                  onTap: () => widget.onFilterChanged("rejected"),
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
