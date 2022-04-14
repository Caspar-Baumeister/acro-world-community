import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDBService
    extends FirestoreService<UserDto, CreateUserDto, UpdateUserDto> {
  UserDBService() : super('info');

  @override
  UserDto fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    return UserDto.fromJson(snapshot.data(), snapshot.id);
  }
}
