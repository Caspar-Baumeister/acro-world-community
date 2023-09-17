import 'package:add_2_calendar/add_2_calendar.dart';

add2CalendarFunction(
  String title,
  String description,
  String location,
  DateTime startDate,
  DateTime endDate,
) {
  final Event event = Event(
    title: title,
    description: description,
    location: location,
    startDate: startDate,
    endDate: endDate,
    // iosParams: IOSParams(
    //   reminder: Duration(/* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
    //   url: 'https://www.example.com', // on iOS, you can set url to your event.
    // ),
    // androidParams: AndroidParams(
    //   emailInvites: [], // on Android, you can add invite emails to your event.
    // ),
  );

  Add2Calendar.addEvent2Cal(event);
}
