import 'package:flutter/material.dart';

class CreatedEventsByMeSection extends StatelessWidget {
  const CreatedEventsByMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("Your Events"),
      ),
    );
  }
}




// class MyEventsProvider extends ChangeNotifier {
//  // loads and keeps track of events that are created by me or where I'm taking place in.
//  // Will
//   bool _loading = true;
//   List<ClassModel> myCreatedEvents = [];

//   // fetch data init
//   MyEventsProvider() {
  
//     fetchMyEvents();
//   }



//   // fetch classevents from the backend in a certain radius of the location
//   Future<void> fetchMyEvents() async {
//     // set loading
//     _loading = true;
//     notifyListeners();

//     QueryOptions queryOptions = QueryOptions(
//       document: Queries.getClassEventsFromToLocationWithClass,
//       fetchPolicy: FetchPolicy.networkOnly,
//       variables: {
//         "from": from.toIso8601String(),
//         "to": to.toIso8601String(),
//         'latitude': place.latLng.latitude,
//         'longitude': place.latLng.longitude,
//         'distance': radius, //distance,
//       },
//     );
//     String selector = 'class_events_by_location_v1';
//     try {
//       QueryResult<Object?> result =
//           await GraphQLClientSingleton().query(queryOptions);

//       if (result.hasException) {
//         CustomErrorHandler.captureException(result.exception!);
//         return;
//       }

//       if (result.data != null && result.data![selector] != null) {
//         _weekClassEvents.clear();
//         try {
//           // Temporary list to hold new events
//           _weekClassEvents = List<ClassEvent>.from(
//             result.data!['class_events_by_location_v1']
//                 .where((json) =>
//                     json['class']?["location"]?["coordinates"] != null)
//                 .map((json) => ClassEvent.fromJson(json)),
//           );
//         } catch (e, s) {
//           CustomErrorHandler.captureException(e, stackTrace: s);
//         }
//       }
//     } catch (e, s) {
//       CustomErrorHandler.captureException(e, stackTrace: s);
//     }

//     // set classevents
//     _loading = false;
//     notifyListeners();
//   }
// }

