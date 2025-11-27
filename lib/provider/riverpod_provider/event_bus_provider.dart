import 'package:acroworld/events/event_bus_provider.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for event bus management
class EventBusState {
  final EventBus eventBus;

  const EventBusState({
    required this.eventBus,
  });

  EventBusState copyWith({
    EventBus? eventBus,
  }) {
    return EventBusState(
      eventBus: eventBus ?? this.eventBus,
    );
  }
}

/// Notifier for event bus state management
class EventBusNotifier extends StateNotifier<EventBusState> {
  EventBusNotifier() : super(EventBusState(eventBus: EventBus()));

  /// Get the event bus
  EventBus get getEventBus => state.eventBus;

  /// Fire refetch booking query event
  void fireRefetchBookingQuery() {
    state.eventBus.fire(RefetchBookingQuery());
  }

  /// Fire refetch event highlights query event
  void fireRefetchEventHighlightsQuery() {
    state.eventBus.fire(RefetchEventHighlightsQuery());
  }

  /// Listen to refetch booking query events
  void listenToRefetchBookingQuery(void Function(RefetchBookingQuery) onEvent) {
    state.eventBus.on<RefetchBookingQuery>().listen(onEvent);
  }

  /// Listen to refetch event highlights query events
  void listenToRefetchEventHighlightsQuery(
      void Function(RefetchEventHighlightsQuery) onEvent) {
    state.eventBus.on<RefetchEventHighlightsQuery>().listen(onEvent);
  }

  /// Test constructor for unit tests
  EventBusNotifier.test() : super(EventBusState(eventBus: EventBus()));
}

/// Provider for event bus state
final eventBusProvider = StateNotifierProvider<EventBusNotifier, EventBusState>((ref) {
  return EventBusNotifier();
});
