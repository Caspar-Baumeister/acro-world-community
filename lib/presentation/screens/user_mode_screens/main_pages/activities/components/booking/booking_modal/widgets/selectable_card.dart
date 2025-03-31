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
          border: Border.all(color: CustomColors.primaryTextColor, width: 1),
        ),
        padding: const EdgeInsets.all(AppPaddings.small),
        margin: const EdgeInsets.only(bottom: AppPaddings.medium),
        child: Row(
          children: [
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: IgnorePointer(
                child: Checkbox(
                  activeColor: CustomColors.successTextColor,
                  value: value,
                  onChanged: (_) {},
                ),
              ),
            ),
            VerticalDivider(
              color: CustomColors.primaryTextColor,
              thickness: 1,
            ),
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
