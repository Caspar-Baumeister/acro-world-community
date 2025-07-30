import 'package:acroworld/theme/app_dimensions.dart';
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
            horizontal: AppDimensions.spacingSmall, vertical: AppDimensions.spacingExtraSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            imageIcon != null
                ? Image(
                    image: imageIcon!,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: AppDimensions.iconSizeMedium,
                    height: AppDimensions.iconSizeMedium,
                  )
                : icon != null
                    ? Icon(
                        icon,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        size: AppDimensions.iconSizeMedium,
                      )
                    : Container(),
            const SizedBox(height: AppDimensions.spacingSmall),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
