import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/core/utils/constants.dart';
import 'package:flutter/material.dart';

class PrimaryBottomNavbarItem extends StatelessWidget {
  const PrimaryBottomNavbarItem(
      {super.key,
      this.icon,
      required this.label,
      required this.onPressed,
      required this.isSelected,
      this.imageIcon});

  final IconData? icon;
  final AssetImage? imageIcon;
  final String label;
  final Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppPaddings.small, vertical: AppPaddings.tiny),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            imageIcon != null
                ? Image(
                    image: imageIcon!,
                    color: isSelected
                        ? CustomColors.primaryColor
                        : CustomColors.inactiveBorderColor,
                    width: AppDimensions.iconSizeMedium,
                    height: AppDimensions.iconSizeMedium,
                  )
                : icon != null
                    ? Icon(
                        icon,
                        color: isSelected
                            ? CustomColors.primaryColor
                            : CustomColors.inactiveBorderColor,
                        size: AppDimensions.iconSizeMedium,
                      )
                    : Container(),
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
