import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateNewEventFromExistingModal extends ConsumerStatefulWidget {
  const CreateNewEventFromExistingModal({super.key});

  @override
  ConsumerState<CreateNewEventFromExistingModal> createState() =>
      _CreateNewEventFromExistingModalState();
}

class _CreateNewEventFromExistingModalState
    extends ConsumerState<CreateNewEventFromExistingModal> {
  OptionObjects? currentOption;

  @override
  Widget build(BuildContext context) {
    final teacherEventsState = ref.watch(teacherEventsProvider);
    var items = teacherEventsState.myCreatedEvents
        .where((element) => element.urlSlug != null && element.name != null)
        .map((event) => OptionObjects(event.urlSlug!, event.name!))
        .toList();
    return BaseModal(
        title: "Create New Event",
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMedium),
              child: Text(
                items.isEmpty
                    ? 'You have no events to use as a template for your new event. Create your first event now'
                    : 'Do you want to use an existing event as a template for your new event?',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7)),
              ),
            ),
            items.isEmpty
                ? const SizedBox()
                : Padding(
                    padding:
                        const EdgeInsets.only(top: AppDimensions.spacingLarge),
                    child: CustomOptionInputComponent(
                        currentOption: currentOption,
                        onOptionSet: (option) {
                          setState(() => currentOption = items.firstWhere(
                              (element) => element.value == option,
                              orElse: () => OptionObjects(
                                  "Without template", "Without template")));
                        },
                        options: [
                              OptionObjects(
                                  "Without template", "Without template")
                            ] +
                            items,
                        hintText: "Select event as template"),
                  ),
            const SizedBox(height: AppDimensions.spacingHuge),
            ModernButton(
              isFilled: true,
              text: items.isEmpty
                  ? "Create your first event"
                  : (currentOption?.value == null ||
                          currentOption?.value == "Without template"
                      ? "Continue without template"
                      : "Continue"),
              onPressed: () {
                Navigator.of(context).pop();
                if (currentOption?.value != null &&
                    currentOption?.value != "Without template") {
                  context.pushNamed(createEditEventRoute,
                      queryParameters: {'isEditing': 'false'});

                  ref
                      .read(eventCreationAndEditingProvider.notifier)
                      .setClassFromExisting(currentOption!.value, false, true);
                } else {
                  ref.read(eventCreationAndEditingProvider.notifier).clear();
                  context.pushNamed(createEditEventRoute,
                      queryParameters: {'isEditing': 'false'});
                }
              },
            ),
          ],
        ));
  }
}
