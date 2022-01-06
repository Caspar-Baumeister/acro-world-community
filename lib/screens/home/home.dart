import 'package:acroworld/screens/home/communities_overview.dart';
import 'package:acroworld/screens/home/settings.dart';
import 'package:acroworld/services/auth.dart';
import 'package:acroworld/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      initialData: null,
      value: DataBaseService().info,
      child: Scaffold(
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
                      MaterialPageRoute(builder: (context) => SettingsPage())),
                  icon: Icon(Icons.person))
            ],
          ),
          body: CommunitiesOverview()),
    );
  }
}
