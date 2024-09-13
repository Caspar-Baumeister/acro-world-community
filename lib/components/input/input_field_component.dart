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
  final int? maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final bool? autoFocus;
  final bool? isFootnoteError;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final void Function()? onEditingComplete;
  final Widget? leadingIcon;
  final Color? fillColor;

  const InputFieldComponent(
      {super.key,
      this.leadingIcon,
      this.footnoteText,
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction,
      this.autofillHints,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.labelText,
      this.maxLines,
      this.minLines,
      this.validator,
      this.autoFocus,
      this.suffixIcon,
      this.isFootnoteError = true,
      required this.controller,
      this.floatingLabelBehavior,
      this.fillColor})
      : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onEditingComplete: onEditingComplete,
          controller: controller,
          obscureText: obscureText,
          autofocus: autoFocus ?? false,
          autofillHints: autofillHints,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          minLines: minLines,
          textInputAction: textInputAction,
          validator: validator,
          cursorColor: CustomColors.primaryTextColor,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            fillColor: fillColor,
            focusColor: fillColor,
            suffixIcon: suffixIcon,
            prefixIcon: leadingIcon,
            labelText: labelText,
            labelStyle: const TextStyle(color: CustomColors.primaryTextColor),
            alignLabelWithHint: true,
            floatingLabelBehavior: floatingLabelBehavior,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppPaddings.medium)
                    .copyWith(bottom: AppPaddings.medium),
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
        ),
        footnoteText != null
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 8.0, left: 10),
                child: Text(footnoteText!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isFootnoteError == true
                              ? CustomColors.errorTextColor
                              : CustomColors.primaryTextColor,
                        )),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}
