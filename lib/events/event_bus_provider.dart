import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class EventBusProvider extends ChangeNotifier {
  final EventBus eventBus = EventBus();

  EventBus get getEventBus => eventBus;

  void fireRefetchBookingQuery() {
    eventBus.fire(RefetchBookingQuery());
  }

  // Add more methods for different refetch events as needed

  void listenToRefetchBookingQuery(void Function(RefetchBookingQuery) onEvent) {
    eventBus.on<RefetchBookingQuery>().listen(onEvent);
  }

  // Add more listening methods for different refetch events as needed
}

class RefetchEvent {
  const RefetchEvent();
}

// Define specific refetch events
class RefetchBookingQuery extends RefetchEvent {}
// Add more events as needed for different parts of your app