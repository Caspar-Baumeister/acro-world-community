import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class StandartButton extends StatelessWidget {
  const StandartButton(
      {required this.text,
      required this.onPressed,
      this.width = 300,
      this.disabled = false,
      this.loading = false,
      this.isFilled = false});

  final String text;
  final VoidCallback onPressed;
  final double width;
  final bool disabled;
  final bool loading;
  final bool isFilled;

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
            color: isFilled ? BUTTON_FILL_COLOR : Colors.white,
            border: Border.all(color: BUTTON_FILL_COLOR),
            borderRadius: BorderRadius.circular(20),
          ),
          width: width,
          height: 40,
          child: Center(
            child: loading
                ? Container(
                    height: 40,
                    width: width,
                    padding: const EdgeInsets.all(5),
                    child: const CircularProgressIndicator())
                : Text(
                    text,
                    style: STANDART_BUTTON_TEXT.copyWith(
                      color: !isFilled ? BUTTON_FILL_COLOR : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
          )),
    );
  }
}
