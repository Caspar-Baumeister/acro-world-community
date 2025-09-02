import 'package:acroworld/data/models/class_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for activity management
class ActivityState {
  final bool loading;
  final List<ClassEvent> activeClassEvents;
  final DateTime activeDay;

  ActivityState({
    this.loading = true,
    this.activeClassEvents = const [],
    DateTime? activeDay,
  }) : activeDay = activeDay ?? DateTime.now();

  ActivityState copyWith({
    bool? loading,
    List<ClassEvent>? activeClassEvents,
    DateTime? activeDay,
  }) {
    return ActivityState(
      loading: loading ?? this.loading,
      activeClassEvents: activeClassEvents ?? this.activeClassEvents,
      activeDay: activeDay ?? this.activeDay,
    );
  }
}

/// Notifier for activity state management
class ActivityNotifier extends StateNotifier<ActivityState> {
  ActivityNotifier() : super(ActivityState());

  /// Set active classes
  void setActiveClasses(List<ClassEvent> classes) {
    state = state.copyWith(activeClassEvents: classes);
  }

  /// Set loading state
  void setLoading(bool newLoading) {
    state = state.copyWith(loading: newLoading);
  }

  /// Set active day
  void setActiveDay(DateTime day) {
    state = state.copyWith(activeDay: day);
  }

  /// Test constructor for unit tests
  ActivityNotifier.test() : super(ActivityState());
}

/// Provider for activity state
final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier();
});
