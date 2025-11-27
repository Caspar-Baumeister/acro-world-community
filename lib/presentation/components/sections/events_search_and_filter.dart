import 'package:acroworld/presentation/components/filters/modern_filter_chip.dart';
import 'package:acroworld/presentation/components/input/modern_search_bar.dart'
    hide ModernFilterChip;
import 'package:flutter/material.dart';

class EventsSearchAndFilter extends StatefulWidget {
  final String searchQuery;
  final String selectedFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String>? onSearchSubmitted;

  const EventsSearchAndFilter({
    super.key,
    required this.searchQuery,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onSearchSubmitted,
  });

  @override
  State<EventsSearchAndFilter> createState() => _EventsSearchAndFilterState();
}

class _EventsSearchAndFilterState extends State<EventsSearchAndFilter> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(EventsSearchAndFilter oldWidget) {
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
            hintText: "Search events by title or location...",
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
                  label: "Active",
                  isSelected: widget.selectedFilter == "active",
                  onTap: () => widget.onFilterChanged("active"),
                  icon: Icons.event,
                ),
                // Removed Draft and Completed per requirement: only Active or All
              ],
            ),
          ),
        ],
      ),
    );
  }
}
