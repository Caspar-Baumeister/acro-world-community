import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  // keeps track of the active jams and classes in the activity view
  List<Jam> activeJams = [];
  List<NewClassEventsModel> activeClasseEvents = [];
  DateTime activeDay = DateTime.now();
}
