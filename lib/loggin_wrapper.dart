// import 'package:acroworld/screens/authenticate/authenticate.dart';
// import 'package:acroworld/screens/verify_email_guard.dart';
// import 'package:acroworld/shared/loading_scaffold.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // listens to the Firebase User provider.
// // if a user is logged in, show home. Otherwise authentication
// class Wrapper extends StatelessWidget {
//   const Wrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // this is a firebase user object listened to by authchange stream in main
//     final User? user = Provider.of<User?>(context, listen: true);
//     return FutureBuilder(
//         future: loadToken(user, context),
//         builder: ((context, snapshot) {
//           if (snapshot.hasError) {
//             return const Authenticate();
//           }
//           if (snapshot.hasData) {
//             if (snapshot.data == true) {
//               return const VerifyEmailGuard();
//             } else {
//               return const Authenticate();
//             }
//           }
//           return const LoadingScaffold();
//         }));

//     // return either Home or Authenticate Widget
//     // return (user != null) ? const VerifyEmailGuard() : ;
//   }

//   Future<bool> loadToken(User? user, BuildContext context) async {
//     String? token = await user?.getIdToken();
//     bool returnBool = false;

//     if (token != null && token != "") {
//       returnBool = true;
//     }

//     return returnBool;
//   }
// }

import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/communities/user_communities/user_communities.dart';
import 'package:acroworld/shared/error_page.dart';
import 'package:acroworld/shared/loading_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogginWrapper extends StatefulWidget {
  const LogginWrapper({Key? key}) : super(key: key);

  // checkes if there are credentials
  // sends a login request with the credentials
  // updates the user provider or sends to login

  @override
  State<LogginWrapper> createState() => _LogginWrapperState();
}

class _LogginWrapperState extends State<LogginWrapper> {
  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future:
            Provider.of<UserProvider>(context, listen: false).refreshToken(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            //Provider.of<User?>(context)?.reload();
            return ErrorScreenWidget(error: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            if (snapshot.data == false) {
              return const Authenticate();
            } else {
              return const UserCommunities();
            }
          }

          return const LoadingScaffold();
        }));
  }

  Future<bool> checkCredentials() async {
    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).refreshToken();

    if (!isValidToken) {
      return false;
    }

    await Provider.of<UserProvider>(context, listen: false).setUserFromToken();
    return true;
  }
}
