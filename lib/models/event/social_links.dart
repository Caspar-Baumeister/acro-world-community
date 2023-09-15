class SocialLink {
  String? id;
  String? type;
  String? url;

  SocialLink({
    this.id,
    this.type,
    this.url,
  });

  SocialLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['name'];
    url = json['url'];
  }
}
