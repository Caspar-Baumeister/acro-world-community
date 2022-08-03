import 'package:acroworld/models/community_messages/community_message.dart';

class CommunityMessages {
  List<CommunityMessage>? communityMessages;

  CommunityMessages({this.communityMessages});

  int get length => communityMessages?.length ?? 0;
  CommunityMessage? operator [](int index) =>
      index >= 0 && index < length ? communityMessages![index] : null;

  CommunityMessages.fromJson(Map<String, dynamic> json) {
    if (json['community_messages'] != null) {
      communityMessages = <CommunityMessage>[];
      json['community_messages'].forEach((v) {
        communityMessages!.add(CommunityMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (communityMessages != null) {
      data['community_messages'] =
          communityMessages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
