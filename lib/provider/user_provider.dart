// ignore_for_file: avoid_print

import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/services/database.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _activeUser;
  String? _token;
  //List<String> _userCommunities = [];

  // getter
  UserModel? get activeUser => _activeUser;
  String? get token => _token;

  //List<String> get userCommunities => _userCommunities;

  Future<bool> validToken() async {
    if (_token == null) {
      return false;
    }
    if (!tokenIsExpired()) {
      return true;
    }
    return await refreshToken();
  }

  setUserFromToken(String token) {
    _token = token;
    Map<String, dynamic> payload = Jwt.parseJwt(token);

    String userId = payload["https://hasura.io/jwt/claims"]["x-hasura-user-id"];
    final response = Database(token: _token).getUserData(userId);

    print(response);
//     {
//   "data": {
//     "users": [
//       {
//         "bio": null,
//         "id": "51b867eb-9d28-4570-b42a-34359eecb7c0",
//         "name": "Caspar",
//         "image_url": null
//       }
//     ]
//   }
// }
  }

  bool tokenIsExpired() {
    if (token == null) {
      return true;
    }
    return Jwt.isExpired(token!);
  }

  Future<bool> refreshToken() async {
    String? _email = CredentialPreferences.getEmail();
    String? _password = CredentialPreferences.getPassword();

    if (_email == null || _password == null) {
      return false;
    }

    // get the token trough the credentials
    // (invalid credentials) return false
    String? _newToken = await Database().loginApi(_email, _password);
    if (_newToken == null) {
      return false;
    }

    // safe the user to provider
    _token = _newToken;
    return true;
  }
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

//   setUser(Map data) {
//     _activeUser = UserModel.fromJson(data, data["id"]);
//     notifyListeners();
//   }
// }
