import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/screens/home/profile/user_profile.dart';
import 'package:acroworld/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfileFutureBuilder extends StatelessWidget {
  const UserProfileFutureBuilder({Key? key, required this.uid})
      : super(key: key);

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
