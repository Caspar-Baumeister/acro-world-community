import 'package:acroworld/models/class_event.dart';
import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  // keeps track of the active jams and classes in the activity view
  bool loading = true;
  List<ClassEvent> activeClasseEvents = [];
  DateTime activeDay = DateTime.now();

  setActiveClasses(List<ClassEvent> classes) {
    activeClasseEvents = classes;
    notifyListeners();
  }

  setLoading(bool newLoading) {
    loading = newLoading;
    notifyListeners();
  }
}
