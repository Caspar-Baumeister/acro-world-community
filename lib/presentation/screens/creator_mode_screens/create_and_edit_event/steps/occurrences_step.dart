import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/add_or_edit_recurring_pattern.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/reccurring_pattern_info.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/single_occurence_info.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_schedule_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OccurrenceStep extends ConsumerStatefulWidget {
  const OccurrenceStep({super.key, required this.onFinished});
  final Function onFinished;

  @override
  ConsumerState<OccurrenceStep> createState() => _OccurrenceStepState();
}

class _OccurrenceStepState extends ConsumerState<OccurrenceStep> {
  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(eventScheduleProvider);

    // Debug prints for recurring patterns
    print(
        '🔍 OCCURRENCES DEBUG - scheduleState.recurringPatterns.length: ${scheduleState.recurringPatterns.length}');
    print(
        '🔍 OCCURRENCES DEBUG - scheduleState.recurringPatterns: ${scheduleState.recurringPatterns}');

    return Container(
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Column(
        children: [
          ModernButton(
              text: 'Add Occurences',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddOrEditRecurringPatternPage(
                      onFinished: (RecurringPatternModel recurringPattern) {
                        ref
                            .read(eventScheduleProvider.notifier)
                            .addRecurringPattern(
                              recurringPattern,
                            );
                      },
                    ),
                  ),
                );
              }),
          const SizedBox(height: AppDimensions.spacingMedium),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: scheduleState.recurringPatterns.length,
                itemBuilder: (context, index) {
                  RecurringPatternModel pattern =
                      scheduleState.recurringPatterns[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingLarge,
                    ),
                    child: FloatingButton(
                        insideText: "",
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddOrEditRecurringPatternPage(
                                onFinished:
                                    (RecurringPatternModel recurringPattern) {
                                  ref
                                      .read(eventScheduleProvider.notifier)
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
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddOrEditRecurringPatternPage(
                                                onFinished:
                                                    (RecurringPatternModel
                                                        recurringPattern) {
                                                  ref
                                                      .read(
                                                          eventScheduleProvider
                                                              .notifier)
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
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          // Show confirmation dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Delete Occurrence'),
                                                content: const Text(
                                                    'Are you sure you want to delete this occurrence? This action cannot be undone.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      ref
                                                          .read(
                                                              eventScheduleProvider
                                                                  .notifier)
                                                          .removeRecurringPattern(
                                                              index);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ))
                                  ],
                                )
                              ],
                            ),
                            pattern.isRecurring == true
                                ? ReccurringPatternInfo(pattern)
                                : SingleOccurenceInfo(pattern),
                            const SizedBox(height: AppDimensions.spacingSmall),
                          ],
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
