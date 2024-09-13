import 'package:acroworld/components/buttons/floating_button.dart';
import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/models/recurrent_pattern_model.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/screens/creator_mode_screens/add_or_edit_recurring_pattern/add_or_edit_recurring_pattern.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OccurrenceStep extends StatefulWidget {
  const OccurrenceStep({super.key, required this.onFinished});
  final Function onFinished;

  @override
  State<OccurrenceStep> createState() => _OccurrenceStepState();
}

class _OccurrenceStepState extends State<OccurrenceStep> {
  late TextEditingController teacherQueryController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    teacherQueryController = TextEditingController();
    teacherQueryController.addListener(() {});
  }

  @override
  void dispose() {
    teacherQueryController.dispose();
    super.dispose();
  }

  void _onNext() {
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);
    return Column(
      children: [
        StandardButton(
            text: 'Add Occurences',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddOrEditRecurringPatternPage(
                    onFinished: (RecurringPatternModel recurringPattern) {
                      eventCreationAndEditingProvider.addRecurringPattern(
                        recurringPattern,
                      );
                    },
                  ),
                ),
              );
            }),
        const SizedBox(height: AppPaddings.medium),
        Flexible(
          child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount:
                  eventCreationAndEditingProvider.recurringPatterns.length,
              itemBuilder: (context, index) {
                RecurringPatternModel pattern =
                    eventCreationAndEditingProvider.recurringPatterns[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddings.large,
                  ),
                  child: FloatingButton(
                      insideText: "",
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddOrEditRecurringPatternPage(
                              onFinished:
                                  (RecurringPatternModel recurringPattern) {
                                eventCreationAndEditingProvider
                                    .editRecurringPattern(
                                  index,
                                  recurringPattern,
                                );
                              },
                              recurringPattern: pattern,
                            ),
                          ),
                        );
                      },
                      headerText: "",
                      insideWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  pattern.isRecurring == true
                                      ? "Recurring pattern"
                                      : "Single occurence",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.primaryColor)),
                              IconButton(
                                  onPressed: () {
                                    eventCreationAndEditingProvider
                                        .removeRecurringPattern(index);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: CustomColors.errorTextColor,
                                  ))
                            ],
                          ),
                          const SizedBox(height: AppPaddings.small),
                          pattern.isRecurring == true
                              ? ReccurringPatternInfo(pattern)
                              : SingleOccurenceInfo(pattern),
                          const SizedBox(height: AppPaddings.small),
                        ],
                      )),
                );
              }),
        ),
        const SizedBox(height: AppPaddings.medium),
        StandardButton(onPressed: _onNext, text: 'Next'),
        const SizedBox(height: AppPaddings.small),
        _errorMessage != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddings.medium,
                ),
                child: Text(
                  _errorMessage!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: CustomColors.errorTextColor),
                ),
              )
            : const SizedBox(height: AppPaddings.medium),
      ],
    );
  }
}

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
