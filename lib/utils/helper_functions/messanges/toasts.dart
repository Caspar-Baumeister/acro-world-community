// lib/utils/helper_functions/messanges/toasts.dart

import 'package:acroworld/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:acroworld/routing/custom_go_router.dart'; // Import the rootNavigatorKey

// Fallback colors if no context is available
const Color _defaultSuccessBg = Colors.green;
const Color _defaultErrorBg = Colors.red;
const Color _defaultInfoBg = Colors.blueGrey;
const Color _defaultTextColor = Colors.white;

void showSuccessToast(String message, {bool isTop = true, BuildContext? context}) {
  _showToast(
    message,
    isTop: isTop,
    backgroundColor: (context != null ? Theme.of(context).colorScheme.primary : _defaultSuccessBg),
    textColor: (context != null ? Theme.of(context).colorScheme.onPrimary : _defaultTextColor),
    context: context,
  );
}

void showErrorToast(String message, {BuildContext? context}) {
  _showToast(
    message,
    backgroundColor: (context != null ? Theme.of(context).colorScheme.error : _defaultErrorBg),
    textColor: (context != null ? Theme.of(context).colorScheme.onPrimary : _defaultTextColor),
    context: context,
  );
}

void showInfoToast(String message, {BuildContext? context}) {
  _showToast(
    message,
    backgroundColor: (context != null ? Theme.of(context).colorScheme.surfaceContainer : _defaultInfoBg),
    textColor: (context != null ? Theme.of(context).colorScheme.onPrimary : _defaultTextColor),
    context: context,
  );
}

// Private helper to avoid code duplication
void _showToast(
  String message, {
  bool isTop = true,
  required Color backgroundColor,
  required Color textColor,
  BuildContext? context, // Optional context from the caller
}) {
  // Try to get context from GlobalKey if not provided by caller
  final effectiveContext = context ?? rootNavigatorKey.currentContext;

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: isTop ? ToastGravity.TOP : ToastGravity.BOTTOM,
    timeInSecForIosWeb: AppConstants.inAppMessageTime,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: effectiveContext != null ? Theme.of(effectiveContext).textTheme.bodyLarge?.fontSize : 16.0, // Fallback font size
  );
}