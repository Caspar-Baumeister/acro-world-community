import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityDBService
    extends FirestoreService<CommunityDto, CommunityDto, CommunityDto> {
  CommunityDBService() : super('communities');

  @override
  CommunityDto fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    return CommunityDto.fromJson(snapshot.data());
  }

  @override
  CommunityDto fromQuerySnapshot(QuerySnapshot<Object?> snapshot) {
    print(snapshot.docs);
    // TODO: implement fromQuerySnapshot
    throw UnimplementedError();
  }
}
