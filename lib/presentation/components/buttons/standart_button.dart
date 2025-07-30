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
    final backgroundColor = isFilled
        ? buttonFillColor ?? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface;
    final borderColor = buttonFillColor ?? Theme.of(context).colorScheme.primary;
    final textColor = isFilled
        ? Theme.of(context).colorScheme.onPrimary
        : buttonFillColor ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled || loading ? null : onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: loading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor,
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
                              .copyWith(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
