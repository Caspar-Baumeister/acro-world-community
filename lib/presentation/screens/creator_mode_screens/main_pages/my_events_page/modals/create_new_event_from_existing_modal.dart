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
  String? currentOption;

  @override
  Widget build(BuildContext context) {
    return BaseModal(
        title: "Create New Event",
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
              child: Text(
                'Do you want to use an existing event as a template for your new event?',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: CustomColors.secondaryTextColor),
              ),
            ),
            const SizedBox(height: AppPaddings.large),
            Consumer<TeacherEventsProvider>(
                builder: (context, myEventsProvider, child) {
              return CustomOptionInputComponent(
                  currentOption: currentOption,
                  onOptionSet: (option) =>
                      setState(() => currentOption = option),
                  options: ["Without template"] +
                      myEventsProvider.myCreatedEvents
                          .map((event) => event.name!)
                          .toList(),
                  hintText: "Select event as template");
            }),
            const SizedBox(height: AppPaddings.toLarge),
            StandardButton(
              text: currentOption == null || currentOption == "Without template"
                  ? "Continue without template"
                  : "Continue",
              onPressed: () async {
                Navigator.of(context).pop();
                ClassModel? classModel;
                if (currentOption != null &&
                    currentOption != "Without template") {
                  classModel = Provider.of<TeacherEventsProvider>(context,
                          listen: false)
                      .myCreatedEvents
                      .firstWhere((element) => element.name == currentOption);

                  await Provider.of<EventCreationAndEditingProvider>(context,
                          listen: false)
                      .setClassFromExisting(classModel.urlSlug!);
                }
                Navigator.of(context).push(CreateAndEditEventPageRoute(
                    isEditing: false, classModel: classModel));
              },
            ),
          ],
        ));
  }
}
