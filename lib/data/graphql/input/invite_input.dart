import 'package:acroworld/data/graphql/input/invite_entity.dart';

class InviteInput {
  final String id;
  final InviteEntity entity;
  final String? invitedUserId;
  final String? email;

  InviteInput({
    required this.id,
    required this.entity,
    this.invitedUserId,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "invited_user_id": invitedUserId,
        "email": email,
        "entity": entity.value,
      };
}
