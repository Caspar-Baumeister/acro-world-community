import 'package:acroworld/data/models/class_model.dart';

class FavoriteModel {
  String? id;
  String? createdAt;
  String? userId;
  String? classId;
  ClassModel? classObject;

  FavoriteModel({
    this.id,
    this.createdAt,
    this.userId,
    this.classId,
    this.classObject,
  });

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    classId = json['class_id'];
    classObject =
        json['classes'] != null ? ClassModel.fromJson(json['classes']) : null;
  }
}
