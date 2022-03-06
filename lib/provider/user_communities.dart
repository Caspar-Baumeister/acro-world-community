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

  Future<void> initialize(communityIds) async {
    String userId = UserIdPreferences.getToken();
    List<Community> communities = [];

    for (String id in communityIds) {
      DocumentSnapshot<Object?> communityObject =
          await DataBaseService(uid: userId).getCommunity(id);
      Community community = Community.fromJson(
          communityObject.id, communityObject.get("next_jam"));
      communities.add(community);
    }
    _userCommunities = communities;
    _userCommunityIds = communityIds;
    _userCommunitiesSearch = List<Community>.from(communities);
    _initialized = true;
    notifyListeners();
  }

  Future<void> update(communityIds) async {
    String userId = UserIdPreferences.getToken();

    // if there is a new element in communityIds, add it to the provider
    for (String id in communityIds) {
      if (!userCommunityIds.contains(id)) {
        // get community from database
        DocumentSnapshot<Object?> communityObject =
            await DataBaseService(uid: userId).getCommunity(id);
        Community community = Community.fromJson(
            communityObject.id, communityObject.get("next_jam"));
        // add to communities
        addToCommunities(community);
      }
    }
    // if there is a community missing, delete it from provider
    for (String id in userCommunityIds) {
      if (!communityIds.contains(id)) {
        // remove to communities
        removeFromCommunities(id);
      }
    }
    // update usercommunityids
    _userCommunityIds = communityIds;

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
