import 'dart:convert';
import 'dart:io';

import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/graphql/http_api_urls.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// saves a map of jams associated with a community id locally (also in offline mode accesible)
// {cid: [jid: {jamJson}, jid: {jamJson}]}
// get jam (cid)=> List<Jams>
class CommunityJamsProvider extends ChangeNotifier {
  final Map<String, List<Jam>> _jams = {};
  bool inizialized = false;

  loadData(cid, token) async {
    // load data from cache
    Map? response = await loadDataFromFile();

    // if success, set data and fetch actuall data in the background
    if (response != null) {
      List<Jam> jams = decodeJamResponse(response[cid]);
      setData(jams, cid);

      loadDataFromDatabase(cid, token).then((response) {
        List<Jam> jams = decodeJamResponse(response);
        setData(jams, cid);
      });
    } else {
      Map? response = await loadDataFromDatabase(cid, token);
      List<Jam> jams = decodeJamResponse(response);
      setData(jams, cid);
    }
  }

  // get jams one community
  Future<Map> loadDataFromDatabase(cid, token) async {
    final database = Database(token: token);
    return await database.getCommunityJams(cid);
  }

  setData(List<Jam> jams, cid) {
    _jams[cid] = jams;
    inizialized = true;
    notifyListeners();
  }

  // get jam list from response json
  List<Jam> decodeJamResponse(response) {
    try {
      List jamsJson = response["data"]["jams"];

      return List<Jam>.from(jamsJson.map((jam) => Jam.fromJson(jam)));
    } catch (e) {
      return [];
    }
  }

  Future<Map?> loadDataFromFile() async {
// load data from cache
    String fileName = "communityJams.json";
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    Map<String, dynamic> response;
    if (file.existsSync()) {
      // if success and data ligit:

      // set data
      var jsonData = file.readAsStringSync();
      return jsonDecode(jsonData);
    } else {
      return null;
    }
  }

  Future writeDataToFile(json) async {
    String fileName = "communityJams.json";
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    file.writeAsStringSync(jsonEncode(json), flush: true, mode: FileMode.write);
  }
}
