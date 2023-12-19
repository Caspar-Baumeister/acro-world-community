import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/screens/home_screens/profile/user_bookings/user_bookings_card.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserBookings extends StatelessWidget {
  const UserBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: Queries.userBookings,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (queryResult.hasException) {
          return ErrorWidget(queryResult.exception.toString());
        } else if (queryResult.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: LoadingWidget(),
          );
        } else if (queryResult.data != null &&
            queryResult.data?["me"] != null) {
          try {
            List bookings = queryResult.data!["me"]?[0]?["bookings"];
            // try to convert the bookings to a list of UserBookingModel, when it fails, do not show the item
            List<UserBookingModel> userBookings = [];
            if (bookings.isEmpty) {
              return const Center(
                child: Text(
                  "You have no bookings",
                  style: H16W7,
                  textAlign: TextAlign.center,
                ),
              );
            }
            for (var booking in bookings) {
              try {
                userBookings.add(UserBookingModel.fromJson(booking));
              } catch (e) {
                print("error inside user_bookings: $e");
              }
            }
            userBookings.sort((a, b) => b.startDate.compareTo(a.startDate));
            return userBookings.isEmpty
                ? const Center(
                    child: Text(
                      "You have no bookings",
                      style: H16W7,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userBookings.length,
                    itemBuilder: (context, index) {
                      print("user_bookings: ${userBookings[index].status}");
                      // Check if the current booking is in the past
                      bool isPastBooking =
                          userBookings[index].endDate.isBefore(DateTime.now());

                      // Check if the previous booking (if exists) is in the future
                      bool isPreviousBookingFuture = index > 0
                          ? userBookings[index - 1]
                              .endDate
                              .isAfter(DateTime.now())
                          : false;

                      // If current booking is past and previous (if exists) is future, show 'Past Bookings' heading
                      if (isPastBooking && isPreviousBookingFuture) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Past Bookings",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            UserBookingsCard(userBooking: userBookings[index]),
                          ],
                        );
                      }

                      // If it's the first item and it's a future booking, show 'Upcoming Bookings' heading
                      if (index == 0 && !isPastBooking) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Upcoming Bookings",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            UserBookingsCard(userBooking: userBookings[index]),
                          ],
                        );
                      }

                      // Default case, just show the booking card
                      return UserBookingsCard(userBooking: userBookings[index]);
                    },
                  );
          } catch (e) {
            print("error inside user_bookings: $e");
            return ErrorPage(
                error:
                    "An unexpected error occured, when transforming the user bookings to an objects with ${e.toString()} ");
          }
        } else {
          return const ErrorPage(
              error:
                  "An unexpected error occured, when fetching user bookmarks");
        }
      },
    );
  }
}

class UserBookingModel {
  String? classEventId;
  String? classId;
  String? eventName;
  String? eventImage;
  DateTime startDate;
  DateTime endDate;
  String? bookingTitle;
  String? status;
  String? locationName;

  UserBookingModel({
    required this.classEventId,
    required this.classId,
    required this.eventName,
    required this.eventImage,
    required this.startDate,
    required this.endDate,
    required this.bookingTitle,
    required this.status,
    this.locationName,
  });

  // Factory constructor for creating a new UserBookingModel instance from a map.
  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    // define the start and end date if they are not null
    DateTime? startDate;
    DateTime? endDate;

    if (json['class_event']?['start_date'] != null) {
      try {
        startDate = DateTime.parse(json['class_event']?['start_date']);
      } catch (e) {
        print("error while parsing start date: $e");
      }
    }
    if (json['class_event']?['end_date'] != null) {
      try {
        endDate = DateTime.parse(json['class_event']?['end_date']);
      } catch (e) {
        print("error while parsing end date: $e");
      }
    }

    return UserBookingModel(
      classEventId: json['class_event']?['id'] as String?,
      classId: json['class_event']?['class']?['id'] as String?,
      locationName: json['class_event']?['class']?['location_name'] as String?,
      status: json['status'] as String?,
      eventName: json['class_event']?['class']?['name'] as String?,
      eventImage: json['class_event']?['class']?['image_url'] as String?,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now(),
      bookingTitle: json['booking_option']?['title'] as String?,
    );
  }
}
