import 'package:acroworld/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _activeUser;

  UserProvider();

  User? get activeUser {
    return _activeUser;
  }
}
