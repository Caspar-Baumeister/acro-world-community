import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/add_or_edit_recurring_pattern.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/reccurring_pattern_info.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/single_occurence_info.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OccurrenceStep extends StatefulWidget {
  const OccurrenceStep({super.key, required this.onFinished});
  final Function onFinished;

  @override
  State<OccurrenceStep> createState() => _OccurrenceStepState();
}

class _OccurrenceStepState extends State<OccurrenceStep> {
  void _onNext() {
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);
    return Container(
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Column(
        children: [
          StandartButton(
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
          const SizedBox(height: AppDimensions.spacingMedium),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    eventCreationAndEditingProvider.recurringPatterns.length,
                itemBuilder: (context, index) {
                  RecurringPatternModel pattern =
                      eventCreationAndEditingProvider.recurringPatterns[index];
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
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                IconButton(
                                    onPressed: () {
                                      eventCreationAndEditingProvider
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
          const SizedBox(height: AppDimensions.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: Responsive.isDesktop(context)
                    ? const BoxConstraints(maxWidth: 200)
                    : null,
                child: Consumer<EventCreationAndEditingProvider>(
                    builder: (context, provider, child) {
                  return StandartButton(
                    onPressed: () {
                      provider.setPage(0);
                      setState(() {});
                    },
                    text: "Previous",
                    width: MediaQuery.of(context).size.width * 0.3,
                  );
                }),
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              Container(
                constraints: Responsive.isDesktop(context)
                    ? const BoxConstraints(maxWidth: 200)
                    : null,
                child: StandartButton(
                  onPressed: _onNext,
                  text: "Next",
                  isFilled: true,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
        ],
      ),
    );
  }
}
