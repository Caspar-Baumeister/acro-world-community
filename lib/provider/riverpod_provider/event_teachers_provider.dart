import 'package:acroworld/data/models/teacher_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for event teachers information
class EventTeachersState {
  final List<TeacherModel> pendingInviteTeachers;
  final List<String> pendingEmailInvites;
  final bool isLoading;
  final String? errorMessage;

  const EventTeachersState({
    this.pendingInviteTeachers = const [],
    this.pendingEmailInvites = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  /// Get amount of followers from pending invite teachers
  int get amountOfFollowers {
    int amount = 0;
    for (var teacher in pendingInviteTeachers) {
      amount += (teacher.likes ?? 0).toInt();
    }
    return amount;
  }

  EventTeachersState copyWith({
    List<TeacherModel>? pendingInviteTeachers,
    List<String>? pendingEmailInvites,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventTeachersState(
      pendingInviteTeachers:
          pendingInviteTeachers ?? this.pendingInviteTeachers,
      pendingEmailInvites: pendingEmailInvites ?? this.pendingEmailInvites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier for event teachers information
class EventTeachersNotifier extends StateNotifier<EventTeachersState> {
  EventTeachersNotifier() : super(const EventTeachersState());

  /// Add pending invite teacher
  void addPendingInviteTeacher(TeacherModel teacher) {
    // Check if teacher is already in the list to avoid duplicates
    if (!state.pendingInviteTeachers.any((t) => t.id == teacher.id)) {
      final teachers = List<TeacherModel>.from(state.pendingInviteTeachers);
      teachers.add(teacher);
      state = state.copyWith(pendingInviteTeachers: teachers);
    }
  }

  /// Remove pending invite teacher
  void removePendingInviteTeacher(String teacherId) {
    final teachers = List<TeacherModel>.from(state.pendingInviteTeachers);
    teachers.removeWhere((t) => t.id == teacherId);
    state = state.copyWith(pendingInviteTeachers: teachers);
  }

  /// Clear all pending invite teachers
  void clearPendingInviteTeachers() {
    state = state.copyWith(pendingInviteTeachers: []);
  }

  /// Add email invitation
  void addEmailInvite(String email) {
    // Validate email format
    if (!_isValidEmail(email)) {
      return;
    }

    // Check for duplicates
    if (!state.pendingEmailInvites.contains(email)) {
      final emails = List<String>.from(state.pendingEmailInvites);
      emails.add(email);
      state = state.copyWith(pendingEmailInvites: emails);
    }
  }

  /// Remove email invitation
  void removeEmailInvite(String email) {
    final emails = List<String>.from(state.pendingEmailInvites);
    emails.remove(email);
    state = state.copyWith(pendingEmailInvites: emails);
  }

  /// Clear all email invitations
  void clearEmailInvites() {
    state = state.copyWith(pendingEmailInvites: []);
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Check if string is a valid email
  bool isValidEmail(String email) {
    return _isValidEmail(email);
  }

  /// Set pending invite teachers
  void setPendingInviteTeachers(List<TeacherModel> teachers) {
    state = state.copyWith(pendingInviteTeachers: teachers);
  }

  /// Check if teacher is in pending invites
  bool isTeacherPending(TeacherModel teacher) {
    return state.pendingInviteTeachers.any((t) => t.id == teacher.id);
  }

  /// Get teacher by ID from pending invites
  TeacherModel? getPendingTeacherById(String teacherId) {
    try {
      return state.pendingInviteTeachers.firstWhere((t) => t.id == teacherId);
    } catch (e) {
      return null;
    }
  }

  /// Reset state
  void reset() {
    state = const EventTeachersState();
  }

  /// Set from template data
  void setFromTemplate({
    required List<TeacherModel> pendingInviteTeachers,
  }) {
    state = state.copyWith(pendingInviteTeachers: pendingInviteTeachers);
  }
}

/// Provider for event teachers information
final eventTeachersProvider =
    StateNotifierProvider<EventTeachersNotifier, EventTeachersState>((ref) {
  return EventTeachersNotifier();
});
