import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class StandartButton extends StatelessWidget {
  const StandartButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.buttonFillColor = CustomColors.primaryColor,
    this.width = STANDART_BUTTON_WIDTH,
    this.disabled = false,
    this.loading = false,
    this.isFilled = false,
  });

  final String text;
  final VoidCallback onPressed;
  final Color buttonFillColor;
  final double? width;
  final bool disabled;
  final bool loading;
  final bool isFilled;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isFilled ? buttonFillColor : Colors.white;
    final borderColor = buttonFillColor;
    final textColor = isFilled ? Colors.white : buttonFillColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled || loading ? null : onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(STANDART_ROUNDNESS_STRONG),
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
                              .headlineSmall!
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
