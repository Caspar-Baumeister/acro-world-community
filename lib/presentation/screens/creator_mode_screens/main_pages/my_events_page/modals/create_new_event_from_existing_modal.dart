import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewEventFromExistingModal extends StatefulWidget {
  const CreateNewEventFromExistingModal({super.key});

  @override
  State<CreateNewEventFromExistingModal> createState() =>
      _CreateNewEventFromExistingModalState();
}

class _CreateNewEventFromExistingModalState
    extends State<CreateNewEventFromExistingModal> {
  OptionObjects? currentOption;

  @override
  Widget build(BuildContext context) {
    TeacherEventsProvider teacherEventsProvider =
        Provider.of<TeacherEventsProvider>(context);
    var items = teacherEventsProvider.myCreatedEvents
        .where((element) => element.urlSlug != null && element.name != null)
        .map((event) => OptionObjects(event.urlSlug!, event.name!))
        .toList();
    return BaseModal(
        title: "Create New Event",
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
              child: Text(
                items.isEmpty
                    ? 'You have no events to use as a template for your new event. Create your first event now'
                    : 'Do you want to use an existing event as a template for your new event?',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: CustomColors.secondaryTextColor),
              ),
            ),
            items.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: AppPaddings.large),
                    child: CustomOptionInputComponent(
                        currentOption: currentOption,
                        onOptionSet: (option) {
                          setState(() => currentOption = items.firstWhere(
                              (element) => element.value == option));
                        },
                        options: [
                              OptionObjects(
                                  "Without template", "Without template")
                            ] +
                            items,
                        hintText: "Select event as template"),
                  ),
            const SizedBox(height: AppPaddings.toLarge),
            StandardButton(
              isFilled: true,
              text: items.isEmpty
                  ? "Create your first event"
                  : (currentOption?.value == null ||
                          currentOption?.value == "Without template"
                      ? "Continue without template"
                      : "Continue"),
              onPressed: () async {
                Navigator.of(context).pop();
                ClassModel? classModel;
                if (currentOption?.value != null &&
                    currentOption?.value != "Without template") {
                  await Provider.of<EventCreationAndEditingProvider>(context,
                          listen: false)
                      .setClassFromExisting(currentOption!.value, false);
                }
                Navigator.of(context).push(CreateAndEditEventPageRoute(
                    isEditing: false, classModel: classModel));
              },
            ),
          ],
        ));
  }
}
