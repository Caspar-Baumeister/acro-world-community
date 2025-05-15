import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_information_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/main_booking_modal.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart' as provider;

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
    provider.Provider.of<EventBusProvider>(context, listen: false)
        .listenToRefetchBookingQuery((_) {
      if (_refetch != null) _refetch!();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () =>
          CustomBottomHoverButton(content: Container(), onPressed: () {}),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) {
        final userId = user?.id;
        if (userId == null) return const SizedBox.shrink();

        return Query(
          options: QueryOptions(
            document: Queries.isClassEventBooked,
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

            final count = result.data?['class_event_bookings_aggregate']
                    ?['aggregate']?['count'] ??
                0;

            if (count != 0) {
              return CustomBottomHoverButton(
                content: const Text(
                  "Booked",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: CustomColors.successBgColor,
                onPressed: () {
                  buildMortal(
                    context,
                    BookingInformationModal(
                      classEvent: widget.classEvent,
                      userId: userId,
                    ),
                  );
                },
              );
            }

            if (widget.classEvent.availableBookingSlots != null &&
                widget.classEvent.availableBookingSlots! <= 0) {
              return CustomBottomHoverButton(
                content: const Text(
                  "Booked out",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
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

            return CustomBottomHoverButton(
              content: const Text(
                "Book now",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
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
