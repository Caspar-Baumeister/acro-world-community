import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/add_or_edit_recurring_pattern.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/reccurring_pattern_info.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/single_occurence_info.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
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
    final eventState = ref.watch(eventCreationAndEditingProvider);
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
                            .read(eventCreationAndEditingProvider.notifier)
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
                itemCount: eventState.recurringPatterns.length,
                itemBuilder: (context, index) {
                  RecurringPatternModel pattern =
                      eventState.recurringPatterns[index];
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
                                      .read(eventCreationAndEditingProvider
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
                                IconButton(
                                    onPressed: () {
                                      ref
                                          .read(eventCreationAndEditingProvider
                                              .notifier)
                                          .removeRecurringPattern(index);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ))
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
