// show success toast
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSuccessToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: AppConstants.inAppMessageTime,
      backgroundColor: CustomColors.successBgColor,
      textColor: CustomColors.whiteTextColor,
      fontSize: const TextTheme().bodyLarge?.fontSize);
}

// show error toast
void showErrorToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: AppConstants.inAppMessageTime,
      backgroundColor: CustomColors.errorTextColor,
      textColor: CustomColors.whiteTextColor,
      fontSize: const TextTheme().bodyLarge?.fontSize);
}

void showInfoToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: AppConstants.inAppMessageTime,
      backgroundColor: CustomColors.infoBgColor,
      textColor: CustomColors.whiteTextColor,
      fontSize: const TextTheme().bodyLarge?.fontSize);
}
