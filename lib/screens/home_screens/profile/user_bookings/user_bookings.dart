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
            List bookings = queryResult.data!["me"]![0]?["bookings"];
            List<UserBookingModel> userBookings =
                bookings.map((e) => UserBookingModel.fromJson(e)).toList();
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
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child:
                            UserBookingsCard(userBooking: userBookings[index]),
                      );
                    }));
          } catch (e) {
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
  String eventName;
  String eventImage;
  DateTime startDate;
  DateTime endDate;
  String bookingTitle;

  UserBookingModel({
    required this.eventName,
    required this.eventImage,
    required this.startDate,
    required this.endDate,
    required this.bookingTitle,
  });

  // Factory constructor for creating a new UserBookingModel instance from a map.
  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    return UserBookingModel(
      eventName: json['class_event']['class']['name'] as String,
      eventImage: json['class_event']['class']['image_url'] as String,
      startDate: DateTime.parse(json['class_event']['start_date']),
      endDate: DateTime.parse(json['class_event']['end_date']),
      bookingTitle: json['booking_option']['title'] as String,
    );
  }
}
