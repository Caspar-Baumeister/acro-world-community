import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventCreationAndEditingNotifier', () {
    late EventCreationAndEditingNotifier notifier;

    setUp(() {
      notifier = EventCreationAndEditingNotifier.test();
    });

    test('initial state should have default values', () {
      expect(notifier.state.currentPage, 0);
      expect(notifier.state.isSlugValid, isNull);
      expect(notifier.state.classModel, isNotNull);
      expect(notifier.state.bookingCategories, isEmpty);
      expect(notifier.state.bookingOptions, isEmpty);
      expect(notifier.state.questions, isEmpty);
      expect(notifier.state.recurrentPattern, isNull);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, isNull);
    });

    test('setCurrentPage should update current page', () {
      notifier.setCurrentPage(2);
      expect(notifier.state.currentPage, 2);
    });

    test('addBookingCategory should add category to list', () {
      final category = BookingCategoryModel(
        id: 'test-id',
        name: 'Test Category',
        description: 'Test Description',
        contingent: 20,
      );

      notifier.addBookingCategory(category);
      expect(notifier.state.bookingCategories.length, 1);
      expect(notifier.state.bookingCategories.first, category);
    });

    test('removeBookingCategory should remove category from list', () {
      final category = BookingCategoryModel(
        id: 'test-id',
        name: 'Test Category',
        description: 'Test Description',
        contingent: 20,
      );

      notifier.addBookingCategory(category);
      expect(notifier.state.bookingCategories.length, 1);

      notifier.removeBookingCategory(0);
      expect(notifier.state.bookingCategories.length, 0);
    });

    test('addQuestion should add question to list', () {
      final question = QuestionModel(
        id: 'test-id',
        question: 'Test Question?',
        type: QuestionType.text,
        isRequired: true,
        choices: [],
      );

      notifier.addQuestion(question);
      expect(notifier.state.questions.length, 1);
      expect(notifier.state.questions.first, question);
    });

    test('removeQuestion should remove question from list', () {
      final question = QuestionModel(
        id: 'test-id',
        question: 'Test Question?',
        type: QuestionType.text,
        isRequired: true,
        choices: [],
      );

      notifier.addQuestion(question);
      expect(notifier.state.questions.length, 1);

      notifier.removeQuestion(0);
      expect(notifier.state.questions.length, 0);
    });

    test('reset should reset state to initial values', () {
      // First modify the state
      notifier.setCurrentPage(3);
      final category = BookingCategoryModel(
        id: 'test-id',
        name: 'Test Category',
        description: 'Test Description',
        contingent: 20,
      );
      notifier.addBookingCategory(category);

      // Then reset
      notifier.reset();

      expect(notifier.state.currentPage, 0);
      expect(notifier.state.bookingCategories, isEmpty);
      expect(notifier.state.classModel, isNotNull);
    });

    test('state copyWith should work correctly', () {
      final newState = notifier.state.copyWith(currentPage: 5);
      expect(newState.currentPage, 5);
      expect(newState.bookingCategories, isEmpty); // Should remain unchanged
    });
  });
}
