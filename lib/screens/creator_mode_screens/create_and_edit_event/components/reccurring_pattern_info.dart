import 'package:acroworld/models/recurrent_pattern_model.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/datetime_helper.dart';
import 'package:flutter/material.dart';

class ReccurringPatternInfo extends StatelessWidget {
  const ReccurringPatternInfo(this.recurringPattern, {super.key});
  final RecurringPatternModel recurringPattern;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Repeats every ${recurringPattern.recurringEveryXWeeks == 1 ? "" : "${recurringPattern.recurringEveryXWeeks} "}weeks on ${getDayOfWeek(recurringPattern.dayOfWeek ?? 0)}'s",
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppPaddings.small),
        Text(
          "From: ${formatTimeOfDay(recurringPattern.startTime)} to ${formatTimeOfDay(recurringPattern.endTime)}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppPaddings.medium),
        Text(
          "First occurence: ${formatDateTime(recurringPattern.startDate!)}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppPaddings.small),
        Text(
          "Repeats until: ${recurringPattern.endDate != null ? formatDateTime(recurringPattern.endDate!) : "forever"}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
