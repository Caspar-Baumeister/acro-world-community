import 'package:cloud_firestore/cloud_firestore.dart';

class UserCommunityModel {
  String id;
  DateTime lastCreatedJamAt;
  UserCommunityModel({required this.id, required this.lastCreatedJamAt});

  factory UserCommunityModel.fromJson(
      {required String id, required Timestamp lastCreatedJamAt}) {
    return UserCommunityModel(
        id: id, lastCreatedJamAt: lastCreatedJamAt.toDate());
  }
}
