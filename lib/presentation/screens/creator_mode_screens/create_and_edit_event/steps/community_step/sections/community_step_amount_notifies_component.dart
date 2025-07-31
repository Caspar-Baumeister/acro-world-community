import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class CommunityStepAmountNotifiesComponent extends StatelessWidget {
  const CommunityStepAmountNotifiesComponent({
    super.key,
    required this.eventCreationAndEditingProvider,
  });

  final EventCreationAndEditingProvider eventCreationAndEditingProvider;

  @override
  Widget build(BuildContext context) {
    return eventCreationAndEditingProvider.amountOfFollowers > 0
        ? Container(
            // centrer and padding
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
            child: Text(
                "About ${eventCreationAndEditingProvider.amountOfFollowers} user will be notified",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          )
        : Container();
  }
}
