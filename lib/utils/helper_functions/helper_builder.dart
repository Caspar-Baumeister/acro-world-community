import 'package:flutter/material.dart';

// decoration property of text fields
InputDecoration buildInputDecoration({
  String? labelText,
  Widget? suffixIcon,
  double roundness = 10.0,
  bool error = false,
}) {
  return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      fillColor: Colors.white,
      filled: true,
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFad3b3b), width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFad3b3b), width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      alignLabelWithHint: true,
      hintText: labelText ?? "",
      suffixIcon: suffixIcon);
}
