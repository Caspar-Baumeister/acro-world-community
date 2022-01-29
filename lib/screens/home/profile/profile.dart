import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: UserInfoProvider(uid: widget.uid),
    );
  }
}

class UserInfoProvider extends StatelessWidget {
  const UserInfoProvider({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserModel(uid),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.grey[200],
          ));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.hasData) {
          return UserProfile(user: snapshot.data!);
        }
        return Container();
      },
    );
  }

  Future<UserModel> getUserModel(String uid) async {
    DocumentSnapshot<Object?> snapshot =
        await DataBaseService(uid: uid).getUserInfo();

    return UserModel.fromJson(snapshot.data(), uid);
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({required this.user, Key? key}) : super(key: key);

  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(user.userName ?? "")],
    );
  }
}
