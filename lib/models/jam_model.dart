import 'package:cloud_firestore/cloud_firestore.dart';

class Jam {
  String createdBy;
  Timestamp createdAt;
  Timestamp takesPlaceAt;
  String location;
  List<String> participant;

  Jam(
      {required this.createdAt,
      required this.createdBy,
      required this.location,
      required this.participant,
      required this.takesPlaceAt});
}
