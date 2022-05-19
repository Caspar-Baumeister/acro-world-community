import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataClass {
  List<Community> communities = [
    Community(
        confirmed: true, id: "a", name: "Berlin", nextJam: DateTime.now()),
    Community(
        confirmed: true, id: "b", name: "Hamburg", nextJam: DateTime.now()),
    Community(
        confirmed: true, id: "c", name: "Dresten", nextJam: DateTime.now()),
    Community(
        confirmed: true, id: "d", name: "Ometepe", nextJam: DateTime.now()),
    Community(
        confirmed: true, id: "e", name: "Gleisdreieck", nextJam: DateTime.now())
  ];

  List<Message> messages = [
    Message(
        text: "Hello",
        cid: "a",
        uid: "user",
        userName: "Caspar",
        imgUrl: MORTY_IMG_URL,
        createdAt: Timestamp.now()),
    Message(
        text: "Community",
        cid: "a",
        uid: "user",
        userName: "Caspar",
        imgUrl: MORTY_IMG_URL,
        createdAt: Timestamp.now())
  ];

  String userToken = "wKfeJhf2j343";

  Map userData = {
    "id": "c16b377e-000f-4297-b5fe-bd8ae66d7683",
    "name": "Caspar",
    "img": MORTY_IMG_URL,
    "bio": """
            Why Poor People remain Poor From the Books 
            “I will Teach you to be Rich”, “The Psychology of Money”, 
            “Secret of Millionaire” etc. always teach us few proven Reason why 
            Poor People remain Poor and Rich people able to keep increasing their Wealth
            """
  };

  final now = DateTime.now();
  final kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll({
      for (var item in List.generate(50, (index) => index))
        DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
            item % 4 + 1,
            (index) => Event(
                  Jam(
                    jid: "ji2d",
                    createdAt: DateTime.now(),
                    createdBy: "lksAdfn4390asd",
                    location: "Hamburg",
                    participants: [],
                    date: DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day + 1),
                    name: "Jam nummer $index",
                    imgUrl: MORTY_IMG_URL,
                    info: "Why Poor People remain Poor?",
                    latLng: const LatLng(20.000002, 18.00001),
                  ),
                ))
    });

  List<Jam> jams = [
    Jam(
      jid: "jid",
      createdAt: DateTime.now(),
      createdBy: "lksAdfn4390asd",
      location: "Berlin",
      participants: [],
      date: tomorrow,
      name: "Krasser Jam",
      imgUrl: MORTY_IMG_URL,
      info: "Why Poor People remain Poor?",
      latLng: const LatLng(10.000002, 12.00001),
    ),
    Jam(
      jid: "ji2d",
      createdAt: DateTime.now(),
      createdBy: "lksAdfn4390asd",
      location: "Hamburg",
      participants: [],
      date: tomorrowtomorrow,
      name: "Anderer Jam",
      imgUrl: MORTY_IMG_URL,
      info: "Why Poor People remain Poor?",
      latLng: const LatLng(20.000002, 18.00001),
    ),
  ];
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);
final yesterday = DateTime(now.year, now.month, now.day - 1);
final tomorrow = DateTime(now.year, now.month, now.day + 1);
final tomorrowtomorrow = DateTime(now.year, now.month, now.day + 2);
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

// jams(
//     //String token,
//     ) async {
//   bool _error = false;
//   String _errorMessage = "";

//   final uri = Uri.https("bro-devs.com", "hasura/v1/graphql");

//   final response = await http.post(uri,
//       headers: {
//         'content-type': 'application/json',
//         'authorization': 'Bearer $token'
//       },
//       body: json.encode({
//         'query': '''query MyQuery {
//       jams {
//         name
//             }
//     }
//     '''
//       }));

//   print(response.body);

//   final responseMutation = await http.post(uri,
//       headers: {
//         'content-type': 'application/json',
//         'authorization': 'Bearer $token'
//       },
//       body: json.encode({
//         'query': '''mutation MyMutation {
//   login(input: {email: "foo@bar.com", password: "penis123"}) {
//     token
//   }}
//     '''
//       }));

//   print(responseMutation.body);
// }

// if (response.statusCode == 200) {
//   // post request succeded
//   try {
//     // unpack json data
//     Map<String, dynamic> responseData = jsonDecode(response.body.toString());

//     if (responseData['status'] == 'ok') {
//       // request succeded.
//       _error = false;
//       _errorMessage = "";
//       _blogs = List<BlogModel>.from(
//           responseData["entries"].map((e) => BlogModel.fromJson(e)));
//     } else {
//       // request failed
//       _error = true;
//       if (responseData['status'] == 'error') {
//         _errorMessage = responseData['errormsg'];
//       } else {
//         _errorMessage = "Etwas ist schief gelaufen!";
//       }
//     }
//   } catch (e) {
//     // responded data has wrong form
//     _error = true;
//     _errorMessage = e.toString();
//   }
// } else {
//   // post request failed
//   _error = true;
//   _errorMessage =
//       "Response status: ${response.statusCode}. Etwas ist schief gelaufen!, es könnte an deiner Internetverbindung liegen";
// }
// return {
//   'error': _error,
//   'errorMessage': _errorMessage,
//   'blogs': _blogs,
// };

String community = "12d49687-30e9-4830-80af-737a354e0211";
