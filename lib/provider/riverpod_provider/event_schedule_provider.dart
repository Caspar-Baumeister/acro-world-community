import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for event scheduling information
class EventScheduleState {
  final List<RecurringPatternModel> recurringPatterns;
  final List<RecurringPatternModel>
      oldRecurringPatterns; // Snapshot for deletion tracking
  final RecurringPatternModel? recurrentPattern;
  final bool isLoading;
  final String? errorMessage;

  const EventScheduleState({
    this.recurringPatterns = const [],
    this.oldRecurringPatterns = const [],
    this.recurrentPattern,
    this.isLoading = false,
    this.errorMessage,
  });

  EventScheduleState copyWith({
    List<RecurringPatternModel>? recurringPatterns,
    List<RecurringPatternModel>? oldRecurringPatterns,
    RecurringPatternModel? recurrentPattern,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventScheduleState(
      recurringPatterns: recurringPatterns ?? this.recurringPatterns,
      oldRecurringPatterns: oldRecurringPatterns ?? this.oldRecurringPatterns,
      recurrentPattern: recurrentPattern ?? this.recurrentPattern,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier for event scheduling information
class EventScheduleNotifier extends StateNotifier<EventScheduleState> {
  EventScheduleNotifier() : super(const EventScheduleState());

  /// Add recurring pattern
  void addRecurringPattern(RecurringPatternModel pattern) {
    final patterns = List<RecurringPatternModel>.from(state.recurringPatterns);
    patterns.add(pattern);
    state = state.copyWith(recurringPatterns: patterns);
  }

  /// Remove recurring pattern
  void removeRecurringPattern(int index) {
    final patterns = List<RecurringPatternModel>.from(state.recurringPatterns);
    if (index >= 0 && index < patterns.length) {
      patterns.removeAt(index);
      state = state.copyWith(recurringPatterns: patterns);
    }
  }

  /// Update recurring pattern
  void updateRecurringPattern(int index, RecurringPatternModel pattern) {
    final patterns = List<RecurringPatternModel>.from(state.recurringPatterns);
    if (index >= 0 && index < patterns.length) {
      patterns[index] = pattern;
      state = state.copyWith(recurringPatterns: patterns);
    }
  }

  /// Set all recurring patterns
  void setRecurringPatterns(List<RecurringPatternModel> patterns) {
    state = state.copyWith(recurringPatterns: patterns);
  }

  /// Set current recurrent pattern
  void setRecurrentPattern(RecurringPatternModel pattern) {
    state = state.copyWith(recurrentPattern: pattern);
  }

  /// Edit recurring pattern
  void editRecurringPattern(int index, RecurringPatternModel pattern) {
    final patterns = List<RecurringPatternModel>.from(state.recurringPatterns);
    if (index >= 0 && index < patterns.length) {
      patterns[index] = pattern;
      state = state.copyWith(recurringPatterns: patterns);
    }
  }

  /// Clear recurrent pattern
  void clearRecurrentPattern() {
    state = state.copyWith(recurrentPattern: null);
  }

  /// Set schedule data
  void setScheduleData({
    required List<RecurringPatternModel> recurringPatterns,
    RecurringPatternModel? recurrentPattern,
  }) {
    state = state.copyWith(
      recurringPatterns: recurringPatterns,
      recurrentPattern: recurrentPattern,
    );
  }

  /// Reset state
  void reset() {
    state = const EventScheduleState();
  }

  /// Set from template data
  void setFromTemplate({
    required List<RecurringPatternModel> recurringPatterns,
    RecurringPatternModel? recurrentPattern,
  }) {
    state = state.copyWith(
      recurringPatterns: recurringPatterns,
      recurrentPattern: recurrentPattern,
    );
  }

  /// Set old recurring patterns (snapshot for deletion tracking)
  void setOldRecurringPatterns(List<RecurringPatternModel> patterns) {
    state = state.copyWith(oldRecurringPatterns: patterns);
  }
}

/// Provider for event scheduling information
final eventScheduleProvider =
    StateNotifierProvider<EventScheduleNotifier, EventScheduleState>((ref) {
  return EventScheduleNotifier();
});
