import 'dart:convert';
import 'dart:io';

import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/querys.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UserCommunitiesProvider extends ChangeNotifier {
  List<Community> _userCommunities = [];

  List<Community> get userCommunities => _userCommunities;

  bool setDataFromGraphQlResponse(response) {
    try {
      List userCommunities = response["data"]["user_communities"];

      _userCommunities = List<Community>.from(userCommunities.map((com) =>
          Community(
              id: com["community"]["id"],
              nextJam: DateTime.now(),
              name: com["community"]["name"],
              confirmed: true)));
      return true;
    } catch (e) {
      _userCommunities = [];
      print(e.toString());
      return false;
    }
  }

  loadDataFromDatabase(token) async {
    final database = Database(token: token);
    final response = await database.authorizedApi(Querys.userCommunities);
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

// import 'package:acroworld/models/community_model.dart';
// import 'package:acroworld/services/database.dart';
// import 'package:acroworld/services/preferences/user_id.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// // keeps track of all the communities of the user
// class UserCommunitiesProvider extends ChangeNotifier {
//   // user communities and the last date that the user created a jam
//   List<Map> _userCommunityMaps = [];
//   List<String> _userCommunityIds = [];
//   List<Community> _userCommunities = [];
//   // this is the list that users see later also ordered
//   List<Community> _userCommunitiesSearch = [];
//   bool _initialized = false;

//   List<String> get userCommunityIds => _userCommunityIds;
//   List<Map> get userCommunityMaps => _userCommunityMaps;
//   List<Community> get userCommunities => _userCommunities;
//   List<Community> get userCommunitiesSearch => _userCommunitiesSearch;

//   bool get initialized => _initialized;

//   set userCommunityIds(List<String> ids) {
//     _userCommunityIds = ids;
//     notifyListeners();
//   }

//   set userCommunityMaps(List<Map> maps) {
//     _userCommunityMaps = maps;
//     notifyListeners();
//   }

//   set userCommunities(List<Community> communities) {
//     _userCommunities = communities;
//     notifyListeners();
//   }

//   set userCommunitiesSearch(List<Community> communities) {
//     _userCommunitiesSearch = communities;
//     notifyListeners();
//   }

//   set initialized(bool value) {
//     initialized = value;
//     notifyListeners();
//   }

//   void addToCommunities(Community newCommunity) {
//     List<Community> newUserCommunities = List<Community>.from(userCommunities);
//     newUserCommunities.add(newCommunity);
//     userCommunities = newUserCommunities;
//     // notifyListeners();
//   }

//   void removeFromCommunities(String id) {
//     List<Community> newUserCommunities = List<Community>.from(userCommunities);
//     newUserCommunities.removeWhere(((com) => com.id == id));
//     userCommunities = newUserCommunities;
//     // notifyListeners();
//   }

//   void addCommunityAndUpdate(Community newCommunity) {
//     List<Community> newUserCommunities = List<Community>.from(userCommunities);
//     List<String> newUserCommunityIds = List<String>.from(_userCommunityIds);
//     newUserCommunities.add(newCommunity);
//     newUserCommunityIds.add(newCommunity.id);

//     // update
//     userCommunities = newUserCommunities;
//     userCommunityIds = newUserCommunityIds;
//     _userCommunitiesSearch = List<Community>.from(userCommunities);
//     notifyListeners();
//   }

//   Future<void> initialize(List<Map> communityIds) async {
//     String userId = UserIdPreferences.getToken();
//     List<Community> communities = [];

//     for (Map mapId in communityIds) {
//       DocumentSnapshot<Object?> communityObject =
//           await DataBaseService(uid: userId)
//               .getCommunity(mapId["community_id"]);
//       Community community = Community.fromJson(communityObject.id,
//           communityObject.get("next_jam"), communityObject.get("name"));
//       communities.add(community);
//     }
//     _userCommunities = communities;
//     _userCommunityIds =
//         List<String>.from(communityIds.map((Map map) => map["community_id"]));
//     _userCommunityMaps = communityIds;
//     _userCommunitiesSearch = List<Community>.from(communities);
//     _initialized = true;
//     notifyListeners();
//   }

//   // Future<void> update(List<Map> communityIds) async {
//   //   String userId = UserIdPreferences.getToken();

//   //   _userCommunityMaps = communityIds;

//   //   // if there is a new element in communityIds, that is not in userComIds
//   //   // add it to the provider
//   //   for (Map communityMap in communityIds) {
//   //     print(communityMap["community_id"]);
//   //     if (!userCommunityIds.contains(communityMap["community_id"])) {
//   //       // get community from database
//   //       DocumentSnapshot<Object?> communityObject =
//   //           await DataBaseService(uid: userId)
//   //               .getCommunity(communityMap["community_id"]);
//   //       Community community = Community.fromJson(communityObject.id,
//   //           communityObject.get("next_jam"), communityObject.get("name"));
//   //       // add to communities
//   //       addToCommunities(community);
//   //     }
//   //   }
//     // if there is an element in the userComIds that is not in the communityIds
//     // delete it from provider

//     for (String id in userCommunityIds) {
//       bool isIn = false;
//       for (var map in communityIds) {
//         if (map.containsValue(id)) {
//           isIn = true;
//         }
//       }
//       if (!isIn) {
//         removeFromCommunities(id);
//       }
//     }
//     // update usercommunityids
//     _userCommunityIds =
//         List<String>.from(communityIds.map((e) => e["community_id"]));

//     _userCommunitiesSearch = List<Community>.from(_userCommunities);
//     notifyListeners();
//   }

//   void search({String query = ""}) {
//     if (query == "") {
//       _userCommunitiesSearch = List<Community>.from(_userCommunities);
//       return;
//     }
//     final List<Community> searchResults =
//         List<Community>.from(_userCommunities.where((Community community) {
//       final name = community.id.toLowerCase();
//       final searchLower = query.toLowerCase();

//       return name.contains(searchLower);
//     }));

//     _userCommunitiesSearch = searchResults;

//     notifyListeners();
//   }
// }
