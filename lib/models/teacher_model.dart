import 'package:acroworld/models/class_event.dart';

class TeacherModel {
  String? id;
  String? name;
  String? confirmationStatus;
  bool? isOrganization;
  String? createdAt;
  String? description;
  String? instagramName;
  String? locationName;
  String? type;
  List<Images>? images;
  String? userId;
  List<UserLikes>? userLikes;

  // get the profile image of the teacher
  String? get profilImgUrl {
    if (images != null) {
      for (Images image in images!) {
        if (image.isProfilePicture == true) {
          return image.image!.url;
        }
      }
    }
    return null;
  }

  TeacherModel(
      {this.id,
      this.name,
      this.confirmationStatus,
      this.isOrganization,
      this.createdAt,
      this.description,
      this.instagramName,
      this.type,
      this.locationName,
      this.images,
      this.userId,
      this.userLikes});

  TeacherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    confirmationStatus = json['confirmation_status'];
    isOrganization = json['is_organization'];
    createdAt = json['created_at'];
    description = json['description'];
    instagramName = json['instagram_name'];
    locationName = json['location_name'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }

    userId = json['user_id'];
    if (json['user_likes'] != null) {
      userLikes = <UserLikes>[];
      json['user_likes'].forEach((v) {
        userLikes!.add(UserLikes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['confirmation_status'] = confirmationStatus;
    data['is_organization'] = isOrganization;
    data['created_at'] = createdAt;
    data['description'] = description;
    data['instagram_name'] = instagramName;
    data['location_name'] = locationName;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }

    data['user_id'] = userId;
    if (userLikes != null) {
      data['user_likes'] = userLikes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? id;
  Image? image;
  bool? isProfilePicture;

  Images({this.id, this.image, this.isProfilePicture});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    isProfilePicture = json['is_profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['is_profile_picture'] = isProfilePicture;
    return data;
  }
}

class Image {
  String? id;
  String? url;

  Image({this.id, this.url});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class TeacherLevels {
  Level? level;

  TeacherLevels({this.level});

  TeacherLevels.fromJson(Map<String, dynamic> json) {
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (level != null) {
      data['level'] = level!.toJson();
    }
    return data;
  }
}

class UserLikes {
  String? userId;

  UserLikes({this.userId});

  UserLikes.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    return data;
  }
}
