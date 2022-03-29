import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCommunitiesProvider extends ChangeNotifier {
  List<String> _userCommunityIds = [];
  List<Community> _userCommunities = [];
  // this is the list that users see later also ordered
  List<Community> _userCommunitiesSearch = [];
  bool _initialized = false;

  List<String> get userCommunityIds => _userCommunityIds;
  List<Community> get userCommunities => _userCommunities;
  List<Community> get userCommunitiesSearch => _userCommunitiesSearch;

  bool get initialized => _initialized;

  set userCommunityIds(List<String> ids) {
    _userCommunityIds = ids;
    notifyListeners();
  }

  set userCommunities(List<Community> communities) {
    _userCommunities = communities;
    notifyListeners();
  }

  set userCommunitiesSearch(List<Community> communities) {
    _userCommunitiesSearch = communities;
    notifyListeners();
  }

  set initialized(bool value) {
    initialized = value;
    notifyListeners();
  }

  void addToCommunities(Community newCommunity) {
    List<Community> newUserCommunities = List<Community>.from(userCommunities);
    newUserCommunities.add(newCommunity);
    userCommunities = newUserCommunities;
    // notifyListeners();
  }

  void removeFromCommunities(String id) {
    List<Community> newUserCommunities = List<Community>.from(userCommunities);
    newUserCommunities.removeWhere(((com) => com.id == id));
    userCommunities = newUserCommunities;
    // notifyListeners();
  }

  void addCommunityAndUpdate(Community newCommunity) {
    List<Community> newUserCommunities = List<Community>.from(userCommunities);
    List<String> newUserCommunityIds = List<String>.from(_userCommunityIds);
    newUserCommunities.add(newCommunity);
    newUserCommunityIds.add(newCommunity.id);

    // update
    userCommunities = newUserCommunities;
    userCommunityIds = newUserCommunityIds;
    _userCommunitiesSearch = List<Community>.from(userCommunities);
    notifyListeners();
  }

  Future<void> initialize(List<Map> communityIds) async {
    String userId = UserIdPreferences.getToken();
    List<Community> communities = [];

    for (Map mapId in communityIds) {
      DocumentSnapshot<Object?> communityObject =
          await DataBaseService(uid: userId)
              .getCommunity(mapId["community_id"]);
      Community community = Community.fromJson(
          communityObject.id, communityObject.get("next_jam"));
      communities.add(community);
    }
    _userCommunities = communities;
    _userCommunityIds =
        List<String>.from(communityIds.map((Map map) => map["community_id"]));
    _userCommunitiesSearch = List<Community>.from(communities);
    _initialized = true;
    notifyListeners();
  }

  Future<void> update(List<Map> communityIds) async {
    print("inside update");
    print(userCommunityIds);
    String userId = UserIdPreferences.getToken();

    // if there is a new element in communityIds, that is not in userComIds
    // add it to the provider
    for (Map communityMap in communityIds) {
      print(communityMap["community_id"]);
      if (!userCommunityIds.contains(communityMap["community_id"])) {
        // get community from database
        DocumentSnapshot<Object?> communityObject =
            await DataBaseService(uid: userId)
                .getCommunity(communityMap["community_id"]);
        Community community = Community.fromJson(
            communityObject.id, communityObject.get("next_jam"));
        // add to communities
        addToCommunities(community);
      }
    }
    // if there is an element in the userComIds that is not in the communityIds
    // delete it from provider

    for (String id in userCommunityIds) {
      bool isIn = false;
      for (var map in communityIds) {
        if (map.containsValue(id)) {
          isIn = true;
        }
      }
      if (!isIn) {
        removeFromCommunities(id);
      }
    }
    // update usercommunityids
    _userCommunityIds =
        List<String>.from(communityIds.map((e) => e["community_id"]));

    _userCommunitiesSearch = List<Community>.from(_userCommunities);
    notifyListeners();
  }

  void search({String query = ""}) {
    if (query == "") {
      _userCommunitiesSearch = List<Community>.from(_userCommunities);
      return;
    }
    final List<Community> searchResults =
        List<Community>.from(_userCommunities.where((Community community) {
      final name = community.id.toLowerCase();
      final searchLower = query.toLowerCase();

      return name.contains(searchLower);
    }));

    _userCommunitiesSearch = searchResults;

    notifyListeners();
  }
}
