// create change notifier provider, that only keeps a bool if the user is a creator or not

import 'package:flutter/material.dart';

class UserRoleProvider extends ChangeNotifier {
  bool _isCreator = false;

  bool get isCreator {
    return _isCreator;
  }

  void setIsCreator(bool isCreator) {
    _isCreator = isCreator;
    notifyListeners();
  }
}
