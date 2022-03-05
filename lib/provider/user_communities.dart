import 'package:flutter/material.dart';

class UserCommunitiesProvider extends ChangeNotifier {
  List<String> _userCommunities = [];

  List<String> get userCommunities => _userCommunities;

  set userCommunities(List<String> communities) {
    _userCommunities = communities;
    notifyListeners();
  }
}
