// import 'package:acroworld/presentation/screens/authentication_screens/authenticate.dart';
// import 'package:acroworld/provider/auth/token_singleton_service.dart';
// import 'package:acroworld/provider/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// logOut(BuildContext context) async {
//   await TokenSingletonService()
//       .logout()
//       .then(
//         (value) => Provider.of<UserProvider>(context, listen: false)
//             .setUserFromToken(),
//       )
//       .then((value) => Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//               builder: (context) => const Authenticate(
//                     initShowSignIn: true,
//                   )),
//           (Route<dynamic> route) => false));
// }
