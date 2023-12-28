import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_modal/main_booking_modal.dart';
import 'package:acroworld/screens/single_class_page/widgets/custom_bottom_hover_button.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class BookingQueryHoverButton extends StatelessWidget {
  const BookingQueryHoverButton({super.key, required this.classEvent});
  final ClassEvent classEvent;

  // This widget is a wrapper for the booking button
  // It queries the database for all bookings of the given class event
  // and then decides what to show

  // case 1: user has already booked -> you reserved this class (later: storno reservation)
  // case 2: there are no places left -> show booked out
  // case 3: there are places left -> show booking button

  // it needs the aggregated data
  // and a true or false whether the user has already booked and the booking was successful

  @override
  Widget build(BuildContext context) {
    // query for all bookings that where made for the given class event the user ids
    return Query(
      options: QueryOptions(
          document: Queries.getAllBookingsOfClassEvent,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'class_event_id': classEvent.id}),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (queryResult.hasException) {
          throw queryResult.exception!;
        } else if (queryResult.isLoading) {
          return CustomBottomHoverButton(
              content: Container(), onPressed: () {});
        } else if (queryResult.data != null &&
            queryResult.data?["class_event_booking"] != null) {
          final bookedUserJson = queryResult.data?["class_event_booking"];
          // clean out the bookedUserJson where the status is not success
          bookedUserJson.removeWhere((json) => json["status"] != "Success");
          num bookingsLeft =
              classEvent.classModel!.maxBookingSlots! - bookedUserJson.length;
          if (bookedUserJson.isNotEmpty) {
            List<String> bookedUserIds = List<String>.from(
                bookedUserJson.map((json) => json["user_id"]));

            // case 1: user has already booked -> you reserved this class (later: storno reservation)
            if (bookedUserIds.contains(
                Provider.of<UserProvider>(context, listen: false)
                    .activeUser!
                    .id!)) {
              // BookingOption bookedOption = BookingOption.fromJson(
              //     bookedUserJson.firstWhere((json) =>
              //         json["user_id"] ==
              //         userProvider.activeUser!.id!)["booking_option"]);
              // show "Successfully reserved"
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
                  backgroundColor: Colors.green,
                  onPressed: () {
                    // show message that the user has already booked
                    Fluttertoast.showToast(
                        msg: "You have already booked this class",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
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
              // const StripeTestModal(),

              BookingModal(
                  classEvent: classEvent,
                  placesLeft: bookingsLeft,
                  refetch: refetch),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
