import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton(
      {super.key,
      this.insideText,
      required this.onPressed,
      this.icon,
      this.headerText,
      this.insideWidget});

  final String? insideText;
  final Widget? insideWidget;
  final String? headerText;
  final VoidCallback onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headerText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppPaddings.small),
            child: Text(
              headerText!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(AppPaddings.medium),
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
              borderRadius: AppBorders.smallRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: insideWidget != null
                ? insideWidget!
                : Row(
                    children: [
                      if (icon != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(right: AppPaddings.small),
                          child: icon!,
                        ),
                      Flexible(
                        child: Text(
                          insideText ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
