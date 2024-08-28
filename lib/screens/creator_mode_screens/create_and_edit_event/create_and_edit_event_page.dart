import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:flutter/material.dart';

class CreateAndEditEventPage extends StatelessWidget {
  const CreateAndEditEventPage(
      {super.key, this.classModel, required this.isEditing});

  // can take an existing event as an argument or not
  final ClassModel? classModel;
  // can either edit the existing event or use it as a template to create a new event
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        EventCreationAndEditingProvider();
    final List<Widget> steps = [];

    return BasePage(child: steps[eventCreationAndEditingProvider.currentStep]);
  }
}

class EventCreationAndEditingProvider extends ChangeNotifier {
  // the eventCreationAndEditingProvider keeps track of the data entered by the user
  // and provides methods to save the event
  // the provider is initialized with the existing event if it is passed as an argument
  // otherwise it is initialized with an empty event
  // and keeps track of the current step of the event creation process
  final int currentStep = 0;
  // this bool determines if there is a event currently under construction or editing.
  // this prevents the overwriting of the event if the user clicks on create new event again
  final bool _isEventUnderConstruction = false;

  ClassModel? _currentEvent;

  EventCreationAndEditingProvider();
}
