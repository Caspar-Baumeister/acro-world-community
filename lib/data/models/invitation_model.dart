import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/user_model.dart';

class InvitationModel {
  final String id;
  final String? email;
  final String confirmationStatus;
  final String? entity;
  final String createdAt;
  final User? invitedUser;
  final ClassModel? classModel;
  final User? createdBy;

  InvitationModel({
    required this.id,
    this.email,
    required this.confirmationStatus,
    this.entity,
    required this.createdAt,
    this.invitedUser,
    this.classModel,
    this.createdBy,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json['id'],
      email: json['email'],
      confirmationStatus: json['confirmation_status'],
      entity: json['entity'],
      createdAt: json['created_at'],
      invitedUser: json['invited_user'] != null
          ? User.fromJson(json['invited_user'])
          : null,
      classModel:
          json['class'] != null ? ClassModel.fromJson(json['class']) : null,
      createdBy:
          json['created_by'] != null ? User.fromJson(json['created_by']) : null,
    );
  }
}
