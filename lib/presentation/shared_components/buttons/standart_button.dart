import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/core/utils/constants.dart';
import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  const StandardButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.icon,
      this.buttonFillColor = CustomColors.primaryColor,
      this.width = STANDART_BUTTON_WIDTH,
      this.disabled = false,
      this.loading = false,
      this.isFilled = false});

  final String text;
  final VoidCallback onPressed;
  final Color buttonFillColor;
  final double width;
  final bool disabled;
  final bool loading;
  final bool isFilled;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled || loading
          ? null
          // if authentication is not neccesary, return onPressed

          : onPressed,
      child: Container(
          decoration: BoxDecoration(
            color: isFilled ? buttonFillColor : Colors.white,
            border: Border.all(color: buttonFillColor),
            borderRadius: BorderRadius.circular(STANDART_ROUNDNESS_STRONG),
          ),
          width: width,
          child: Center(
            child: loading
                ? Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      color:
                          isFilled ? Colors.white : CustomColors.primaryColor,
                    ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon ?? Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: !isFilled
                                    ? CustomColors.primaryColor
                                    : Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }
}
