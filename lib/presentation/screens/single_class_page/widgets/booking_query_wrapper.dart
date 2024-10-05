import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/calendar_modal.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_information_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/main_booking_modal.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class BookingQueryHoverButton extends StatefulWidget {
  const BookingQueryHoverButton({super.key, required this.classEvent});
  final ClassEvent classEvent;

  @override
  State<BookingQueryHoverButton> createState() =>
      _BookingQueryHoverButtonState();
}

class _BookingQueryHoverButtonState extends State<BookingQueryHoverButton> {
  VoidCallback? _refetch;

  @override
  void initState() {
    super.initState();
    // Listen to the specific refetch event
    Provider.of<EventBusProvider>(context, listen: false)
        .listenToRefetchBookingQuery((event) {
      _callRefetch();
      // Call your refetch logic here
    });
  }

  void _callRefetch() {
    print("Refetching booking query");
    if (_refetch != null) {
      _refetch!();
    }
  }

  // This widget is a wrapper for the booking button
  @override
  Widget build(BuildContext context) {
    // query for all bookings that where made for the given class event the user ids
    return Query(
      options: QueryOptions(
          document: Queries.isClassEventBooked,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'class_event_id': widget.classEvent.id}),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        _refetch = refetch;

        if (queryResult.hasException) {
          throw queryResult.exception!;
        } else if (queryResult.isLoading) {
          return CustomBottomHoverButton(
              content: Container(), onPressed: () {});
        } else if (queryResult.data != null && queryResult.data != null) {
          final isBookedByUser =
              queryResult.data!["class_event_bookings_aggregate"]?["aggregate"]
                      ?["count"] ??
                  0;
          // clean out the bookedUserJson where the status is not success

          if (isBookedByUser != 0) {
            return CustomBottomHoverButton(
                content: const Text(
                  "Booked",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                // success color
                backgroundColor: CustomColors.successBgColor,
                onPressed: () {
                  // open modal to storno reservation and show the booking info
                  buildMortal(
                    context,
                    BookingInformationModal(
                        classEvent: widget.classEvent,
                        userId:
                            Provider.of<UserProvider>(context, listen: false)
                                .activeUser!
                                .id!),
                  );
                });
          }

          // case 2: there are no places left
          else if (widget.classEvent.availableBookingSlots != null &&
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
              onPressed: () => widget.classEvent.classModel?.id != null
                  ? buildMortal(context,
                      CalenderModal(classId: widget.classEvent.classModel!.id!))
                  : null,
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
            onPressed: () => buildMortal(
              context,
              BookingModal(classEvent: widget.classEvent, refetch: refetch),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
