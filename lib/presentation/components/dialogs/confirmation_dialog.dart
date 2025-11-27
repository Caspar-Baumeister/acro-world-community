import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Reusable confirmation dialog component
/// Returns true if confirmed, false if cancelled, null if dismissed
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.icon,
    this.iconColor,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData? icon;
  final Color? iconColor;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppDimensions.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingMedium),
                decoration: BoxDecoration(
                  color: (iconColor ??
                          (isDestructive
                              ? colorScheme.error
                              : colorScheme.primary))
                      .withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Icon(
                  icon,
                  color: iconColor ??
                      (isDestructive ? colorScheme.error : colorScheme.primary),
                  size: 40,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLarge),
            ],

            // Title
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSmall),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLarge),

            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: ModernButton(
                    text: cancelText,
                    onPressed: () => Navigator.of(context).pop(false),
                    isFilled: false,
                    isOutlined: true,
                    size: ButtonSize.small,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMedium),

                // Confirm button
                Expanded(
                  child: ModernButton(
                    text: confirmText,
                    onPressed: () => Navigator.of(context).pop(true),
                    isFilled: !isDestructive,
                    isOutlined: isDestructive,
                    backgroundColor:
                        isDestructive ? colorScheme.error : colorScheme.primary,
                    textColor: isDestructive
                        ? colorScheme.error
                        : colorScheme.onPrimary,
                    size: ButtonSize.small,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog and return the result
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? iconColor,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        iconColor: iconColor,
        isDestructive: isDestructive,
      ),
    );
  }
}
