import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  // keeps track of the active jams and classes in the activity view
  List<Jam> activeJams = [];
  bool loading = true;
  List<ClassEvent> activeClasseEvents = [];
  DateTime activeDay = DateTime.now();

  setActiveJams(List<Jam> jams) {
    activeJams = jams;
    notifyListeners();
  }

  setActiveClasses(List<ClassEvent> classes) {
    activeClasseEvents = classes;
    notifyListeners();
  }

  setLoading(bool newLoading) {
    loading = newLoading;
    notifyListeners();
  }
}
