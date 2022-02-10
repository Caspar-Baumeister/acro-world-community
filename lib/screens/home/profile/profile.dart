import 'package:acroworld/screens/home/profile/user_profile_future_builder.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({required this.uid, Key? key}) : super(key: key);

  final String uid;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        leading: const BackButton(color: Colors.black),
      ),
      body: UserProfileFutureBuilder(uid: widget.uid),
    );
  }
}
