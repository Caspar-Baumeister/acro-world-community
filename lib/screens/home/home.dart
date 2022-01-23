import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/communities.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    // the first build time, the userdata regarding the logged in user is fetched
    // and a global state provider is created that contains all the user information
    if (!initialized) {
      setUser();
      setState(() {
        initialized = true;
      });
    }
    return loading ? const Loading() : const Communities();
  }

  Future<void> setUser() async {
    setState(() {
      loading = true;
    });

    // get active user from Firebase Stream
    final User user = Provider.of<User?>(context)!;

    // fetch the information for that user and update the user provider
    Provider.of<UserProvider>(context, listen: false).updateUser(user.uid);

    setState(() {
      loading = false;
    });
  }
}
