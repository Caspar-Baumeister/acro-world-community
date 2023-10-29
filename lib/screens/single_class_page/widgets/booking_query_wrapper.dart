import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_information_modal.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/stripe_test_modal.dart';
import 'package:acroworld/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class BookingQueryHoverButton extends StatelessWidget {
  const BookingQueryHoverButton({Key? key, required this.classEvent})
      : super(key: key);
  final ClassEvent classEvent;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    // query for all bookings that where made for the given class event the user ids
    return Query(
      options: QueryOptions(
          document: Queries.getAllBookingsOfClassEvent,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'class_event_id': classEvent.id}),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (queryResult.hasException) {
          return Container(
            color: Colors.white,
          ); //ErrorWidget(queryResult.exception.toString());
        } else if (queryResult.isLoading) {
          return CustomBottomHoverButton(
              content: Container(
                color: Colors.white,
              ),
              onPressed: () {});
        } else if (queryResult.data != null &&
            queryResult.data?["class_event_booking"] != null) {
          final bookedUserJson = queryResult.data?["class_event_booking"];
          num bookingsLeft =
              classEvent.classModel!.maxBookingSlots! - bookedUserJson.length;
          if (bookedUserJson.isNotEmpty) {
            List<String> bookedUserIds = List<String>.from(
                bookedUserJson.map((json) => json["user_id"]));

            // case 1: user has already booked -> you reserved this class (later: storno reservation)
            if (bookedUserIds.contains(userProvider.activeUser!.id!)) {
              BookingOption bookedOption = BookingOption.fromJson(
                  bookedUserJson.firstWhere((json) =>
                      json["user_id"] ==
                      userProvider.activeUser!.id!)["booking_option"]);
              // show "Successfully reserved"
              return CustomBottomHoverButton(
                content: const Text(
                  "View your booking details",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => buildMortal(
                    context,
                    BookingInformationModal(
                      classEvent: classEvent,
                      bookingOption: bookedOption,
                    )),
              );
            }
            // case 2: there are no places left
            if (bookingsLeft <= 0) {
              return CustomBottomHoverButton(
                content: const Text(
                  "Booked out",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                // TODO show kalender
                onPressed: () {},
              );
            }
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
            // TODO show kalender
            onPressed: () => buildMortal(
              context,
              const StripeTestModal(),
            ),
            // buildMortal(
            //   context,
            //   BookingModal(
            //       classEvent: classEvent,
            //       placesLeft: bookingsLeft,
            //       refetch: refetch),
            // ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
