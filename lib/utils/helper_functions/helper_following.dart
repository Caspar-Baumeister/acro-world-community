import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:acroworld/provider/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

followButtonClicked(
    bool isLikedState, String uid, String communityID, String? name) async {
  String? token = AuthProvider.token;
  final database = Database(token: token);

  final response = await database.isUserInCommunity(communityID);
  if (isLikedState &&
      response?["data"]?["me"]?[0]?["communities"] != null &&
      response?["data"]?["me"]?[0]?["communities"].isNotEmpty) {
    await database.deleteUserCommunitiesOne(communityID);
    Fluttertoast.showToast(
        msg: "You left the community of $name",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  } else if (!isLikedState &&
      response?["data"]?["me"]?[0]?["communities"] != null &&
      response?["data"]?["me"]?[0]?["communities"].isEmpty) {
    await database.insertUserCommunitiesOne(communityID, uid);
    Fluttertoast.showToast(
        msg: "You joined the community of $name",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
