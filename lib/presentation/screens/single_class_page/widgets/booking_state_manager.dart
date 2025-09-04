import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/buttons/modern_bottom_button.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_information_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/main_booking_modal.dart';
import 'package:acroworld/provider/riverpod_provider/event_bus_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Clean state management for booking functionality
/// Separates business logic from UI components
class BookingStateManager {
  static BookingButtonState getButtonState({
    required ClassModel clas,
    required ClassEvent? classEvent,
    required bool isCreator,
    required String? userId,
    required ClassEventBooking? booking,
  }) {
    // No user logged in
    if (userId == null) {
      return BookingButtonState(
        text: "Book now",
        variant: ModernBottomButtonVariant.primary,
        onPressed: () => _showAuthDialog(classEvent),
      );
    }

    // Creator view - no booking needed
    if (isCreator) {
      return BookingButtonState(
        text: "Calendar",
        variant: ModernBottomButtonVariant.primary,
        onPressed: () => _showCalendarModal(clas, isCreator),
      );
    }

    // No specific event - show calendar
    if (classEvent == null) {
      return BookingButtonState(
        text: "Calendar",
        variant: ModernBottomButtonVariant.primary,
        onPressed: () => _showCalendarModal(clas, isCreator),
      );
    }

    // Event exists but no booking options
    if (classEvent.classModel?.bookingOptions.isEmpty ?? true) {
      return BookingButtonState(
        text: "Calendar",
        variant: ModernBottomButtonVariant.primary,
        onPressed: () => _showCalendarModal(clas, isCreator),
      );
    }

    // Check if class has billing capability
    final billingTeacher =
        clas.owner?.teacher?.stripeId != null ? clas.owner : null;
    final isCashPayment = clas.isCashAllowed ?? false;

    if (billingTeacher == null && !isCashPayment) {
      return BookingButtonState(
        text: "Calendar",
        variant: ModernBottomButtonVariant.primary,
        onPressed: () => _showCalendarModal(clas, isCreator),
      );
    }

    // User has existing booking
    if (booking != null) {
      return BookingButtonState(
        text: booking.status == "Confirmed" ? "Booked" : "Payment pending",
        variant: booking.status == "Confirmed"
            ? ModernBottomButtonVariant.success
            : ModernBottomButtonVariant.warning,
        onPressed: () => _showBookingInfoModal(classEvent, userId, booking),
      );
    }

    // Event is fully booked
    if (classEvent.availableBookingSlots != null &&
        classEvent.availableBookingSlots! <= 0) {
      return BookingButtonState(
        text: "Booked out",
        variant: ModernBottomButtonVariant.secondary,
        onPressed: () => _showCalendarModal(clas, isCreator),
      );
    }

    // Available for booking
    return BookingButtonState(
      text: "Book now",
      variant: ModernBottomButtonVariant.primary,
      onPressed: () => _showBookingModal(classEvent),
    );
  }

  static void _showAuthDialog(ClassEvent? classEvent) {
    // This will be handled by the calling context
  }

  static void _showCalendarModal(ClassModel clas, bool isCreator) {
    // This will be handled by the calling context
  }

  static void _showBookingInfoModal(
      ClassEvent classEvent, String userId, ClassEventBooking booking) {
    // This will be handled by the calling context
  }

  static void _showBookingModal(ClassEvent classEvent) {
    // This will be handled by the calling context
  }
}

/// Represents the state of a booking button
class BookingButtonState {
  const BookingButtonState({
    required this.text,
    required this.variant,
    required this.onPressed,
  });

  final String text;
  final ModernBottomButtonVariant variant;
  final VoidCallback onPressed;
}

/// Provider for booking data
final bookingDataProvider =
    FutureProvider.family<ClassEventBooking?, String>((ref, eventId) async {
  // This will be implemented with proper data fetching
  return null;
});

/// Clean booking button widget that handles all booking states
class CleanBookingButton extends ConsumerStatefulWidget {
  const CleanBookingButton({
    super.key,
    required this.clas,
    this.classEvent,
  });

  final ClassModel clas;
  final ClassEvent? classEvent;

