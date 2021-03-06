import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/services/database.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AllOtherComs extends ChangeNotifier {
  List<Community> _allOtherComs = [];
  bool initialized = false;

  List<Community> get allOtherComs => _allOtherComs;

  bool setDataFromGraphQlResponse(response) {
    try {
      List allOtherComs = response["data"]["communities"];

      _allOtherComs = List<Community>.from(
          allOtherComs.map((com) => Community.fromJson(com)));
      return true;
    } catch (e) {
      _allOtherComs = [];
      return false;
    }
  }

  loadDataFromDatabase(String token, String query) async {
    Map<String, dynamic> parseJwt = Jwt.parseJwt(token);
    final database = Database(token: token);
    final response =
        await database.getAllOtherCommunities(parseJwt['sub'], query);
    // load data with await from api

    setDataFromGraphQlResponse(response);
    initialized = true;

    notifyListeners();
  }
}
