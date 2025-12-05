import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class CommunityStepHeader extends StatelessWidget {
  const CommunityStepHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(
                alpha: 0.3,
              ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            child: Text(
              "Invite teachers who teach at your event to reach their audience and make your event more attractive. Each teacher brings their followers and community to your event.\n\nTeachers will need to accept your invitation to be featured.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
