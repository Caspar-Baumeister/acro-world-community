import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/core/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;
  final EdgeInsets padding;
  final bool disabled;
  final bool loading;
  final bool isWithAuth;

  const CustomButton(this.text, this.onPressed,
      {super.key,
      this.width = STANDART_BUTTON_WIDTH,
      this.height = 48.0,
      this.fontSize = 14.0,
      this.padding = const EdgeInsets.all(18.0),
      this.disabled = false,
      this.loading = false,
      this.isWithAuth = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled || loading
          ? null
          // if authentication is not neccesary, return onPressed
          : onPressed
      // if user is not authenticated, return pop up
      ,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.primaryColor),
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: width,
          height: height,
          child: Center(
            child: loading
                ? Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.all(5),
                    child: const CircularProgressIndicator())
                : Text(
                    text,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
          )),
    );
  }
}
