// import 'package:acroworld/provider/user_provider.dart';
// import 'package:acroworld/screens/home/communities/user_communities/user_communities.dart';
// import 'package:acroworld/shared/error_page.dart';
// import 'package:acroworld/shared/loading_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // fetches the User data (set initialized to true to update the user)
// class Home extends StatelessWidget {
//   const Home({Key? key}) : super(key: key);

// //   @override
// //   State<Home> createState() => _HomeState();
// // }

// // class _HomeState extends State<Home> {
//   // bool loading = true;
//   // bool initialized = false;
//   // dynamic error;

//   @override
//   Widget build(BuildContext context) {
//     UserProvider user = Provider.of<UserProvider>(context, listen: false);
//     // the first build time, the userdata regarding the logged in user is fetched
//     // and a global state provider is created that contains all the user information
//     return FutureBuilder<bool>(
//         future: setUser(context, user),
//         builder: ((context, snapshot) {
//           if (snapshot.hasError) {
//             return ErrorPage(error: snapshot.error.toString());
//           }
//           if (snapshot.hasData) {
//             return const UserCommunities();
//           }

//           return const LoadingScaffold();
//         }));
//     // if (!initialized) {
//     //   setUser()
//     //       .then((value) => setState(() {
//     //             initialized = true;
//     //           }))
//     //       .catchError((onError) => {error = onError});
//     // }
//     // if (loading) {
//     //   return const LoadingScaffold();
//     // }
//     // return const UserCommunitiesStream();
//   }

//   // Future<bool> setUser(BuildContext context, UserProvider userProvider) async {
//   //   // get active user from Firebase Stream
//   //   final User user = Provider.of<User?>(context)!;

//   //   // fetch the information for that user and update the user provider
//   //   await userProvider.updateUser(user.uid);
//   //   return true;
//   // }
// }
