import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/custom_pick_date.dart';
import 'package:acroworld/utils/helper_functions/custom_time_picker.dart';
import 'package:acroworld/utils/helper_functions/datetime_helper.dart';
import 'package:flutter/material.dart';

class SingleOccurenceTabView extends StatelessWidget {
  const SingleOccurenceTabView(
      {super.key,
      required this.recurringPattern,
      required this.editRecurringPattern});

  final RecurringPatternModel recurringPattern;
  final Function(
    String key,
    dynamic value,
  ) editRecurringPattern;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddings.large,
      ).copyWith(top: AppPaddings.large),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: FloatingButton(
                  headerText: "Start date",
                  insideText: recurringPattern.startDate != null
                      ? formatDateTime(recurringPattern.startDate!)
                      : "Pick date",
                  onPressed: () => showDatePickerDialog(
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      // if startDate is not null, set it to the later date of now and the startDate
                      initialDate: recurringPattern.startDate != null
                          // maximum of the two dates
                          ? DateTime.now().isAfter(recurringPattern.startDate!)
                              ? DateTime.now()
                              : recurringPattern.startDate!
                          : DateTime.now(),
                      context: context,
                      setDate: (date) {
                        editRecurringPattern("startDate", date);
                      }),
                ),
              ),
              const SizedBox(width: AppPaddings.medium),
              Flexible(
                flex: 1,
                child: FloatingButton(
                  insideText: formatTimeOfDay(recurringPattern.startTime),
                  headerText: "Start time",
                  onPressed: () => showCustomTimePicker(
                    context: context,
                    initialTime: recurringPattern.startTime,
                    setTime: (TimeOfDay time) {
                      editRecurringPattern("startTime", time);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppPaddings.medium),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: FloatingButton(
                  insideText: recurringPattern.endDate != null
                      ? formatDateTime(recurringPattern.endDate!)
                      : "Pick date",
                  headerText: "End date",
                  onPressed: () => showDatePickerDialog(
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: recurringPattern.endDate != null
                          // maximum of the two dates
                          ? DateTime.now().isAfter(recurringPattern.endDate!)
                              ? DateTime.now()
                              : recurringPattern.endDate!
                          : DateTime.now(),
                      context: context,
                      setDate: (date) {
                        editRecurringPattern("endDate", date);
                      }),
                ),
              ),
              const SizedBox(width: AppPaddings.medium),
              Flexible(
                flex: 1,
                child: FloatingButton(
                  headerText: "End time",
                  insideText: formatTimeOfDay(recurringPattern.endTime),
                  onPressed: () => showCustomTimePicker(
                    context: context,
                    initialTime: recurringPattern.endTime,
                    setTime: (TimeOfDay time) {
                      editRecurringPattern("endTime", time);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
