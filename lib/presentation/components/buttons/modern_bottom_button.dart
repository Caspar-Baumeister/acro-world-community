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
          // Remove shadow for cleaner look like example
        ),
        child: Center(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBackgroundColor(colorScheme),
              foregroundColor: _getForegroundColor(colorScheme),
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Better padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Clean, modern radius
                side: BorderSide.none, // No border for cleaner look
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
                : Text(
                    text,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: _getForegroundColor(colorScheme),
                      fontWeight: FontWeight.w600, // Bold like example
                      letterSpacing: 0.2, // Tighter spacing for modern look
                      fontSize: 16, // Consistent size
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ModernBottomButtonVariant.primary:
        return const Color(0xFF1A1A1A); // Dark modern background like example
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
        return Colors.white; // White text on dark background
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
