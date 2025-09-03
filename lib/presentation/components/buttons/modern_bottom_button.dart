import 'package:flutter/material.dart';

class ModernBottomButton extends StatelessWidget {
  const ModernBottomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = ModernBottomButtonVariant.primary,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ModernBottomButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBackgroundColor(colorScheme),
              foregroundColor: _getForegroundColor(colorScheme),
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getForegroundColor(colorScheme),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: _getForegroundColor(colorScheme),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ModernBottomButtonVariant.primary:
        return colorScheme.primary;
      case ModernBottomButtonVariant.success:
        return const Color(0xFF10B981); // Green
      case ModernBottomButtonVariant.warning:
        return const Color(0xFFF59E0B); // Amber
      case ModernBottomButtonVariant.error:
        return const Color(0xFFEF4444); // Red
      case ModernBottomButtonVariant.secondary:
        return colorScheme.surfaceContainerHighest;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ModernBottomButtonVariant.primary:
      case ModernBottomButtonVariant.success:
      case ModernBottomButtonVariant.warning:
      case ModernBottomButtonVariant.error:
        return Colors.white;
      case ModernBottomButtonVariant.secondary:
        return colorScheme.onSurface;
    }
  }
}

enum ModernBottomButtonVariant {
  primary,
  secondary,
  success,
  warning,
  error,
}
