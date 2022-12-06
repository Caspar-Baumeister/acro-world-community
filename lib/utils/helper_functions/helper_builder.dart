import 'package:flutter/material.dart';

// decoration property of text fields
InputDecoration buildInputDecoration({
  String? labelText,
  Widget? suffixIcon,
  double roundness = 10.0,
  bool error = false,
}) {
  return InputDecoration(
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white,
      filled: true,
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFad3b3b), width: 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFad3b3b), width: 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!, width: 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      alignLabelWithHint: true,
      labelText: labelText ?? "",
      labelStyle: const TextStyle(color: Color(0xFFA4A4A4)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      suffixIcon: suffixIcon);
}
