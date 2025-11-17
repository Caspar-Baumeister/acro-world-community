import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class FloatingModeSwitchButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final bool isCreatorMode;
  final bool isGradient;

  const FloatingModeSwitchButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.isCreatorMode = false,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      bottom: 8, // Position just above the bottom navigation bar
      left: 16,
      right: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMedium,
              vertical: AppDimensions.spacingSmall,
            ),
            decoration: BoxDecoration(
              gradient: isGradient
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withOpacity(0.15),
                        colorScheme.surface,
                      ],
                    )
                  : null,
              color: isGradient
                  ? null
                  : (isCreatorMode
                      ? colorScheme.primary
                      : colorScheme.secondary),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isGradient
                              ? colorScheme.onSurface
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isGradient
                              ? colorScheme.onSurface.withOpacity(0.7)
                              : Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: isGradient
                      ? colorScheme.onSurface.withOpacity(0.7)
                      : Colors.white.withOpacity(0.8),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

