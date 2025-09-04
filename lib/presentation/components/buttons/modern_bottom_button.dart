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
                borderRadius: BorderRadius.circular(20), // More rounded for modern look
                side: BorderSide(
                  color: _getBackgroundColor(colorScheme).withOpacity(0.2),
                  width: 1,
                ),
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
                          fontWeight: FontWeight.w500, // Slightly lighter weight
                          letterSpacing: 0.5, // Better letter spacing
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
        return const Color(0xFF6B8E6B); // Muted sage green (from our theme)
      case ModernBottomButtonVariant.success:
        return const Color(0xFF7FB069); // Soft pastel green
      case ModernBottomButtonVariant.warning:
        return const Color(0xFFD4A574); // Warm pastel amber
      case ModernBottomButtonVariant.error:
        return const Color(0xFFE8A598); // Soft pastel red
      case ModernBottomButtonVariant.secondary:
        return const Color(0xFFF5F5F5); // Light gray
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ModernBottomButtonVariant.primary:
      case ModernBottomButtonVariant.success:
        return Colors.white;
      case ModernBottomButtonVariant.warning:
        return const Color(0xFF8B4513); // Dark brown for warm amber
      case ModernBottomButtonVariant.error:
        return const Color(0xFF8B0000); // Dark red for soft red background
      case ModernBottomButtonVariant.secondary:
        return const Color(0xFF666666); // Medium gray for light background
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
