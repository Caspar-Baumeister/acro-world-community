import 'package:flutter/material.dart';

/// Modern search bar component with consistent styling
class ModernSearchBar extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterPressed;
  final bool showFilterButton;
  final bool enabled;
  final TextEditingController? controller;

  const ModernSearchBar({
    super.key,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
    this.showFilterButton = true,
    this.enabled = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                enabled: enabled,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: hintText ?? 'Search...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          // Filter button
          if (showFilterButton) ...[
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onFilterPressed,
                icon: Icon(
                  Icons.tune,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Modern filter chip component
class ModernFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onSelected;
  final IconData? icon;

  const ModernFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected 
                    ? colorScheme.onPrimary 
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: onSelected != null ? (_) => onSelected!() : null,
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary,
        checkmarkColor: colorScheme.onPrimary,
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          color: isSelected 
              ? colorScheme.onPrimary 
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected 
                ? colorScheme.primary 
                : colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        elevation: isSelected ? 2 : 0,
        shadowColor: isSelected 
            ? colorScheme.primary.withOpacity(0.3) 
            : null,
      ),
    );
  }
}
