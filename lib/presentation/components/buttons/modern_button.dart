import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Button size enum following the Style Guide
enum ButtonSize {
  small, // 36px height
  medium, // 48px height (standard)
  large, // 56px height
}

/// Modern button component with consistent styling following Style Guide
///
/// Usage:
/// ```dart
/// ModernButton(
///   text: 'Submit',
///   onPressed: () {},
/// )
///
/// ModernButton(
///   text: 'Cancel',
///   isOutlined: true,
///   isFilled: false,
///   onPressed: () {},
/// )
/// ```
class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFilled;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final ButtonSize size;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFilled = true,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine size-based values following Style Guide
    final double buttonHeight;
    final double iconSize;
    final TextStyle? textStyle;
    final EdgeInsetsGeometry defaultPadding;

    switch (size) {
      case ButtonSize.small:
        buttonHeight = AppDimensions.buttonHeightSmall;
        iconSize = AppDimensions.iconSizeTiny;
        textStyle = theme.textTheme.labelMedium;
        defaultPadding = const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
          vertical: AppDimensions.spacingSmall,
        );
        break;
      case ButtonSize.medium:
        buttonHeight = AppDimensions.buttonHeight;
        iconSize = 18;
        textStyle = theme.textTheme.labelLarge;
        defaultPadding = const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLarge,
          vertical: AppDimensions.spacingMedium,
        );
        break;
      case ButtonSize.large:
        buttonHeight = AppDimensions.buttonHeightLarge;
        iconSize = 20;
        textStyle = theme.textTheme.titleMedium;
        defaultPadding = const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingExtraLarge,
          vertical: AppDimensions.spacingMedium,
        );
        break;
    }

    // Determine colors based on button type
    Color bgColor;
    Color fgColor;
    Color borderColor;

    if (isOutlined) {
      bgColor = Colors.transparent;
      fgColor = backgroundColor ?? colorScheme.primary;
      borderColor = backgroundColor ?? colorScheme.primary;
    } else if (isFilled) {
      bgColor = backgroundColor ?? colorScheme.primary;
      fgColor = textColor ??
          (backgroundColor != null
              ? colorScheme.onPrimary
              : colorScheme.onPrimary);
      borderColor = backgroundColor ?? colorScheme.primary;
    } else {
      bgColor = Colors.transparent;
      fgColor = textColor ?? colorScheme.primary;
      borderColor = Colors.transparent;
    }

    return SizedBox(
      width: width,
      height: height ?? buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0, // Modern flat design
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ??
                BorderRadius.circular(AppDimensions.radiusLarge),
            side: BorderSide(
              color: borderColor,
              width: isOutlined ? 1.5 : 0,
            ),
          ),
          padding: padding ?? defaultPadding,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSize),
                    const SizedBox(width: AppDimensions.spacingSmall),
                  ],
                  Text(
                    text,
                    style: textStyle?.copyWith(
                      color: fgColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Modern icon button component
class ModernIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const ModernIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor ?? colorScheme.onSurface,
          size: size * 0.5,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Modern floating action button
class ModernFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;

  const ModernFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: iconColor ?? colorScheme.onPrimary,
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusExtraLarge),
      ),
      child: Icon(icon),
    );
  }
}