  @override
  ConsumerState<CleanBookingButton> createState() => _CleanBookingButtonState();
}

class _CleanBookingButtonState extends ConsumerState<CleanBookingButton> {
  VoidCallback? _refetch;

  @override
  void initState() {
    super.initState();
    ref.read(eventBusProvider.notifier).listenToRefetchBookingQuery((_) {
      if (_refetch != null) _refetch!();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userRiverpodProvider);
    final isCreator = ref.watch(userRoleProvider);

    return BottomAppBar(
      elevation: 0,
      child: userAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
        data: (user) {
          final userId = user?.id;

          // Handle auth case
          if (userId == null) {
            return ModernBottomButton(
              text: "Book now",
              variant: ModernBottomButtonVariant.primary,
              onPressed: () => _handleAuthRequired(context),
            );
          }

          // Handle creator case
          if (isCreator) {
            return ModernBottomButton(
              text: "Calendar",
              variant: ModernBottomButtonVariant.primary,
              onPressed: () => _showCalendarModal(context),
            );
          }

          // Handle no event case
          if (widget.classEvent == null) {
            return ModernBottomButton(
              text: "Calendar",
              variant: ModernBottomButtonVariant.primary,
              onPressed: () => _showCalendarModal(context),
            );
          }

          // Handle event with booking
          return _buildEventBookingButton(context, userId);
        },
      ),
    );
  }

  Widget _buildEventBookingButton(BuildContext context, String userId) {
    return Query(
      options: QueryOptions(
        document: Queries.myClassEventBookings,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'class_event_id': widget.classEvent!.id,
          'user_id': userId,
        },
      ),
      builder: (result, {refetch, fetchMore}) {
        _refetch = refetch;

        if (result.hasException) {
          throw result.exception!;
        }

        if (result.isLoading) {
          return const ModernBottomButton(
            text: "Loading...",
            variant: ModernBottomButtonVariant.secondary,
            isLoading: true,
            onPressed: null,
          );
        }

        final booking = result.data?['class_event_bookings'] != null
            ? (result.data!['class_event_bookings'] as List)
                .map((e) => ClassEventBooking.fromJson(e))
                .toList()
                .firstOrNull
            : null;

        final buttonState = BookingStateManager.getButtonState(
          clas: widget.clas,
          classEvent: widget.classEvent,
          isCreator: ref.read(userRoleProvider),
          userId: userId,
          booking: booking,
        );

        return ModernBottomButton(
          text: buttonState.text,
          variant: buttonState.variant,
          onPressed: () =>
              _handleButtonPress(context, buttonState, userId, refetch),
        );
      },
    );
  }

  void _handleAuthRequired(BuildContext context) {
    final classSlug = widget.classEvent?.classModel?.urlSlug;
    String redirectPath;

    if (classSlug != null) {
      redirectPath = '/event/$classSlug?event=${widget.classEvent!.id}';
    } else {
      redirectPath = '/';
    }

    showAuthRequiredDialog(
      context,
      subtitle:
          'Log in or sign up to book events, manage your tickets, and keep track of your activities.',
      redirectPath: redirectPath,
    );
  }

  void _showCalendarModal(BuildContext context) {
    buildMortal(
      context,
      CalenderModal(
        classId: widget.clas.id!,
        isCreator: ref.read(userRoleProvider),
      ),
    );
  }

  void _handleButtonPress(
    BuildContext context,
    BookingButtonState buttonState,
    String userId,
    VoidCallback? refetch,
  ) {
    switch (buttonState.text) {
      case "Booked":
      case "Payment pending":
        if (widget.classEvent != null) {
          // For now, show a simple dialog since we don't have the booking data
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(buttonState.text),
              content: const Text('Booking information will be shown here.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        break;
      case "Book now":
        if (widget.classEvent != null) {
          buildMortal(
            context,
            BookingModal(
              classEvent: widget.classEvent!,
              refetch: refetch!,
            ),
          );
        }
        break;
      case "Calendar":
        _showCalendarModal(context);
        break;
      case "Booked out":
        _showCalendarModal(context);
        break;
    }
  }
}
