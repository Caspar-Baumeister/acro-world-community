import 'package:acroworld/models/community_messages/community_message.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:flutter/material.dart';

class UserCommunitiesProvider extends ChangeNotifier {
  List<Community> _userCommunities = [];

  List<Community> get userCommunities => _userCommunities;
  set userCommunities(List<Community> value) {
    _userCommunities = value;
    notifyListeners();
  }

  // getUserCommunityByCommunityId(String cId) {}

  setLastMessage(CommunityMessage message, String cId) {
    for (int i = 0; i < _userCommunities.length; i++) {
      if (_userCommunities[i].id == cId) {
        if (_userCommunities[i].lastMessage != null &&
            _userCommunities[i].lastMessage!.createdAt != message.createdAt) {
          _userCommunities[i].lastMessage = message;
          notifyListeners();
        }
      }
    }
  }
}
