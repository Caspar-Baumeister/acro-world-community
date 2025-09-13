import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class CommunityStepHeader extends StatelessWidget {
  const CommunityStepHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Text(
          "Invite teachers who teach at your event to reach their audience and make your event more attractive. Each teacher brings their followers and community to your event.\n\nTeachers will need to accept your invitation to be featured.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          )),
    );
  }
}
