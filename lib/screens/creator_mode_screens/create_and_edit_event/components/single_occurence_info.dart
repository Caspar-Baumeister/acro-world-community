import 'package:acroworld/models/recurrent_pattern_model.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/datetime_helper.dart';
import 'package:flutter/material.dart';

class SingleOccurenceInfo extends StatelessWidget {
  const SingleOccurenceInfo(this.recurringPattern, {super.key});
  final RecurringPatternModel recurringPattern;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // start date and time
          "Start: ${formatDateTime(recurringPattern.startDate!)} ${formatTimeOfDay(recurringPattern.startTime)}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppPaddings.small),
        Text(
          "End: ${formatDateTime(recurringPattern.endDate!)} ${formatTimeOfDay(recurringPattern.endTime)}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
