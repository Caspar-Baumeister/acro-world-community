import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/buttons/simple_floating_button.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/main_booking_modal.dart';
import 'package:acroworld/provider/riverpod_provider/event_bus_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Simple booking button that shows the appropriate action
class SimpleBookingButton extends ConsumerStatefulWidget {
  const SimpleBookingButton({
    super.key,
    required this.clas,
    this.classEvent,
  });

  final ClassModel clas;
  final ClassEvent? classEvent;

  @override
  ConsumerState<SimpleBookingButton> createState() => _SimpleBookingButtonState();
}

class _SimpleBookingButtonState extends ConsumerState<SimpleBookingButton> {
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

    return userAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) {
        final userId = user?.id;

        // Handle auth case
        if (userId == null) {
          return SimpleFloatingButton(
            text: "Book now",
            onPressed: () => _handleAuthRequired(context),
          );
        }

        // Handle creator case
        if (isCreator) {
          return SimpleFloatingButton(
            text: "Calendar",
            onPressed: () => _showCalendarModal(context),
          );
        }

        // Handle no event case
        if (widget.classEvent == null) {
          return SimpleFloatingButton(
            text: "Calendar",
            onPressed: () => _showCalendarModal(context),
          );
        }

        // Handle event with booking
        return _buildEventBookingButton(context, userId);
      },
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
          return const SimpleFloatingButton(
            text: "Loading...",
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

        // Determine button state
        if (booking != null) {
          final isConfirmed = booking.status == "Confirmed";
          return SimpleFloatingButton(
            text: isConfirmed ? "Booked" : "Payment pending",
            backgroundColor: isConfirmed ? Colors.green : Colors.orange,
            onPressed: () => _showBookingInfo(context, booking),
          );
        }

        // Check if booked out
        if (widget.classEvent!.availableBookingSlots != null &&
            widget.classEvent!.availableBookingSlots! <= 0) {
          return SimpleFloatingButton(
            text: "Booked out",
            backgroundColor: Colors.grey,
            onPressed: () => _showCalendarModal(context),
          );
        }

        // Default: show "Book now"
        return SimpleFloatingButton(
          text: "Book now",
          onPressed: () => _showBookingModal(context),
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

  void _showBookingInfo(BuildContext context, ClassEventBooking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(booking.status == "Confirmed" ? "Booked" : "Payment pending"),
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

  void _showBookingModal(BuildContext context) {
    buildMortal(
      context,
      BookingModal(
        classEvent: widget.classEvent!,
        refetch: _refetch!,
      ),
    );
  }
}
