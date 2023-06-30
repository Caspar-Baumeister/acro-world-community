import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class StandartButton extends StatelessWidget {
  const StandartButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.width = STANDART_BUTTON_WIDTH,
      this.disabled = false,
      this.loading = false,
      this.isFilled = false})
      : super(key: key);

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
            borderRadius: BorderRadius.circular(STANDART_ROUNDNESS_STRONG),
          ),
          width: width,
          child: Center(
            child: loading
                ? Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.all(5),
                    child: CircularProgressIndicator(
                      color: isFilled == true ? Colors.white : PRIMARY_COLOR,
                    ))
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      text,
                      style: STANDART_BUTTON_TEXT.copyWith(
                        color: !isFilled ? BUTTON_FILL_COLOR : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          )),
    );
  }
}
