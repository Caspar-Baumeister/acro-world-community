// import 'package:acroworld/exceptions/missing_user_info_exception.dart';
// import 'package:acroworld/models/user_model.dart';
// import 'package:acroworld/screens/home/profile/user_profile.dart';
// import 'package:acroworld/screens/home/trash/database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class UserProfileFutureBuilder extends StatelessWidget {
//   const UserProfileFutureBuilder({Key? key, required this.uid})
//       : super(key: key);

//   final String uid;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getUser(uid),
//       builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
//         // AsyncSnapshot<Your object type>
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.white,
//               color: Colors.grey[200],
//             ),
//           );
//         }
//         if (snapshot.hasError) {
//           Object? error = snapshot.error;
//           String errorMessage;

//           if (error is MissingUserInfoException) {
//             errorMessage = error.cause;
//           } else {
//             errorMessage = snapshot.error.toString();
//           }

//           return Center(
//             child: Text(
//               errorMessage,
//               textAlign: TextAlign.center,
//             ),
//           );
//         }

//         if (snapshot.hasData) {
//           return UserProfile(user: snapshot.data!);
//         }
//         return Container();
//       },
//     );
//   }

//   Future<User> getUser(String uid) async {
//     DocumentSnapshot<Object?> snapshot =
//         await DataBaseService(uid: uid).getUserInfo();

//     if (snapshot.data() == null) {
//       throw MissingUserInfoException(
//           "Could not retrieve user information. Maybe the user deleted their profile.");
//     }

//     return User.fromJson(snapshot.data(), uid);
//   }
// }
