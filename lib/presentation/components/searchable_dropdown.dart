import 'package:flutter/material.dart';

/// A simple model for each dropdown entry.
class DropdownItem {
  /// A unique key (e.g. country code or region name).
  final String key;

  /// The text label to show.
  final String label;

  /// An optional leading icon/widget (e.g. a flag).
  final Widget? leading;

  const DropdownItem({
    required this.key,
    required this.label,
    this.leading,
  });
}

class SearchableDropdown extends StatefulWidget {
  /// The list of all possible items.
  final List<DropdownItem> items;

  /// The currently selected key, or null.
  final String? selectedKey;

  /// Called when the user picks a new key (or null to clear).
  final ValueChanged<String?> onChanged;

  /// Placeholder shown when nothing is selected.
  final String hintText;

  /// Optional footnote below the field.
  final String? footnoteText;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.selectedKey,
    required this.onChanged,
    this.hintText = 'Select',
    this.footnoteText,
  });

  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  void _openSearchDialog() async {
    String filter = '';
    final DropdownItem? picked = await showDialog<DropdownItem>(
      context: context,
      builder: (context) {
        // We rebuild dialog contents when filter changes
        return StatefulBuilder(builder: (context, setState) {
          final List<DropdownItem> filtered = widget.items
              .where((item) =>
                  item.label.toLowerCase().contains(filter.toLowerCase()))
              .toList();

          return AlertDialog(
            title: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Search…'),
              onChanged: (v) => setState(() => filter = v),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: filtered.isEmpty
                  ? const Center(child: Text('No matches'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final it = filtered[i];
                        return ListTile(
                          leading: it.leading,
                          title: Text(it.label),
                          onTap: () => Navigator.pop(context, it),
                        );
                      },
                    ),
            ),
          );
        });
      },
    );

    // Notify parent
    widget.onChanged(picked?.key);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = widget.selectedKey != null;
    final DropdownItem? selectedItem = hasSelection
        ? widget.items.firstWhere((it) => it.key == widget.selectedKey,
            orElse: () => DropdownItem(key: '', label: ''))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _openSearchDialog,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: widget.hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.white,
            ),
            child: Row(
              children: [
                if (hasSelection && selectedItem != null) ...[
                  if (selectedItem.leading != null) selectedItem.leading!,
                  if (selectedItem.leading != null) const SizedBox(width: 8),
                  Expanded(child: Text(selectedItem.label)),
                ] else
                  Expanded(
                    child: Text(widget.hintText,
                        style: const TextStyle(color: Colors.grey)),
                  ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (widget.footnoteText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 10),
            child: Text(widget.footnoteText!,
                style: Theme.of(context).textTheme.bodySmall),
          ),
      ],
    );
  }
}
