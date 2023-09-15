class Pose {
  String? id;
  String? name;

  Pose({
    this.id,
    this.name,
  });

  Pose.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
