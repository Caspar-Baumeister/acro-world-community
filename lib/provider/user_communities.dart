import 'dart:convert';
import 'dart:io';

import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/services/database.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:path_provider/path_provider.dart';

class UserCommunitiesProvider extends ChangeNotifier {
  List<Community> _userCommunities = [];

  List<Community> get userCommunities => _userCommunities;

  bool setDataFromGraphQlResponse(response) {
    try {
      List userCommunities = response["data"]["communities"];

      _userCommunities = List<Community>.from(userCommunities.map((com) =>
          Community(
              id: com["id"],
              nextJam: DateTime.now(),
              name: com["name"],
              confirmed: true)));
      return true;
    } catch (e) {
      _userCommunities = [];
      print(e.toString());
      return false;
    }
  }

  loadDataFromDatabase(token) async {
    Map<String, dynamic> parseJwt = Jwt.parseJwt(token!);
    final database = Database(token: token);
    final response = await database.getUserCommunities(parseJwt['sub']);
    // load data with await from api

    bool isDataSetSuccess = setDataFromGraphQlResponse(response);

    // if successfull loaded cache data
    if (isDataSetSuccess) {
      String fileName = "userCommunities.json";
      var dir = await getTemporaryDirectory();
      File file = File(dir.path + "/" + fileName);
      file.writeAsStringSync(jsonEncode(response),
          flush: true, mode: FileMode.write);
    }

    notifyListeners();
  }

  // loading the data using cache
  loadData(token) async {
    // load data from cache
    String fileName = "userCommunities.json";
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    Map<String, dynamic> response;
    if (file.existsSync()) {
      // if success and data ligit:

      // set data
      var jsonData = file.readAsStringSync();
      response = jsonDecode(jsonData);
      setDataFromGraphQlResponse(response);

      // notify listener
      notifyListeners();

      // load data from api in background (no await)
      loadDataFromDatabase(token);
      // data = data

    } else {
      // else if cache load not works
      // wait for the database loas
      await loadDataFromDatabase(token);
    }
  }
}
