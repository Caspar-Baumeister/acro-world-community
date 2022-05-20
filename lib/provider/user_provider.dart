// ignore_for_file: avoid_print

import 'package:acroworld/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _activeUser;
  String? token;
  //List<String> _userCommunities = [];

  // getter
  UserModel? get activeUser => _activeUser;
  //List<String> get userCommunities => _userCommunities;

  setUserFromToken(String token) {
    this.token = token;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    print(payload);
  }

  bool tokenIsExpired() {
    if (token == null) {
      return true;
    }
    return Jwt.isExpired(token!);
  }

  // set userCommunities(List<String> communities) {
  //   _userCommunities = communities;
  //   notifyListeners();
  // }

  // addUserCommunities(String communityId) {
  //   if (_userCommunities == null) return;
  //   _userCommunities.add(communityId);
  //   notifyListeners();
  // }

  // set activeUserImgUrl(String imgUrl) {
  //   if (_activeUser == null) return;
  //   UserModel user = _activeUser!;
  //   user.imgUrl = imgUrl;
  //   _activeUser = user;
  //   notifyListeners();
  // }

  // updates the user provider based on the firebase database
  // Future<void> updateUser(String uid) async {
  //   final database = DataBaseService(uid: uid);

  //   //gets the raw user and user communities
  //   DocumentSnapshot<Object?> infoSnapshot = await database.getUserInfo();
  //   QuerySnapshot<Object?> communitiesSnapshot =
  //       await database.getAllUserCommunities();

  //   // Create UserModel
  //   UserModel userModel = UserModel(
  //     uid: uid,
  //     userName: infoSnapshot.get("userName"),
  //     imgUrl: infoSnapshot.get("imgUrl"),
  //     bio: infoSnapshot.get("bio"),
  //     lastCreatedCommunity: infoSnapshot.get("last_proposed_community"),
  //     createdAt: infoSnapshot.get("created_at"),
  //   );

  //   // create user communities list
  //   List<String> communities =
  //       List<String>.from(communitiesSnapshot.docs.map((doc) => doc.id));
  //   //, lastCreatedJamAt: doc.get("last_created_jam_at"))));

  //   _activeUser = userModel;
  //   userCommunities = communities;
  //   notifyListeners();
  // }

  setUser(Map data) {
    _activeUser = UserModel.fromJson(data, data["id"]);
    notifyListeners();
  }
}
