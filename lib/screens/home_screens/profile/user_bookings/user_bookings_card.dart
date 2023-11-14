import 'package:acroworld/screens/home_screens/profile/user_bookings/user_bookings.dart';
import 'package:flutter/material.dart';

class UserBookingsCard extends StatelessWidget {
  const UserBookingsCard({Key? key, required this.userBooking})
      : super(key: key);

  final UserBookingModel userBooking;
  // String eventName;
  // String eventImage;
  // DateTime startDate;
  // DateTime endDate;
  // String bookingTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration for a rounded card with a shadow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      // padding for the card
      padding: const EdgeInsets.all(8),
      // the content of the card displaying the event image, name, date and booking title
      child: Column(
        children: [
          // the event image
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(userBooking.eventImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // the event name
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              userBooking.eventName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // the event date
          Text(
            "${userBooking.startDate.day}.${userBooking.startDate.month}.${userBooking.startDate.year} - ${userBooking.endDate.day}.${userBooking.endDate.month}.${userBooking.endDate.year}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          // the booking title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              userBooking.bookingTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
