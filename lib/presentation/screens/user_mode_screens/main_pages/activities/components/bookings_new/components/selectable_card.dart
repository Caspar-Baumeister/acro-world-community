import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.value,
    required this.text,
    required this.onPressed,
    this.subtitle,
    this.trailingText,
  });

  final bool value;
  final String text;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppBorders.defaultRadius,
          border: Border.all(
            color: value
                ? CustomColors.accentColor
                : CustomColors.primaryTextColor,
            width: value ? 1.5 : 1,
          ),
          color: value ? CustomColors.accentColor.withOpacity(0.1) : null,
        ),
        padding: const EdgeInsets.all(AppPaddings.small),
        margin: const EdgeInsets.only(bottom: AppPaddings.medium),
        child: Row(
          children: [
            Icon(
              value ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: value
                  ? CustomColors.accentColor
                  : CustomColors.lightTextColor,
              size: 24.0,
            ),
            const SizedBox(width: AppPaddings.small),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryColor,
                        ),
                    maxLines: 2,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppPaddings.small),
                      child: Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: CustomColors.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
