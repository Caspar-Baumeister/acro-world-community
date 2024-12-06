import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class EventBusProvider extends ChangeNotifier {
  final EventBus eventBus = EventBus();

  EventBus get getEventBus => eventBus;

  void fireRefetchBookingQuery() {
    eventBus.fire(RefetchBookingQuery());
  }

  // highlight refetch
  void fireRefetchEventHighlightsQuery() {
    eventBus.fire(RefetchEventHighlightsQuery);
  }

  void listenToRefetchBookingQuery(void Function(RefetchBookingQuery) onEvent) {
    eventBus.on<RefetchBookingQuery>().listen(onEvent);
  }

  // highlight refetch
  void listenToRefetchEventHighlightsQuery(
      void Function(RefetchEventHighlightsQuery) onEvent) {
    print("Firing RefetchEventHighlightsQuery event inside");
    eventBus.on<RefetchEventHighlightsQuery>().listen(onEvent);
  }
}

class RefetchEvent {
  const RefetchEvent();
}

// Define specific refetch events
class RefetchBookingQuery extends RefetchEvent {}
// Add more events as needed for different parts of your app

class RefetchEventHighlightsQuery extends RefetchEvent {}
