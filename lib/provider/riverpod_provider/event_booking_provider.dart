import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for event booking information
class EventBookingState {
  final List<BookingCategoryModel> bookingCategories;
  final List<BookingOption> bookingOptions;
  final List<BookingCategoryModel>
      oldBookingCategories; // Snapshot for deletion tracking
  final List<BookingOption> oldBookingOptions; // Snapshot for deletion tracking
  final int? maxBookingSlots;
  final bool isCashAllowed;
  final bool isLoading;
  final String? errorMessage;

  const EventBookingState({
    this.bookingCategories = const [],
    this.bookingOptions = const [],
    this.oldBookingCategories = const [],
    this.oldBookingOptions = const [],
    this.maxBookingSlots,
    this.isCashAllowed = false,
    this.isLoading = false,
    this.errorMessage,
  });

  EventBookingState copyWith({
    List<BookingCategoryModel>? bookingCategories,
    List<BookingOption>? bookingOptions,
    List<BookingCategoryModel>? oldBookingCategories,
    List<BookingOption>? oldBookingOptions,
    int? maxBookingSlots,
    bool? isCashAllowed,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventBookingState(
      bookingCategories: bookingCategories ?? this.bookingCategories,
      bookingOptions: bookingOptions ?? this.bookingOptions,
      oldBookingCategories: oldBookingCategories ?? this.oldBookingCategories,
      oldBookingOptions: oldBookingOptions ?? this.oldBookingOptions,
      maxBookingSlots: maxBookingSlots ?? this.maxBookingSlots,
      isCashAllowed: isCashAllowed ?? this.isCashAllowed,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier for event booking information
class EventBookingNotifier extends StateNotifier<EventBookingState> {
  EventBookingNotifier() : super(const EventBookingState());

  /// Add booking category
  void addBookingCategory(BookingCategoryModel category) {
    final categories = List<BookingCategoryModel>.from(state.bookingCategories);
    categories.add(category);
    state = state.copyWith(bookingCategories: categories);
  }

  /// Remove booking category
  void removeBookingCategory(int index) {
    final categories = List<BookingCategoryModel>.from(state.bookingCategories);
    if (index >= 0 && index < categories.length) {
      categories.removeAt(index);
      state = state.copyWith(bookingCategories: categories);
    }
  }

  /// Update booking category
  void updateBookingCategory(int index, BookingCategoryModel category) {
    final categories = List<BookingCategoryModel>.from(state.bookingCategories);
    if (index >= 0 && index < categories.length) {
      categories[index] = category;
      state = state.copyWith(bookingCategories: categories);
    }
  }

  /// Add booking option
  void addBookingOption(BookingOption option) {
    final options = List<BookingOption>.from(state.bookingOptions);
    options.add(option);
    state = state.copyWith(bookingOptions: options);
  }

  /// Remove booking option
  void removeBookingOption(int index) {
    final options = List<BookingOption>.from(state.bookingOptions);
    if (index >= 0 && index < options.length) {
      options.removeAt(index);
      state = state.copyWith(bookingOptions: options);
    }
  }

  /// Update booking option
  void updateBookingOption(int index, BookingOption option) {
    final options = List<BookingOption>.from(state.bookingOptions);
    if (index >= 0 && index < options.length) {
      options[index] = option;
      state = state.copyWith(bookingOptions: options);
    }
  }

  /// Set cash allowed
  void setCashAllowed(bool isCashAllowed) {
    state = state.copyWith(isCashAllowed: isCashAllowed);
  }

  /// Toggle cash allowed
  void toggleCashAllowed() {
    state = state.copyWith(isCashAllowed: !state.isCashAllowed);
  }

  /// Switch allow cash payments
  void switchAllowCashPayments() {
    state = state.copyWith(isCashAllowed: !state.isCashAllowed);
  }

  /// Edit booking category
  void editCategory(int index, BookingCategoryModel category) {
    final categories = List<BookingCategoryModel>.from(state.bookingCategories);
    if (index >= 0 && index < categories.length) {
      categories[index] = category;
      state = state.copyWith(bookingCategories: categories);
    }
  }

  /// Edit booking option
  void editBookingOption(int index, BookingOption option) {
    final options = List<BookingOption>.from(state.bookingOptions);
    if (index >= 0 && index < options.length) {
      options[index] = option;
      state = state.copyWith(bookingOptions: options);
    }
  }

  /// Set max booking slots
  void setMaxBookingSlots(int? maxSlots) {
    state = state.copyWith(maxBookingSlots: maxSlots);
  }

  /// Add category (alias for addBookingCategory)
  void addCategory(BookingCategoryModel category) {
    addBookingCategory(category);
  }

  /// Remove category (alias for removeBookingCategory)
  void removeCategory(int index) {
    removeBookingCategory(index);
  }

  /// Set all booking data at once
  void setBookingData({
    required List<BookingCategoryModel> bookingCategories,
    required List<BookingOption> bookingOptions,
    required int? maxBookingSlots,
    required bool isCashAllowed,
  }) {
    state = state.copyWith(
      bookingCategories: bookingCategories,
      bookingOptions: bookingOptions,
      maxBookingSlots: maxBookingSlots,
      isCashAllowed: isCashAllowed,
    );
  }

  /// Reset state
  void reset() {
    state = const EventBookingState();
  }

  /// Set from template data
  void setFromTemplate({
    required List<BookingCategoryModel> bookingCategories,
    required List<BookingOption> bookingOptions,
    required int? maxBookingSlots,
    required bool isCashAllowed,
  }) {
    print('🎟️ PROVIDER DEBUG - setFromTemplate called');
    print(
        '🎟️ PROVIDER DEBUG - bookingCategories: ${bookingCategories.length}');
    print('🎟️ PROVIDER DEBUG - bookingOptions: ${bookingOptions.length}');
    print('🎟️ PROVIDER DEBUG - maxBookingSlots: $maxBookingSlots');
    print('🎟️ PROVIDER DEBUG - isCashAllowed: $isCashAllowed');

    for (int i = 0; i < bookingCategories.length; i++) {
      final cat = bookingCategories[i];
      print(
          '🎟️ PROVIDER DEBUG - Category $i: ${cat.name} (ID: ${cat.id}, Contingent: ${cat.contingent})');
    }

    for (int i = 0; i < bookingOptions.length; i++) {
      final opt = bookingOptions[i];
      print(
          '🎟️ PROVIDER DEBUG - Option $i: ${opt.title} (ID: ${opt.id}, CategoryID: ${opt.bookingCategoryId}, Price: ${opt.price})');
    }

    state = state.copyWith(
      bookingCategories: bookingCategories,
      bookingOptions: bookingOptions,
      maxBookingSlots: maxBookingSlots,
      isCashAllowed: isCashAllowed,
    );

    print('🎟️ PROVIDER DEBUG - State updated!');
    print(
        '🎟️ PROVIDER DEBUG - state.bookingCategories: ${state.bookingCategories.length}');
    print(
        '🎟️ PROVIDER DEBUG - state.bookingOptions: ${state.bookingOptions.length}');
  }

  /// Set old booking data (snapshot for deletion tracking)
  void setOldBookingData({
    required List<BookingCategoryModel> categories,
    required List<BookingOption> options,
  }) {
    state = state.copyWith(
      oldBookingCategories: categories,
      oldBookingOptions: options,
    );
  }
}

/// Provider for event booking information
final eventBookingProvider =
    StateNotifierProvider<EventBookingNotifier, EventBookingState>((ref) {
  return EventBookingNotifier();
});
