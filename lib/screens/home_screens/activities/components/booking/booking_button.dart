import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_information_modal.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/stripe_test_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class BookNowButton extends StatelessWidget {
  const BookNowButton({Key? key, required this.classEvent}) : super(key: key);
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
          return ErrorWidget(queryResult.exception.toString());
        } else if (queryResult.isLoading) {
          return const LoadingWidget();
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
              return SizedBox(
                width: PARTICIPANT_BUTTON_WIDTH,
                height: PARTICIPANT_BUTTON_HEIGHT,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: const BorderSide(width: 1, color: SUCCESS_COLOR),
                      padding: const EdgeInsets.all(2)),
                  onPressed: () => buildMortal(
                      context,
                      BookingInformationModal(
                        classEvent: classEvent,
                        bookingOption: bookedOption,
                      )),
                  child: const Text("Reserved", style: MEDIUM_BUTTON_TEXT),
                ),
              );
            }
            // case 2: there are no places left
            if (bookingsLeft <= 0) {
              return SizedBox(
                width: PARTICIPANT_BUTTON_WIDTH,
                height: PARTICIPANT_BUTTON_HEIGHT,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: const BorderSide(width: 1, color: WARNING_COLOR),
                      padding: const EdgeInsets.all(2)),
                  onPressed: () {},
                  child: const Text(
                    "Booked out",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: PARTICIPANT_BUTTON_WIDTH,
                height: PARTICIPANT_BUTTON_HEIGHT,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: const BorderSide(width: 1, color: PRIMARY_COLOR),
                      padding: const EdgeInsets.all(2)),
                  // TODO add stripe payment
                  onPressed: () => buildMortal(
                    context,
                    const StripeTestModal(),
                  ),
                  //   BookingModal(
                  //       classEvent: classEvent,
                  //       placesLeft: bookingsLeft,
                  //       refetch: refetch),

                  child: const Text(
                    "Book now",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Text(
                "$bookingsLeft places left",
                style: H10W4,
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
