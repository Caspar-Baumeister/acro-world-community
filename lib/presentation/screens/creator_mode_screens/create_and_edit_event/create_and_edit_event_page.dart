import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/custom_easy_stepper.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/community_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/general_event_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/market_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/occurrences_step.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);

    final List<Widget> pages = [
      // second page
      GeneralEventStep(onFinished: () {
        eventCreationAndEditingProvider.setPage(1);
        setState(() {});
      }),
      OccurrenceStep(onFinished: () {
        eventCreationAndEditingProvider.setPage(2);
        setState(() {});
      }),
      CommunityStep(onFinished: () {
        eventCreationAndEditingProvider.setPage(3);
        setState(() {});
      }),
      MarketStep(
          isEditing: widget.isEditing,
          onFinished: () async {
            // create a new event
            if (widget.isEditing) {
              await eventCreationAndEditingProvider.updateClass();
            } else {
              await eventCreationAndEditingProvider.createClass();
            }

            if (eventCreationAndEditingProvider.errorMessage == null) {
              showSuccessToast(
                  "Event ${widget.isEditing ? "updated" : "created"} successfully");
              // if successful, pop the page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(MyEventsPageRoute());
                Provider.of<TeacherEventsProvider>(context, listen: false)
                    .fetchMyEvents();
              });
            } else {
              // if not successful, show an error message
              showErrorToast(eventCreationAndEditingProvider.errorMessage!);
            }
          })
    ];

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