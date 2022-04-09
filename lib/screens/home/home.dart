import 'package:acroworld/screens/home/user_info_stream.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // bool loading = true;
  // bool initialized = false;
  // dynamic error;

  @override
  Widget build(BuildContext context) {
    // the first build time, the userdata regarding the logged in user is fetched
    // and a global state provider is created that contains all the user information
    // if (!initialized) {
    //   setUser()
    //       .then((value) => setState(() {
    //             initialized = true;
    //           }))
    //       .catchError((onError) => {error = onError});
    // }
    return const UserInfoStream();
  }

  // Future<void> setUser() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   // get active user from Firebase Stream
  //   final User user = Provider.of<User?>(context)!;

  //   // fetch the information for that user and update the user provider
  //   await Provider.of<UserProvider>(context, listen: false)
  //       .updateUser(user.uid);

  //   setState(() {
  //     loading = false;
  //   });
  // }
}
