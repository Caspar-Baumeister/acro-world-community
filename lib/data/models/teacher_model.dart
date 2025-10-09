import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/user_model.dart';

class TeacherModel {
  String? id;
  String? slug;
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
  User? user;
  bool? likedByUser;
  num? likes;
  String? stripeId;
  bool? isStripeEnabled;
  num? individualCommission;

  /// Get email from user object
  String? get email => user?.email;

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

  List<String> nonProfileImages() {
    List<String> urls = [];
    if (images != null) {
      for (Images image in images!) {
        if (image.isProfilePicture == false) {
          urls.add(image.image!.url!);
        }
      }
    }
    return urls;
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
      this.slug,
      this.images,
      this.userId,
      this.user,
      this.isStripeEnabled,
      this.stripeId,
      this.likedByUser,
      this.individualCommission});

  TeacherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    slug = json['url_slug'];
    confirmationStatus = json['confirmation_status'];
    isOrganization = json['is_organization'];
    createdAt = json['created_at'];
    description = json['description'];
    instagramName = json['instagram_name'];
    locationName = json['location_name'];
    likes = json['user_likes_aggregate']?["aggregate"]?["count"];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }

    userId = json['user_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['user_likes'] != null) {
      likedByUser = json['user_likes'].length > 0 ? true : false;
    }
    stripeId = json['stripe_id'];
    isStripeEnabled = json['is_stripe_enabled'];
    individualCommission = json['individual_commission'];
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
