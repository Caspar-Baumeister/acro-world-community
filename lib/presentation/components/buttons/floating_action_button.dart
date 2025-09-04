import 'package:flutter/material.dart';

/// A clean, modern floating action button that hovers over content
/// Used for primary actions like booking, calendar, etc.
class ModernFloatingButton extends StatelessWidget {
  const ModernFloatingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ModernFloatingButtonVariant.primary,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final ModernFloatingButtonVariant variant;
  final bool isLoading;

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
              backgroundColor: _getBackgroundColor(),
              foregroundColor: _getForegroundColor(),
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide.none,
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getForegroundColor(),
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: _getForegroundColor(),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case ModernFloatingButtonVariant.primary:
        return const Color(0xFF000000); // Pure black
      case ModernFloatingButtonVariant.success:
        return const Color(0xFF4CAF50); // Green
      case ModernFloatingButtonVariant.warning:
        return const Color(0xFFFF9800); // Orange
      case ModernFloatingButtonVariant.error:
        return const Color(0xFFF44336); // Red
      case ModernFloatingButtonVariant.secondary:
        return const Color(0xFFE0E0E0); // Light gray
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case ModernFloatingButtonVariant.primary:
      case ModernFloatingButtonVariant.success:
      case ModernFloatingButtonVariant.warning:
      case ModernFloatingButtonVariant.error:
        return Colors.white;
      case ModernFloatingButtonVariant.secondary:
        return const Color(0xFF333333); // Dark gray
    }
  }
}

enum ModernFloatingButtonVariant {
  primary,
  success,
  warning,
  error,
  secondary,
}
