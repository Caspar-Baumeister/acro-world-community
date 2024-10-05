import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class CommunityStepHeader extends StatelessWidget {
  const CommunityStepHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
      child: Text(
          "Invite teachers to your event. The more teachers you invite, the more user will see your event.\n\nKeep in mind, that teachers have to accept your invitation.",
          style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
