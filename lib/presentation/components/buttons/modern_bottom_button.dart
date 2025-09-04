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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.9),
            Colors.white,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
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
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ModernBottomButtonVariant.primary:
        return const Color(0xFF000000); // Pure black for maximum contrast
      case ModernBottomButtonVariant.success:
        return const Color(0xFF4CAF50); // Stronger green for better contrast
      case ModernBottomButtonVariant.warning:
        return const Color(0xFFFF9800); // Stronger orange for better contrast
      case ModernBottomButtonVariant.error:
        return const Color(0xFFF44336); // Stronger red for better contrast
      case ModernBottomButtonVariant.secondary:
        return const Color(0xFFE0E0E0); // Light gray
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ModernBottomButtonVariant.primary:
        return Colors.white; // White text on dark background for maximum contrast
      case ModernBottomButtonVariant.success:
        return Colors.white; // White text on green background
      case ModernBottomButtonVariant.warning:
        return Colors.white; // White text on amber background for better contrast
      case ModernBottomButtonVariant.error:
        return Colors.white; // White text on red background for better contrast
      case ModernBottomButtonVariant.secondary:
        return const Color(0xFF333333); // Dark gray for light background
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
