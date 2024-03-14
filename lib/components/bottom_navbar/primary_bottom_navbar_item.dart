import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class PrimaryBottomNavbarItem extends StatelessWidget {
  const PrimaryBottomNavbarItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed,
      required this.isSelected});

  final IconData icon;
  final String label;
  final Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPaddings.small),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? CustomColors.primaryColor
                  : CustomColors.inactiveBorderColor,
              size: AppDimensions.iconSizeMedium,
            ),
            const SizedBox(height: AppPaddings.small),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isSelected
                        ? CustomColors.primaryColor
                        : CustomColors.inactiveBorderColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
