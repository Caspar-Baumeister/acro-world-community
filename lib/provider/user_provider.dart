// ignore_for_file: avoid_print

import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _activeUser;
  List<String>? _userCommunities;

  // getter
  UserModel? get activeUser => _activeUser;
  List<String>? get userCommunities => _userCommunities;

  // setter
  set activeUser(UserModel? user) {
    _activeUser = user;
    notifyListeners();
  }

  set userCommunities(List<String>? communities) {
    _userCommunities = communities;
    notifyListeners();
  }

  addUserCommunities(String communityId) {
    if (_userCommunities == null) return;
    _userCommunities!.add(communityId);
    notifyListeners();
  }

  set activeUserImgUrl(String imgUrl) {
    if (_activeUser == null) return;
    UserModel user = _activeUser!;
    user.imgUrl = imgUrl;
    _activeUser = user;
    notifyListeners();
  }

  Future<void> updateUser(String uid) async {
    final DocumentSnapshot<Object?> snapshot =
        await DataBaseService(uid: uid).getUserInfo();
    // Create UserModel
    UserModel userModel = UserModel(
      uid: uid,
      userName: snapshot.get("userName"),
      imgUrl: snapshot.get("imgUrl"),
      bio: snapshot.get("bio"),
      lastCreatedCommunity: snapshot.get("last_created_community"),
      lastCreatedJam: snapshot.get("last_created_jam"),
    );

    _activeUser = userModel;
    notifyListeners();
  }
}
