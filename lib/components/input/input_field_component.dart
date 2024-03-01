import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class InputFieldComponent extends StatelessWidget {
  final String? footnoteText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<String>? autofillHints;
  final String? labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onFieldSubmitted;
  final Widget? suffixIcon;
  final bool? autoFocus;

  const InputFieldComponent(
      {super.key,
      this.footnoteText,
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction,
      this.autofillHints,
      this.onFieldSubmitted,
      this.labelText,
      this.validator,
      this.autoFocus,
      this.suffixIcon,
      required this.controller})
      : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autofocus: autoFocus ?? false,
          autofillHints: autofillHints,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          cursorColor: CustomColors.primaryTextColor,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            labelText: labelText,
            labelStyle: const TextStyle(color: CustomColors.primaryTextColor),
            alignLabelWithHint: true,
            // floatingLabelBehavior: FloatingLabelBehavior,
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: CustomColors.errorBorderColor, width: 1.0),
              borderRadius: AppBorders.defaultRadius,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: CustomColors.errorBorderColor, width: 1.0),
              borderRadius: AppBorders.defaultRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: CustomColors.activeBorderColor, width: 1.0),
              borderRadius: AppBorders.defaultRadius,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1.0, color: CustomColors.inactiveBorderColor),
              borderRadius: AppBorders.defaultRadius,
            ),
            contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
        ),
        footnoteText != null
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 8.0, left: 10),
                child: Text(footnoteText!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: CustomColors.errorTextColor,
                        )),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}
