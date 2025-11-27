import 'package:acroworld/theme/app_dimensions.dart';
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
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1),
        ),
        padding: const EdgeInsets.all(AppDimensions.spacingSmall),
        margin: const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
        child: Row(
          children: [
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: IgnorePointer(
                child: Checkbox(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: value,
                  onChanged: (_) {},
                ),
              ),
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.onSurface,
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
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    maxLines: 2,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: AppDimensions.spacingSmall),
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
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
