import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class EventBusProvider extends ChangeNotifier {
  final EventBus eventBus = EventBus();

  get getEventBus {
    return eventBus;
  }
}
