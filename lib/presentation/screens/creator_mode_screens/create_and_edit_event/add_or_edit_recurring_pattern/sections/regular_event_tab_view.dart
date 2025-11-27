import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/custom_pick_date.dart';
import 'package:acroworld/utils/helper_functions/custom_time_picker.dart';
import 'package:acroworld/utils/helper_functions/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class RegularEventTabView extends StatelessWidget {
  const RegularEventTabView(
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
        horizontal: AppDimensions.spacingLarge,
      ).copyWith(top: AppDimensions.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
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
              const SizedBox(width: AppDimensions.spacingMedium),
              Flexible(
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
          // const Padding(
          //   padding: EdgeInsets.symmetric(
          //     vertical: AppDimensions.spacingMedium,
          //   ),
          //   child: CustomDivider(),
          // ),
          const SizedBox(height: AppDimensions.spacingMedium),
          FloatingButton(
            headerText: "Weekday",
            insideText: recurringPattern.dayOfWeek != null
                ? getDayOfWeek(recurringPattern.dayOfWeek!)
                : "Pick weekday",
            onPressed: () => showWeekdayPicker(
              context: context,
              onDaySelected: (p0) => editRecurringPattern("dayOfWeek", p0 + 1),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          Column(
            children: [
              Text(
                "Repeat every ${recurringPattern.recurringEveryXWeeks == 1 ? "week" : ("${recurringPattern.recurringEveryXWeeks} weeks")}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDimensions.spacingMedium),
              Center(
                child: NumberPicker(
                  value: recurringPattern.recurringEveryXWeeks,
                  minValue: 1,
                  maxValue: 4,
                  step: 1,
                  haptics: true,
                  axis: Axis.horizontal,
                  itemHeight: 50, // Adjust as needed
                  itemWidth: 100, // Adjust as needed
                  textStyle:
                      Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                  selectedTextStyle:
                      Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  onChanged: (value) =>
                      editRecurringPattern("repeatEvery", value),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMedium),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: FloatingButton(
                      headerText: "Start of pattern?",
                      insideText: recurringPattern.startDate != null
                          ? formatDateTime(recurringPattern.startDate!)
                          : "Pick date",
                      onPressed: () => showDatePickerDialog(
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          initialDate:
                              recurringPattern.startDate ?? DateTime.now(),
                          context: context,
                          setDate: (date) {
                            editRecurringPattern("startDate", date);
                          }),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMedium),
                  Flexible(
                    child: Column(
                      children: [
                        FloatingButton(
                          insideText: recurringPattern.endDate != null
                              ? formatDateTime(recurringPattern.endDate!)
                              : "",
                          headerText: "End of pattern?",
                          onPressed: () => showDatePickerDialog(
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              initialDate:
                                  recurringPattern.endDate ?? DateTime.now(),
                              context: context,
                              setDate: (date) {
                                editRecurringPattern("endDate", date);
                              }),
                        ),
                        const SizedBox(height: AppDimensions.spacingMedium),
                        Text(
                          "You can leave the end date empty and change it later",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
