import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/core/utils/constants.dart';
import 'package:flutter/material.dart';

class StandardButtonSmall extends StatelessWidget {
  const StandardButtonSmall(
      {super.key,
      required this.text,
      required this.onPressed,
      this.icon,
      this.buttonFillColor = CustomColors.primaryColor,
      this.disabled = false,
      this.loading = false,
      this.isFilled = false});

  final String text;
  final VoidCallback onPressed;
  final Color buttonFillColor;
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
            borderRadius: BorderRadius.circular(STANDART_ROUNDNESS_STRONG),
          ),
          child: Center(
            child: loading
                ? Container(
                    height: 25,
                    width: 25,
                    padding: const EdgeInsets.all(5),
                    child: CircularProgressIndicator(
                      color:
                          isFilled ? Colors.white : CustomColors.primaryColor,
                    ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon ?? Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
