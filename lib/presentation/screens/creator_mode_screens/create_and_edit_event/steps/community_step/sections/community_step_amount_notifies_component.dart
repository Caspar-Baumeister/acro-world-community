import 'package:acroworld/provider/riverpod_provider/event_teachers_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityStepAmountNotifiesComponent extends ConsumerWidget {
  const CommunityStepAmountNotifiesComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersState = ref.watch(eventTeachersProvider);
    return teachersState.amountOfFollowers > 0
        ? Container(
            // centrer and padding
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingSmall),
            child: Text(
                "About ${teachersState.amountOfFollowers} user will be notified",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          )
        : Container();
  }
}
