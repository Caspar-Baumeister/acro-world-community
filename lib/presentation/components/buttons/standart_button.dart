import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class StandartButton extends StatelessWidget {
  const StandartButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.buttonFillColor,
    this.width,
    this.disabled = false,
    this.loading = false,
    this.isFilled = false,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? buttonFillColor;
  final double? width;
  final bool disabled;
  final bool loading;
  final bool isFilled;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color effectiveBackgroundColor = isFilled
        ? buttonFillColor ?? colorScheme.primary
        : colorScheme.surface;
    final Color effectiveBorderColor = buttonFillColor ?? colorScheme.primary;
    final Color effectiveTextColor = isFilled
        ? colorScheme.onPrimary
        : buttonFillColor ?? colorScheme.primary;

    final ButtonStyle buttonStyle = isFilled
        ? ElevatedButton.styleFrom(
            backgroundColor: effectiveBackgroundColor,
            foregroundColor: effectiveTextColor,
            minimumSize: width != null ? Size(width!, AppDimensions.buttonHeight) : null,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          )
        : OutlinedButton.styleFrom(
            backgroundColor: effectiveBackgroundColor,
            foregroundColor: effectiveTextColor,
            minimumSize: width != null ? Size(width!, AppDimensions.buttonHeight) : null,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            side: BorderSide(color: effectiveBorderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          );

    final Widget buttonContent = loading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: effectiveTextColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: effectiveTextColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: AppDimensions.buttonHeight,
      child: isFilled
          ? ElevatedButton(
              onPressed: disabled || loading ? null : onPressed,
              style: buttonStyle,
              child: buttonContent,
            )
          : OutlinedButton(
              onPressed: disabled || loading ? null : onPressed,
              style: buttonStyle,
              child: buttonContent,
            ),
    );
  }
}

