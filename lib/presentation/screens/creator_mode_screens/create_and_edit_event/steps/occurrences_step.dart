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

    return Container(
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
        ),
        child: Column(
          children: [
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingMedium,
              ),
              child: Text(
                'Add the dates and times when your event will take place.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            // Warning banner - only show when no occurrences
            if (scheduleState.recurringPatterns.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingMedium),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .errorContainer
                        .withValues(alpha: 0.3),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error.withValues(
                            alpha: 0.5,
                          ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 24,
                      ),
                      const SizedBox(width: AppDimensions.spacingSmall),
                      Expanded(
                        child: Text(
                          'Your event will not be visible without at least one occurrence.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Info banner - multiple occurrences note
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingMedium),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(
                        alpha: 0.3,
                      ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  const SizedBox(width: AppDimensions.spacingSmall),
                  Expanded(
                    child: Text(
                      'Multiple occurrences share all event details and booking options. This is recommended for regular classes or jams.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            // Add Occurrences button
            ModernButton(
              text: 'Add Occurrences',
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
              },
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            // Occurrences list
            Expanded(
              child: scheduleState.recurringPatterns.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: scheduleState.recurringPatterns.length,
                      itemBuilder: (context, index) {
                        RecurringPatternModel pattern =
                            scheduleState.recurringPatterns[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spacingSmall,
                          ),
                          child: FloatingButton(
                            insideText: "",
                            onPressed: () => _editPattern(context, index, pattern),
                            headerText: "",
                            insideWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      pattern.isRecurring == true
                                          ? "Recurring pattern"
                                          : "Single occurrence",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => _editPattern(
                                              context, index, pattern),
                                          icon: Icon(
                                            Icons.edit,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              _showDeleteDialog(context, index),
                                          icon: Icon(
                                            Icons.delete,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                pattern.isRecurring == true
                                    ? ReccurringPatternInfo(pattern)
                                    : SingleOccurenceInfo(pattern),
                                const SizedBox(
                                    height: AppDimensions.spacingSmall),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingExtraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            Text(
              "No occurrences added yet",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            Text(
              "Click 'Add Occurrences' above to schedule when your event will take place",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _editPattern(
      BuildContext context, int index, RecurringPatternModel pattern) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddOrEditRecurringPatternPage(
          onFinished: (RecurringPatternModel recurringPattern) {
            ref.read(eventScheduleProvider.notifier).editRecurringPattern(
                  index,
                  recurringPattern,
                );
          },
          recurringPattern: pattern,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Occurrence'),
          content: const Text(
            'Are you sure you want to delete this occurrence? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(eventScheduleProvider.notifier)
                    .removeRecurringPattern(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
