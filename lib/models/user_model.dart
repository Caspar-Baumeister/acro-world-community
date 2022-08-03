class User {
  String? id;
  String? name;
  String? imageUrl;
  String? bio;

  User({
    required this.id,
    required this.name,
    this.imageUrl,
    this.bio,
  });

  factory User.fromJson(dynamic json) {
    return User(
      id: json['id'],
      name: json["name"],
      bio: json['bio'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['bio'] = bio;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
