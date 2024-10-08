// import 'package:acroworld/components/wrapper/loggin_wrapper.dart';
// import 'package:acroworld/screens/system_pages/error_page.dart';
// import 'package:acroworld/screens/system_pages/loading_page.dart';
// import 'package:acroworld/screens/system_pages/no_wifi_page.dart';
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// class ConnectionWrapper extends StatelessWidget {
//   const ConnectionWrapper({Key? key}) : super(key: key);

//   // checkes if there are credentials
//   // sends a login request with the credentials
//   // updates the user provider or sends to login

//   @override
//   Widget build(BuildContext context) {
//     // TODO this should only happen in the error page not as a wrapper
//     return FutureBuilder<bool>(
//         future: InternetConnectionChecker().hasConnection,
//         builder: ((context, snapshot) {
//           if (snapshot.hasError) {
//             return ErrorPage(error: "connectionState error: ${snapshot.error}");
//           }

//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.data == true) {
//               return const LogginWrapper();
//             } else {
//               return const NoWifePage();
//             }
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const LoadingPage();
//           } else {
//             return ErrorPage(
//                 error:
//                     "connectionState: ${snapshot.connectionState.toString()}");
//           }
//         }));
//   }
// }
