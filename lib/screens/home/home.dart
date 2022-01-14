import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/communities_stream.dart';
import 'package:acroworld/screens/home/settings/settings.dart';
import 'package:acroworld/services/auth.dart';
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
  final AuthService _auth = AuthService();

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
    return loading
        ? const Loading()
        // TODO the Scaffold should only be in the leaves
        // TODO make a Appbar widget that can be reused in all leaves
        : Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.grey[400],
              elevation: 0,
              title: const Text("HomePage"),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: const Text(
                    "logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        ),
                    icon: const Icon(Icons.person))
              ],
            ),
            body: const CommunitiesStream());
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
