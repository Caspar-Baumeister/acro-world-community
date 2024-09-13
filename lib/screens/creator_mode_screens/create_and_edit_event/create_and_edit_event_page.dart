import 'package:acroworld/components/custom_easy_stepper.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:acroworld/screens/creator_mode_screens/create_and_edit_event/steps/community_step.dart';
import 'package:acroworld/screens/creator_mode_screens/create_and_edit_event/steps/general_event_step.dart';
import 'package:acroworld/screens/creator_mode_screens/create_and_edit_event/steps/occurrences_step.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAndEditEventPage extends StatefulWidget {
  const CreateAndEditEventPage(
      {super.key, this.classModel, required this.isEditing});

  // can take an existing event as an argument or not
  final ClassModel? classModel;
  // can either edit the existing event or use it as a template to create a new event
  final bool isEditing;

  @override
  State<CreateAndEditEventPage> createState() => _CreateAndEditEventPageState();
}

class _CreateAndEditEventPageState extends State<CreateAndEditEventPage> {
  @override
  Widget build(BuildContext context) {
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);

    UserProvider userProvider = Provider.of<UserProvider>(context);

    final List<Widget> pages = [
      // second page
      GeneralEventStep(onFinished: () {
        eventCreationAndEditingProvider.setPage(2);
        setState(() {});
      }),
      OccurrenceStep(onFinished: () {
        eventCreationAndEditingProvider.setPage(1);
        setState(() {});
        eventCreationAndEditingProvider
            .createClass(userProvider.activeUser!.id!);
      }),
      CommunityStep(onFinished: () {
        eventCreationAndEditingProvider.setPage(1);
        setState(() {});
      }),

      Container(
        color: Colors.blue,
      ),
    ];

    print("currentPage: ${eventCreationAndEditingProvider.currentPage}");
    return BasePage(
      makeScrollable: false,
      child: Column(
        children: [
          Stack(
            children: [
              CustomEasyStepper(
                  activeStep: eventCreationAndEditingProvider.currentPage,
                  onStepReached: (_) {},
                  setStep: (index) {
                    if (index < eventCreationAndEditingProvider.currentPage) {
                      eventCreationAndEditingProvider.setPage(index);
                      setState(() {});
                    }
                  },
                  steps: const [
                    "General",
                    "Occurences",
                    "Community",
                    "Booking",
                  ]),
              Positioned(
                left: 0,
                top: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: AppDimensions.iconSizeLarge,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: pages[eventCreationAndEditingProvider.currentPage],
          ),
        ],
      ),
    );
  }
}
