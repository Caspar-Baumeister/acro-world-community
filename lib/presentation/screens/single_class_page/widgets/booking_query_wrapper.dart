import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/presentation/components/buttons/modern_bottom_button.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_information_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/main_booking_modal.dart';
import 'package:acroworld/provider/riverpod_provider/event_bus_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BookingQueryHoverButton extends ConsumerStatefulWidget {
  const BookingQueryHoverButton({super.key, required this.classEvent});
  final ClassEvent classEvent;

  @override
  ConsumerState<BookingQueryHoverButton> createState() =>
      _BookingQueryHoverButtonState();
}

class _BookingQueryHoverButtonState
    extends ConsumerState<BookingQueryHoverButton> {
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

    return userAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) {
        final userId = user?.id;
        if (userId == null) {
          // If no user is logged in, show Book Now button that opens auth dialog
          return ModernBottomButton(
            text: "Book now",
            variant: ModernBottomButtonVariant.primary,
            onPressed: () {
              // Construct redirect path for the current event
              final classSlug = widget.classEvent.classModel?.urlSlug;
              String redirectPath;

              if (classSlug != null) {
                redirectPath =
                    '/event/$classSlug?event=${widget.classEvent.id}';
              } else {
                redirectPath = '/';
              }

              // Show auth dialog with booking-specific message and redirect info
              showAuthRequiredDialog(
                context,
                subtitle:
                    'Log in or sign up to book events, manage your tickets, and keep track of your activities.',
                redirectPath: redirectPath,
              );
            },
          );
        }

        return Query(
          options: QueryOptions(
            document: Queries.myClassEventBookings,
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {
              'class_event_id': widget.classEvent.id,
              'user_id': userId,
            },
          ),
          builder: (result, {refetch, fetchMore}) {
            _refetch = refetch;

            if (result.hasException) {
              throw result.exception!;
            }
            if (result.isLoading) {
              return CustomBottomHoverButton(
                content: Container(),
                onPressed: () {},
              );
            }

            ClassEventBooking? myBooking =
                result.data?['class_event_bookings'] != null
                    ? (result.data!['class_event_bookings'] as List)
                        .map((e) => ClassEventBooking.fromJson(e))
                        .toList()
                        .firstOrNull
                    : null;

            if (myBooking != null) {
              // If the booking status is not empty, show "Booked"
              return ModernBottomButton(
                text: myBooking.status == "Confirmed"
                    ? "Booked"
                    : "Payment pending",
                variant: myBooking.status == "Confirmed"
                    ? ModernBottomButtonVariant.success
                    : ModernBottomButtonVariant.warning,
                onPressed: () {
                  buildMortal(
                    context,
                    BookingInformationModal(
                      classEvent: widget.classEvent,
                      userId: userId,
                      booking: myBooking,
                    ),
                  );
                },
              );
            }

            if (widget.classEvent.availableBookingSlots != null &&
                widget.classEvent.availableBookingSlots! <= 0) {
              return ModernBottomButton(
                text: "Booked out",
                variant: ModernBottomButtonVariant.secondary,
                onPressed: () {
                  final classId = widget.classEvent.classModel?.id;
                  if (classId != null) {
                    buildMortal(
                      context,
                      CalenderModal(classId: classId),
                    );
                  }
                },
              );
            }

            return ModernBottomButton(
              text: "Book now",
              variant: ModernBottomButtonVariant.primary,
              onPressed: () {
                buildMortal(
                  context,
                  BookingModal(
                    classEvent: widget.classEvent,
                    refetch: refetch!,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
