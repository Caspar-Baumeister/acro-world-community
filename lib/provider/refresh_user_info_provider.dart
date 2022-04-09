import 'package:flutter/material.dart';

class RefreshUserInfoProvider extends ChangeNotifier {
  notifyFunction() {
    print("notified called");
    notifyListeners();
  }
}
