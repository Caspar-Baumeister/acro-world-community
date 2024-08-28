import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/input/custom_option_input_component.dart';
import 'package:acroworld/components/tiles/event_tiles/class_tile.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/provider/my_events_provider.dart';
import 'package:acroworld/routing/routes/page_routes/single_class_id_wrapper_page_route.dart';
import 'package:acroworld/screens/modals/base_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatedEventsByMeSection extends StatelessWidget {
  const CreatedEventsByMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    MyEventsProvider myEventsProvider = Provider.of<MyEventsProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppPaddings.medium),
          child: StandardButton(
              text: "Create New Event",
              onPressed: () => buildMortal(
                  context, const CreateNewEventFromExistingModal())),
        ),
        if (myEventsProvider.loading)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (!myEventsProvider.loading)
          ...List<Widget>.from(
              myEventsProvider.myCreatedEvents.map((event) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppPaddings.small,
                        vertical: AppPaddings.tiny),
                    child: ClassTile(
                        classObject: event, onTap: () => onTap(event, context)),
                  ))),
      ],
    );
  }

  void onTap(ClassModel classObject, BuildContext context) {
    if (classObject.urlSlug != null || classObject.id != null) {
      Navigator.of(context).push(
        SingleEventIdWrapperPageRoute(
          urlSlug: classObject.urlSlug,
          classId: classObject.id,
          isCreator: true,
        ),
      );
    } else {
      showErrorToast("This event is not available anymore");
    }
  }
}

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
            Consumer<MyEventsProvider>(
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
              onPressed: () {},
            ),
          ],
        ));
  }
}
