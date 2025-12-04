import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// A chip that can be removed by tapping the X button
class RemovableChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const RemovableChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMedium,
        vertical: AppDimensions.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 18,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A row/wrap of removable chips with an add button
class ChipInputSection extends StatefulWidget {
  final List<String> chips;
  final String addButtonLabel;
  final String inputHint;
  final void Function(String) onAdd;
  final void Function(String) onRemove;

  const ChipInputSection({
    super.key,
    required this.chips,
    required this.addButtonLabel,
    required this.inputHint,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<ChipInputSection> createState() => _ChipInputSectionState();
}

class _ChipInputSectionState extends State<ChipInputSection> {
  final TextEditingController _controller = TextEditingController();
  bool _isAdding = false;

  void _addChip() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onAdd(text);
      _controller.clear();
      setState(() => _isAdding = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.chips.isNotEmpty) ...[
          Wrap(
            spacing: AppDimensions.spacingSmall,
            runSpacing: AppDimensions.spacingSmall,
            children: widget.chips
                .map((chip) => RemovableChip(
                      label: chip,
                      onRemove: () => widget.onRemove(chip),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
        ],
        if (_isAdding)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: widget.inputHint,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMedium,
                      vertical: AppDimensions.spacingSmall,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                  ),
                  onSubmitted: (_) => _addChip(),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              IconButton(
                onPressed: _addChip,
                icon: Icon(Icons.check, color: colorScheme.primary),
              ),
              IconButton(
                onPressed: () {
                  _controller.clear();
                  setState(() => _isAdding = false);
                },
                icon: Icon(Icons.close, color: colorScheme.error),
              ),
            ],
          )
        else
          TextButton.icon(
            onPressed: () => setState(() => _isAdding = true),
            icon: const Icon(Icons.add),
            label: Text(widget.addButtonLabel),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
            ),
          ),
      ],
    );
  }
}

